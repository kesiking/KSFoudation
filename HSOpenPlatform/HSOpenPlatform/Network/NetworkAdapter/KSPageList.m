//
//  KSPageList.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/5/23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSPageList.h"

@implementation KSPageList

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addObject:(id)anObject{
    [super addObject:anObject];
    self.insertDataList = @[anObject];
    self.insertListType = KSInsertListTypeAfterPagelist;
}

- (void)addObjectsFromArray:(NSArray *)otherArray{
    [super addObjectsFromArray:otherArray];
    self.insertDataList = otherArray;
    self.insertListType = KSInsertListTypeAfterPagelist;
}

- (void)removeAllObjects{
    [super removeAllObjects];
    self.deleteDataList = [self getItemList];
}

- (void)removeObject:(id)anObject{
    [super removeObject:anObject];
    self.deleteDataList = @[anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [super insertObject:anObject atIndex:index];
    self.insertDataList = @[anObject];
    if (index == 0) {
        self.insertListType = KSInsertListTypeBeforPagelist;
    }else if (index != [self count] - 1){
        self.insertListType = KSInsertListTypeBetweenPagelist;
    }else{
        self.insertListType = KSInsertListTypeAfterPagelist;
    }
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
    [super insertObjects:objects atIndexes:indexes];
    self.insertDataList = objects;
    if (indexes == nil) {
        return;
    }
    if ([indexes firstIndex] == 0) {
        self.insertListType = KSInsertListTypeBeforPagelist;
    }else if ([indexes lastIndex] != [self count] - 1){
        self.insertListType = KSInsertListTypeBetweenPagelist;
    }else{
        self.insertListType = KSInsertListTypeAfterPagelist;
    }
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
    
    if(self.pagination == nil) {
        self.pagination = [[WeAppPaginationItem alloc]init];
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
            NSRange range = NSMakeRange(0, [newDataList count]);
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

@end
