//
//  TBSNSItemList.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//


#import "WeAppBasicPagedList.h"
#import "NSString+WeAppComponentBaseItem.h"

@interface WeAppBasicPagedList()

@property (nonatomic, strong) NSMutableArray*   deleteArray;

@end

@implementation WeAppBasicPagedList
@synthesize itemClass = _itemClass;


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSMutableArray

+ (WeAppBasicPagedList*)array {
    WeAppBasicPagedList* itemList = [[WeAppBasicPagedList alloc] init];
    return itemList;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (id)init {
    if (self = [super init]) {
        _pagination = [[WeAppPaginationItem alloc] init];
        _deleteArray = [[NSMutableArray alloc] init];
        self.isRefresh = YES;
        self.isForceRemoveAllObject = NO;
        self.isForceRecordAllObject = NO;
        self.isNeedRefresh = NO;
        self.listPath = @"list";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)reset {
    self.isNeedRefresh = NO;
    self.contentoffset = CGPointZero;
    [_pagination reset];
    [_deleteArray removeAllObjects];
    [super reset];
}

-(BOOL)hasMore {
    // 或者上次操作是刷新
    // newDataCount大于pageSize
    if ([self count] >= 1000) {
        //当前pagelist翻页超过1000个不再翻页
        return NO;
    }
    return [self isRefresh] || self.newDataCount  > 0;
//    return [self isRefresh] || self.newDataCount >= _pagination.pageSize;
}

-(void)paginationPlus{
    [_pagination paginationPlus];
}

-(BOOL)addNeedRemoveDataToArray:(id)object{
    if (_deleteArray == nil) {
        return NO;
    }
    if (object == nil) {
        return NO;
    }
    [_deleteArray addObject:object];
    return YES;
}

-(BOOL)hasRepeatData{
    if (_deleteArray && [_deleteArray count] > 0) {
        return YES;
    }
    
    return NO;
}

-(void)deleteRepeatData{
    if (_deleteArray && [_deleteArray count] > 0) {
        [self removeObjectsInArray:_deleteArray];
        [_deleteArray removeAllObjects];
    }
}

//-(BOOL)isRefresh {
//    if (_pagination.paginationType == TBSNSPaginationTypeDefault) {
//        return [_pagination curPage] == 0;
//        
//    }else if(_pagination.paginationType == TBSNSPaginationTypeTimeStamp){
//        return [_pagination beforTimestamp] == 0;
//    }
//    
//    return NO;
//}

-(void)refresh {
    if (_pagination.paginationType == WeAppPaginationTypeDefault) {
        _pagination.isTimestampEnable = NO;
        _pagination.curPage = 0;
        _pagination.reallyCurpage = 0;
        
    }else if(_pagination.paginationType == WeAppPaginationTypeTimeStamp){
        _pagination.beforTimestamp = 0;
        
        if (_pagination.useTimesatmpAsReference) {
            _pagination.afterTimestamp = [self timestampAtIndex:0];
        }else {
            _pagination.afterTimestamp = 0;
        }
        
        _pagination.direction = WeAppPaginationDirectionRefresh;
    }else if(_pagination.paginationType == WeAppPaginationTypeId){
        _pagination.id = [self itemIdAtIndex:0];
        _pagination.direction = WeAppPaginationDirectionRefresh;
    }else if(_pagination.paginationType == WeAppPaginationTypeALL){
        
        _pagination.isTimestampEnable = NO;
        _pagination.curPage = 0;
        _pagination.reallyCurpage = 0;
        
        _pagination.beforTimestamp = 0;
        if (_pagination.useTimesatmpAsReference) {
            _pagination.afterTimestamp = [self timestampAtIndex:0];
        }else {
            _pagination.afterTimestamp = 0;
        }
        
        _pagination.id = [self itemIdAtIndex:0];
        _pagination.direction = WeAppPaginationDirectionRefresh;
    }
    
    self.isRefresh = YES;
    self.contentoffset = CGPointZero;
}

-(void)refreshWithBlock:(IsObjectEnableBlock)isObjectEnableBlock{
    if (_pagination.paginationType == WeAppPaginationTypeDefault) {
        _pagination.isTimestampEnable = NO;
        _pagination.curPage = 0;
        _pagination.reallyCurpage = 0;
        
    }else if(_pagination.paginationType == WeAppPaginationTypeTimeStamp){
        _pagination.beforTimestamp = 0;
        if (_pagination.useTimesatmpAsReference) {
            if (isObjectEnableBlock == nil) {
                _pagination.afterTimestamp = [self timestampAtIndex:0];
            }else{
                if (self.count > 0) {
                    NSUInteger index = 0;
                    for (; index < self.count - 1; index++) {
                        id object = [self objectAtIndex:index];
                        if (isObjectEnableBlock(object)) {
                            break;
                        }
                    }
                    _pagination.afterTimestamp = [self timestampAtIndex:index];
                }else{
                    _pagination.afterTimestamp = 0ull;
                }
            }
        }else {
            _pagination.afterTimestamp = 0;
        }
        
        _pagination.direction = WeAppPaginationDirectionRefresh;
    }
    
    self.isRefresh = YES;
    self.contentoffset = CGPointZero;
}

-(void)nextPage {
    if (_pagination.paginationType == WeAppPaginationTypeDefault) {
        _pagination.isTimestampEnable = YES;
        _pagination.curPage ++;
    }else if(_pagination.paginationType == WeAppPaginationTypeTimeStamp){
        _pagination.beforTimestamp = [self timestampAtIndex:self.count - 1];
        _pagination.direction = WeAppPaginationDirectionNextPage;
    }else if(_pagination.paginationType == WeAppPaginationTypeId) {
        _pagination.id = [self itemIdAtIndex:self.count - 1];
        _pagination.direction = WeAppPaginationDirectionNextPage;
    }else if(_pagination.paginationType == WeAppPaginationTypeALL){
        
        _pagination.isTimestampEnable = YES;
        _pagination.curPage ++;
        
        _pagination.beforTimestamp = [self timestampAtIndex:self.count - 1];
        
        _pagination.id = [self itemIdAtIndex:self.count - 1];
        
        _pagination.direction = WeAppPaginationDirectionNextPage;
    }
    
    self.isRefresh = NO;
}

-(void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock{
    if (_pagination.paginationType == WeAppPaginationTypeDefault) {
        _pagination.isTimestampEnable = YES;
        _pagination.curPage ++;
    }else if(_pagination.paginationType == WeAppPaginationTypeTimeStamp){
        if (isObjectEnableBlock == nil) {
            _pagination.beforTimestamp = [self timestampAtIndex:self.count - 1];
        }else{
            if (self.count > 0) {
                NSUInteger index = self.count - 1;
                for (; index > 0; index--) {
                    id object = [self objectAtIndex:index];
                    if (isObjectEnableBlock(object)) {
                        break;
                    }
                }
                _pagination.beforTimestamp = [self timestampAtIndex:index];
            }else{
                _pagination.beforTimestamp = 0ull;
            }
        }
        _pagination.direction = WeAppPaginationDirectionNextPage;
    }
    
    self.isRefresh = NO;
}

-(void)unique {
    if (self.count <= 0) {
        return;
    }
    
    id obj1 = [self objectAtIndex:0];
    if (obj1 == nil || ![obj1 respondsToSelector:@selector(id)]) {
        return;
    }
    
    __block WeAppBasicPagedList *tempSelf = self;
    [self uniqueWithBlock:^BOOL(id obj1, id obj2) {
        return [[tempSelf idValue:obj1] isEqualToString:[tempSelf idValue:obj2]];
    } ];
}

-(void)uniqueWithBlock:(IsSameObjectCompareBlock)isSameObjectCompareBlock {
    if (self.count <= 0) {
        return;
    }
    [_deleteArray removeAllObjects];
    
    if ([self newDataCount] <= [self count]) {
        for (int i = 0; i < [self newDataCount];i++) {
            id obj1 = [self objectAtIndex:i];
            for (int j = i + 1; j < [self count]; j ++ ) {
                id obj2 = [self objectAtIndex:j];
                if (isSameObjectCompareBlock(obj1,obj2)) {
                    if (obj2) {
                        [_deleteArray addObject:obj2];
                    }
//                    break;
                }
            } 
        }
    }else{
        for (int i = 0; i < [self count];i++) {
            id obj1 = [self objectAtIndex:i];
            for (int j = i + 1; j < [self count]; j ++ ) {
                id obj2 = [self objectAtIndex:j];
                if (isSameObjectCompareBlock(obj1,obj2)) {
//                    [self removeObjectAtIndex:j];
                    if (obj2) {
                        [_deleteArray addObject:obj2];
                    }
                    break;
                }
            } 
        }
 
    }
    
}

-(void)orderUsingComparator:(NSComparator)cmptr {
    if (self.count <= 0) {
        return;
    }
    
    NSArray *array = [self sortedArrayUsingComparator:cmptr];
    
    if (array) {
        [self removeAllObjects];
        [self addObjectsFromArray:array];
    }
    
}

-(void)orderByTimestampDesc {
    if (self.count <= 0) {
        return;
    }
    
    id obj1 = [self objectAtIndex:0];
    if (obj1 == nil || [self timestampWithObject:obj1] == 0) {
        return;
    }
    
    NSComparator cmptr = ^(id obj1, id obj2){
        LongTimeType time1 = [self timestampWithObject:obj1];
        LongTimeType time2 = [self timestampWithObject:obj2];
        
        if (time1 > time2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (time1 < time2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    [self orderUsingComparator:cmptr];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Accessors

- (void)setPagination:(WeAppPaginationItem *)pagination{
    if (pagination != _pagination) {
        _pagination = pagination;
    }
}

-(LongTimeType)timestampWithObject:(id)object {
    
    if ([object respondsToSelector:@selector(timestamp)]) {
        return [[object valueForKey:@"timestamp"] weappUnsignedLongLongValue];
    }else if ([object respondsToSelector:@selector(time)]) {
        return [[object valueForKey:@"time"] weappUnsignedLongLongValue];
    }
    
    return 0;
}

-(NSString*)idValue:(id)object {
    if ([object respondsToSelector:@selector(id)]) {
//        NSLog(@"-----id:%@",[[object valueForKey:@"id"] stringValue]);
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
        
        if ([obj respondsToSelector:@selector(timestamp)]) {
            return [[obj valueForKey:@"timestamp"] weappUnsignedLongLongValue];
        }
        
        if ([obj respondsToSelector:@selector(time)]) {
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
        
        if ([obj respondsToSelector:@selector(id)]) {
            return [[obj valueForKey:@"id"] weappUnsignedLongLongValue];
        }
    }
    return 0ull;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSPageListProtocol method

//是否需要底层解析pageList数据，默认返回YES，由底层统一解析，否则由TBSNSPagedList子类解析
-(BOOL)shouldPageListParse{
    return YES;
}

//开始解析前调用
-(void)willParsedPageListWithJsonValue:(NSDictionary*)jsonValue{
    
}

//解析调用
-(void)parsePageListWithJsonValue:(NSDictionary*)jsonValue{

}

//解析完后调用
-(void)didFinishedParsedPageListWithJsonValue:(NSDictionary*)jsonValue{

}

@end
