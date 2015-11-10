//
//  TBSNSJsonUtil.m
//  Taobao2013
//
//  Created by 神逸 on 13-1-28.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppJsonUtil.h"
#import "WeAppUtils.h"
#import "WeAppBasicPagedList.h"
#import "WeAppComponentBaseItem.h"


@implementation WeAppJsonUtil

+(id)parseJson:(NSObject *)dataJosnValue toObject:(NSObject *)object withObjectClass:(Class)objectClass  withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass params:(NSDictionary*)params{
    switch (dataType) {
        case WeAppDataTypeItem:
        {
            if (![dataJosnValue isKindOfClass:[NSDictionary class]] || [WeAppUtils isEmpty:dataJosnValue]) {
                return nil;
            }
            
            if (itemClass) {
                if ([itemClass isSubclassOfClass:[WeAppComponentBaseItem class]]) {
                    return [itemClass modelWithJSON:(NSDictionary*)dataJosnValue];
                }else{
                    return (NSDictionary*)dataJosnValue;
                }
                
            }else {
                return [WeAppComponentBaseItem modelWithJSON:(NSDictionary*)dataJosnValue];
            }
            
        }
            break;
        case WeAppDataTypeArray:
        {
            if (![dataJosnValue isKindOfClass:[NSArray class]] || [WeAppUtils isEmpty:dataJosnValue]) {
                return nil;
            }
            
            NSArray* jsonValue = (NSArray*)dataJosnValue;
            
            return [itemClass modelArrayWithJSON:jsonValue];
        }
            break;
        case WeAppDataTypePagedList:
        {
            if (![dataJosnValue isKindOfClass:[NSDictionary class]] || [WeAppUtils isEmpty:dataJosnValue]) {
                return nil;
            }
            
            NSDictionary * myDataJosnValue = (NSDictionary*)dataJosnValue;
            
            WeAppBasicPagedList *pagedList = (WeAppBasicPagedList*)object;
            int oldPagedListCount = (int)pagedList.count;
            
            if ([WeAppUtils isNotEmpty:myDataJosnValue]) {
                
                if (pagedList == nil) {
                    //如果objectClass是TBSNSPagedList的子类，则初始化objectClass，否则沿用TBSNSPagedList
                    if (objectClass != nil && [objectClass isSubclassOfClass:[WeAppBasicPagedList class]]) {
                        pagedList = [[objectClass alloc]init];
                        pagedList.itemClass = itemClass;
                    }else{
                        pagedList = [[WeAppBasicPagedList alloc]init];
                    }
                    NSString *listPath = nil;
                    if (params && [params isKindOfClass:[NSDictionary class]]) {
                        listPath = [params objectForKey:@"listPath"];
                    }
                    if (listPath) {
                        [pagedList setListPath:listPath];
                    }
                }
                
                if ([pagedList respondsToSelector:@selector(willParsedPageListWithJsonValue:)]) {
                    [pagedList willParsedPageListWithJsonValue:myDataJosnValue];
                }
                
                //如果pagedList子类定义了shouldPageListParse且返回NO表示由pagedList子类解析数据
                if ([pagedList respondsToSelector:@selector(shouldPageListParse)] && ![pagedList shouldPageListParse]) {
                    if ([pagedList respondsToSelector:@selector(parsePageListWithJsonValue:)]) {
                        [pagedList parsePageListWithJsonValue:myDataJosnValue];
                    }
                }else{
                    if ([myDataJosnValue objectForKey:@"timestamp"]) {
                        pagedList.pagination.timestamp = [[myDataJosnValue objectForKey:@"timestamp"] longLongValue];
                    }
                    
                    if ([myDataJosnValue objectForKey:@"totalCount"]) {
                        pagedList.totalCount = [[myDataJosnValue objectForKey:@"totalCount"] intValue];
                    }
                    
                    if(pagedList.pagination == nil) {
                        pagedList.pagination = [[WeAppPaginationItem alloc]init];
                    }
                    
                    if ([myDataJosnValue objectForKey:@"pageSize"]) {
                        pagedList.pagination.pageSize = [[myDataJosnValue objectForKey:@"pageSize"] intValue];
                    }
                    
                    if (IS_NULL([myDataJosnValue objectForKey:@"list"])) {
                        pagedList.newDataCount = 0;
                        return pagedList;
                    }
                    
                    if ([pagedList respondsToSelector:@selector(parsePageListWithJsonValue:)]) {
                        [pagedList parsePageListWithJsonValue:myDataJosnValue];
                    }
                    
                    if (!itemClass) {
                        pagedList.newDataCount = 0;
                        return pagedList;
                    }
                    NSArray *newDataList = [itemClass modelArrayWithJSON:[myDataJosnValue objectForKey:@"list"]];
                    
                    if (newDataList == nil) {
                        pagedList.newDataCount = 0;
                        return pagedList;
                    }
                    
                    if ([pagedList isRefresh]) {
                        if (pagedList.isForceRemoveAllObject) {
                            //临时添加一个标志供强制清楚数据，用于清除不需要的老数据
                            pagedList.isForceRemoveAllObject = NO;
                            [pagedList removeAllObjects];
                        }
                        //如果是刷新就将老数据清除掉
                        if (pagedList.isForceRecordAllObject) {
                            pagedList.isForceRecordAllObject = NO;
                            NSRange range =NSMakeRange(0, [newDataList count]);
                            [pagedList insertObjects:newDataList atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
                            
                        }else{
                            [pagedList removeAllObjects];
                            [pagedList addObjectsFromArray:newDataList];
                        }
                        
                    }else {
                        
                        [pagedList paginationPlus];
                        [pagedList addObjectsFromArray:newDataList];
                    }
                    
                    // 设置newDataCount
                    pagedList.newDataCount = newDataList.count;
                    
                    pagedList.isNeedRefresh = NO;
                    if ([pagedList isRefresh] && oldPagedListCount > 0 && newDataList.count > 0) {
                        pagedList.isNeedRefresh = YES;
                    }
                }
                
                if ([pagedList respondsToSelector:@selector(didFinishedParsedPageListWithJsonValue:)]) {
                    [pagedList didFinishedParsedPageListWithJsonValue:myDataJosnValue];
                }
                
                return pagedList;
            }
        }
            break;
        case WeAppDataTypeNumber:
        {
            if ([dataJosnValue isKindOfClass:[NSNumber class]]) {
                return (NSNumber*)dataJosnValue;
            }else if ([dataJosnValue isKindOfClass:[NSString class]]){
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                return [numberFormatter numberFromString:(NSString*)dataJosnValue];
            }
        }
            break;
        case WeAppDataTypeObject:
            return dataJosnValue;
            break;
        default:
            break;
    }
    
    return nil;
}

// dataJosnValue为要解析的json数据
// object：该属性目前仅用于分页数据，因为之前的数据不能丢弃，要将新数据添加到老数据的后面
// objectClass: 用于描述分页数据的类名，动态生成pageList的子类
// dataType：最终返回的数据类型，详见TBSNSDataType
// itemClass：如果dataType为TBSNSDataTypeItem，则itemClass为返回数据的类型；如果dataType为TBSNSDataTypeArray或TBSNSDataTypePagedList，则itemClass为数组中元素的类型

+(id)parseJson:(NSObject *)dataJosnValue toObject:(NSObject *)object withObjectClass:(Class)objectClass  withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass{
    return [self parseJson:dataJosnValue toObject:object withObjectClass:objectClass withDataType:dataType itemClass:itemClass params:nil];
}


+(id)parseJson:(NSObject *)dataJosnValue toObject:(NSObject *)object withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass {
    
    return [self parseJson:dataJosnValue toObject:object withObjectClass:[WeAppBasicPagedList class] withDataType:dataType itemClass:itemClass];
    
}

+(NSString *)object2JsonString:(NSObject *)object {
    
    if ([WeAppUtils isEmpty:object]) {
        return nil;
    }
    
    if ([object isKindOfClass:[WeAppComponentBaseItem class]]) {
        return @"";
    }
    
    if ([object class] == [WeAppBasicPagedList class]) {
        WeAppBasicPagedList *pagedList = (WeAppBasicPagedList*)object;
        
        if (pagedList == nil && pagedList.count <= 0) {
            return nil;
        }
        
        NSMutableString *jsonString = [NSMutableString stringWithString:@"{"];
        
        [jsonString appendFormat:@"\"totalCount\":%ld",pagedList.totalCount];
        [jsonString appendFormat:@",\"timestamp\":%lld",pagedList.pagination.timestamp];
        
        [jsonString appendFormat:@",\"followCount\":%lu",pagedList.followCount];
        
        if (pagedList.pagination) {
            [jsonString appendFormat:@",\"paginationType\":%d",pagedList.pagination.paginationType];
            [jsonString appendFormat:@",\"pageSize\":%d",pagedList.pagination.pageSize];
        }
        //add list
        [jsonString appendFormat:@",\"list\":["];
        
        for (NSInteger i=0; i<pagedList.count; i++) {
            NSString *itemStr = @"";
            if (itemStr == nil) {
                continue;
            }
            [jsonString appendString:itemStr];
            if (i < pagedList.count - 1) {
                [jsonString appendFormat:@","];
            }
        }
        [jsonString appendString:@"]}"];
        
        return jsonString;
    }
    
    if ([object isKindOfClass: [NSArray class]]) {
        NSArray *array = (NSArray*)object;
        
        if ([WeAppUtils isEmpty:array]) {
            return nil;
        }
        
        NSMutableString *jsonString = [NSMutableString stringWithString:@"["];
        
        for (int i=0; i<array.count; i++) {
            NSString *itemStr = @"";
            if (itemStr == nil) {
                continue;
            }
            [jsonString appendString:itemStr];
            if (i < array.count - 1) {
                [jsonString appendFormat:@","];
            }
        }
        [jsonString appendString:@"]"];
        
        return jsonString;
    }
    
    if ([object class] == [NSNumber class]) {
        NSNumber *number = (NSNumber*)object;
        
        return [number stringValue];
    }
    
    return nil;
}

@end
