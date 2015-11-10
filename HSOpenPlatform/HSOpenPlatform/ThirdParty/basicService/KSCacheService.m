//
//  KSCacheService.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/3.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSCacheService.h"

@implementation KSCacheService

-(void)writeCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
               componentItem:(WeAppComponentBaseItem*)componentItem
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    
}

-(void)writeCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
          componentItemArray:(NSArray*)componentItemArray
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    
}

-(void)updateCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
                componentItem:(WeAppComponentBaseItem*)componentItem
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    
}

-(void)updateCacheWithApiName:(NSString*)apiName
                    withParam:(NSDictionary*)param
           withFetchCondition:(NSDictionary*)fetchCondition
           componentItemArray:(NSArray*)componentItemArray
                 writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock{
    
}

-(NSInteger)rowCountWithApiName:(NSString *)apiName
                      withParam:(NSDictionary *)param
             componentItemClass:(Class)componentItemClass
             withFetchCondition:(NSDictionary*)fetchCondition{
    return 0;
}

-(void)readCacheWithApiName:(NSString*)apiName
                  withParam:(NSDictionary*)param
         withFetchCondition:(NSDictionary*)fetchCondition
         componentItemClass:(Class)componentItemClass
                readSuccess:(ReadSuccessCacheBlock)readSuccessBlock{
    
}

-(void)clearCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
          withFetchCondition:(NSDictionary*)fetchCondition
          componentItemClass:(Class)componentItemClass{
    
}

@end
