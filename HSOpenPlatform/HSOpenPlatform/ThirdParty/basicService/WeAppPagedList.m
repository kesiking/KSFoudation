//
//  TBCAPagedList.m
//  TBWeiTao
//
//  Created by 逸行 on 14-3-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "WeAppPagedList.h"
#import "WeAppComponentBaseItem.h"
#import "NSString+WeAppComponentBaseItem.h"

@implementation WeAppPagedList

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCAPageList overloaded method

-(LongTimeType)timestampWithObject:(id)object {
    
    if ([object valueForKey:@"timestamp"]) {
        return [[object valueForKey:@"timestamp"] weappUnsignedLongLongValue];
    }else if ([object valueForKey:@"time"]) {
        return [[object valueForKey:@"time"] weappUnsignedLongLongValue];
    }else if ([object respondsToSelector:@selector(timestamp)]) {
        return [[object valueForKey:@"timestamp"] weappUnsignedLongLongValue];
    }else if ([object respondsToSelector:@selector(time)]) {
        return [[object valueForKey:@"time"] weappUnsignedLongLongValue];
    }
    
    return 0;
}

-(NSString*)idValue:(id)object {
    if ([object valueForKey:@"id"]) {
        return [[object valueForKey:@"id"] stringValue];
    }else if ([object respondsToSelector:@selector(id)]) {
        return [[object valueForKey:@"id"] stringValue];
    }
    
    return @"";
}

-(LongTimeType)timestampAtIndex:(NSInteger)index{
    if (self.count <= 0) {
        return 0ull;
    }
    
    if ([self objectAtIndex:index]) {
        id obj = [self objectAtIndex:index];
        
        if ([obj valueForKey:@"timestamp"]) {
            return [[obj valueForKey:@"timestamp"] weappUnsignedLongLongValue];
        }else if ([obj respondsToSelector:@selector(timestamp)]) {
            return [[obj valueForKey:@"timestamp"] weappUnsignedLongLongValue];
        }
        
        if ([obj valueForKey:@"time"]) {
            return [[obj valueForKey:@"time"] weappUnsignedLongLongValue];
        }else if ([obj respondsToSelector:@selector(time)]) {
            return [[obj valueForKey:@"time"] weappUnsignedLongLongValue];
        }
    }
    
    
    return 0ull;
}

-(LongIdType)itemIdAtIndex:(NSInteger)index{
    if (self.count <= 0) {
        return 0ull;
    }
    
    if ([self objectAtIndex:index]) {
        id obj = [self objectAtIndex:index];
        
        if ([obj valueForKey:@"id"]) {
            return [[obj valueForKey:@"id"] weappUnsignedLongLongValue];
        }else if ([obj respondsToSelector:@selector(id)]) {
            return [[obj valueForKey:@"id"] weappUnsignedLongLongValue];
        }
    }
    return 0ull;
}

//根据object刷新pagelist数据
-(void)refreshPageListWithObject:(id)object{
    if (object == nil || ![object isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if (self.listPath == nil) {
        self.listPath = @"list";
    }
    
    NSArray *keyChains = [self.listPath componentsSeparatedByString:@"."];
    
    if(keyChains == nil || [keyChains count] == 0){
        return;
    }
    
    BOOL valueDidExist = YES;
    id objectTmp = object;
    for(NSString* key in keyChains){
        if (key == nil || objectTmp == nil || ![objectTmp isKindOfClass:[NSDictionary class]]) {
            valueDidExist = NO;
            break;
        }
        objectTmp = [objectTmp objectForKey:key];
    }
    
    if(!valueDidExist){
        return;
    }
    
    if (IS_NULL(objectTmp)) {
        return;
    }
    
    id arrayObject = objectTmp;
    
    if (arrayObject == nil || ![arrayObject isKindOfClass:[NSArray class]]) {
        return;
    }
    
    [self removeAllObjects];
    [self addObjectsFromArray:arrayObject];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSPageListProtocol method

//是否需要底层解析pageList数据，默认返回YES，由底层统一解析，否则由TBSNSPagedList子类解析
-(BOOL)shouldPageListParse{
    return NO;
}

//开始解析前调用
-(void)willParsedPageListWithJsonValue:(NSDictionary*)jsonValue{
    [super willParsedPageListWithJsonValue:jsonValue];
}

//解析调用
-(void)parsePageListWithJsonValue:(NSDictionary*)jsonValue{
    [super parsePageListWithJsonValue:jsonValue];
    if (jsonValue == nil || ![jsonValue isKindOfClass:[NSDictionary class]]) {
        self.newDataCount = 0;
        return;
    }
    
    if ([jsonValue count] <= 0) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    NSDictionary *myDataJosnValue = jsonValue;
    
    if ([myDataJosnValue objectForKey:@"timestamp"]) {
        self.pagination.timestamp = [[myDataJosnValue objectForKey:@"timestamp"] longLongValue];
    }
    
    if ([myDataJosnValue objectForKey:@"totalCount"]) {
        self.totalCount = [[myDataJosnValue objectForKey:@"totalCount"] intValue];
    }
    
    if(self.pagination == nil) {
        self.pagination = [[WeAppPaginationItem alloc]init];
    }
    
    if ([myDataJosnValue objectForKey:@"paginationType"]) {
        self.pagination.paginationType = [[myDataJosnValue objectForKey:@"paginationType"] intValue];
    }
    
    if ([myDataJosnValue objectForKey:@"pageSize"]) {
        self.pagination.pageSize = [[myDataJosnValue objectForKey:@"pageSize"] intValue];
    }
    
    if (self.listPath == nil) {
        self.listPath = @"list";
    }
    
    id object = [myDataJosnValue objectForKey:self.listPath];
    
    if (IS_NULL(object)) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    id arrayObject = object;
    
    if (arrayObject == nil || ![arrayObject isKindOfClass:[NSArray class]]) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    NSArray *newDataList = nil;
    
    if (self.itemClass != nil && [self.itemClass isSubclassOfClass:[WeAppComponentBaseItem class]]) {
        newDataList = [self.itemClass modelArrayWithJSON:object];
    }else{
        newDataList = (NSArray*)arrayObject;
    }
    
    if (newDataList == nil) {
        self.newDataCount = 0;
        [self noDataPageListlogic];
        return;
    }
    
    if ([self isRefresh]) {
        //如果是刷新就将老数据清除掉
        if (self.isForceRecordAllObject && newDataList.count < self.pagination.pageSize) {
            self.isForceRecordAllObject = NO;
            NSRange range =NSMakeRange(0, [newDataList count]);
            [self insertObjects:newDataList atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            
        }else{
            [self removeAllObjects];
            [self addObjectsFromArray:newDataList];
        }
        
    }else {
        
        [self paginationPlus];
        [self addObjectsFromArray:newDataList];
    }
    
    // 设置newDataCount
    self.newDataCount = newDataList.count;
    
    self.isNeedRefresh = NO;
    if ([self isRefresh] && newDataList.count > 0) {
        self.isNeedRefresh = YES;
    }
}

//解析完后调用
-(void)didFinishedParsedPageListWithJsonValue:(NSDictionary*)jsonValue{
    [super didFinishedParsedPageListWithJsonValue:jsonValue];
}

-(void)noDataPageListlogic{
    // 没有数据逻辑
    if ([self isRefresh]) {
        //如果是刷新就将老数据清除掉
        if (self.isForceRecordAllObject) {
            self.isForceRecordAllObject = NO;
        }else{
            [self removeAllObjects];
        }
    }
}

-(void)dealloc{
    self.jsonValue = nil;
    [self reset];
}

@end
