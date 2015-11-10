//
//  KSAdapterCacheService.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/3.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterCacheService.h"
#import "LKDBHelper.h"
#import "KSAuthenticationCenter.h"

@implementation KSAdapterCacheService

-(instancetype)init{
    self = [super init];
    if (self) {
        self.cacheStrategy = [KSCacheStrategy new];
        self.fetchConditionDict = [NSMutableDictionary dictionary];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- write cache value with single item

// write cache value with single item
-(void)writeCacheWithApiName:(NSString *)apiName withParam:(NSDictionary *)param componentItem:(WeAppComponentBaseItem *)componentItem writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItem == nil) {
        return;
    }
    if (self.cacheStrategy.strategyType == KSCacheStrategyTypeRemoteData) {
        [self clearCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemClass:[componentItem class]];
        [self insertCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItem:componentItem writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeInsert){
        [self insertCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItem:componentItem writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeUpdate){
        [self updateCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItem:componentItem writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeDelete){
        [self deleteCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItem:componentItem writeSuccess:writeSuccessBlock];
    }
}

-(void)insertCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
                componentItem:(WeAppComponentBaseItem*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] insertToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)updateCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
                componentItem:(WeAppComponentBaseItem*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItem == nil) {
        return;
    }
    NSString* where = [fetchCondition objectForKey:@"where"];
    componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] updateToDB:componentItem where:where];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

-(void)deleteCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
                componentItem:(WeAppComponentBaseItem*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItem == nil) {
        return;
    }
    componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
    BOOL inseted = [[LKDBHelper getUsingLKDBHelper] deleteToDB:componentItem];
    if (writeSuccessBlock) {
        writeSuccessBlock(inseted);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- write cache value with item array
// write cache value with item array
-(void)writeCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
          componentItemArray:(NSArray*)componentItemArray
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItemArray == nil || [componentItemArray count] <= 0) {
        return;
    }
    
    if (self.cacheStrategy.strategyType == KSCacheStrategyTypeRemoteData) {
        [self clearCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemClass:[[componentItemArray lastObject] class]];
        [self insertCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemArray:componentItemArray writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeInsert){
        [self insertCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemArray:componentItemArray writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeUpdate){
        [self updateCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemArray:componentItemArray writeSuccess:writeSuccessBlock];
    }else if (self.cacheStrategy.strategyType == KSCacheStrategyTypeDelete){
        [self deleteCacheWithApiName:apiName withParam:param withFetchCondition:[self.fetchConditionDict objectForKey:apiName] componentItemArray:componentItemArray writeSuccess:writeSuccessBlock];
    }
}

-(void)insertCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
           componentItemArray:(NSArray*)componentItemArray
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItemArray == nil || [componentItemArray count] <= 0) {
        return;
    }
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        
        BOOL isSuccess = YES;
        for (int i = 0; i < componentItemArray.count; i++)
        {
            WeAppComponentBaseItem* componentItem = [componentItemArray objectAtIndex:i];
            componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
            BOOL inseted = [helper insertToDB:componentItem];
            isSuccess = isSuccess && inseted;
        }
        if (writeSuccessBlock) {
            writeSuccessBlock(isSuccess);
        }
        return (isSuccess == YES);
    }];
}

-(void)updateCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
           componentItemArray:(NSArray*)componentItemArray
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItemArray == nil || [componentItemArray count] <= 0) {
        return;
    }
    NSString* where = [fetchCondition objectForKey:@"where"];
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        
        BOOL isSuccess = YES;
        for (int i = 0; i < componentItemArray.count; i++)
        {
            WeAppComponentBaseItem* componentItem = [componentItemArray objectAtIndex:i];
            componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
            BOOL inseted = [helper updateToDB:componentItem where:where];
            isSuccess = isSuccess && inseted;
        }
        if (writeSuccessBlock) {
            writeSuccessBlock(isSuccess);
        }
        return (isSuccess == YES);
    }];
}

-(void)deleteCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
           componentItemArray:(NSArray*)componentItemArray
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    if (apiName == nil) {
        return;
    }
    if (componentItemArray == nil || [componentItemArray count] <= 0) {
        return;
    }
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        
        BOOL isSuccess = YES;
        for (int i = 0; i < componentItemArray.count; i++)
        {
            WeAppComponentBaseItem* componentItem = [componentItemArray objectAtIndex:i];
            componentItem.db_tableName = [self getTableNameFromApiName:apiName withParam:param];
            BOOL inseted = [helper deleteToDB:componentItem];
            isSuccess = isSuccess && inseted;
        }
        if (writeSuccessBlock) {
            writeSuccessBlock(isSuccess);
        }
        return (isSuccess == YES);
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- read cache value

-(NSInteger)rowCountWithApiName:(NSString *)apiName
                      withParam:(NSDictionary *)param
                  componentItemClass:(Class)componentItemClass
             withFetchCondition:(NSDictionary*)fetchCondition{
    if (apiName == nil) {
        return -1;
    }
    NSString* where = [fetchCondition objectForKey:@"where"];
    NSString* db_tableName = [self getTableNameFromApiName:apiName withParam:param];
    NSInteger count = [[LKDBHelper getUsingLKDBHelper] rowCountWithTableName:db_tableName where:where];
    
    return count;
}

-(void)readCacheWithApiName:(NSString *)apiName
                  withParam:(NSDictionary *)param
         withFetchCondition:(NSDictionary*)fetchCondition
         componentItemClass:(Class)componentItemClass
                readSuccess:(ReadSuccessCacheBlock)readSuccessBlock{
    NSString* where = [fetchCondition objectForKey:@"where"];
    NSString* orderBy = [fetchCondition objectForKey:@"orderBy"];
    NSInteger offset = [[fetchCondition objectForKey:@"offset"] integerValue];
    NSInteger count = [[fetchCondition objectForKey:@"count"] integerValue];
    
    LKDBQueryParams *params = [[LKDBQueryParams alloc]init];
    params.toClass = componentItemClass;
    params.tableName = [self getTableNameFromApiName:apiName withParam:param];
    
    params.where = where;
    params.orderBy = orderBy;
    params.offset = offset;
    params.count = count;
    
    NSMutableArray* componentItems = [[LKDBHelper getUsingLKDBHelper] searchWithParams:params];
    
    readSuccessBlock(componentItems);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- clear cache value

-(void)clearCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
          withFetchCondition:(NSDictionary*)fetchCondition
          componentItemClass:(Class)componentItemClass{
    
    NSString* where = [fetchCondition objectForKey:@"where"];
    
    [[LKDBHelper getUsingLKDBHelper] deleteWithTableName:[self getTableNameFromApiName:apiName withParam:param] where:where];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark- common method

-(NSString*)getTableNameFromApiName:(NSString*)apiName withParam:(NSDictionary *)param{
    NSString* tableName = [apiName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    if ([KSAuthenticationCenter isLogin] && [KSAuthenticationCenter userPhone] && [KSAuthenticationCenter userPhone].length > 0) {
        tableName = [tableName stringByAppendingFormat:@"_%@",[KSAuthenticationCenter userPhone]];
    }
    return tableName;
}

@end
