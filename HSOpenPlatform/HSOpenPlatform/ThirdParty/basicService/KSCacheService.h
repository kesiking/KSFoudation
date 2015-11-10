//
//  KSCacheService.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/3.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCacheStrategy.h"

typedef void(^WriteSuccessCacheBlock)(BOOL success);
typedef void(^ReadSuccessCacheBlock)(NSMutableArray* componentItems);

/*
 * cache 存储的是对象数据，因此需要传入需要转换的compItemClass类型
 */

@interface KSCacheService : NSObject

/*
 * fetchConditionDict apiName作为Key，获取相应的fetchCondition (apiName:fetchCondition)
 * fetchCondition 的结构为 (where  :@"id = 1 and name = @"king" ")
 *                        (orderBy:@"xxx")
 *                        (offset :@1)
 *                        (count  :@1)
 */

@property (nonatomic, strong) NSMutableDictionary  * fetchConditionDict;

@property (nonatomic, strong) KSCacheStrategy      * cacheStrategy;

-(void)writeCacheWithApiName:(NSString*)apiName
     withParam:(NSDictionary*)param
 componentItem:(WeAppComponentBaseItem*)componentItem
     writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock;

-(void)writeCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
          componentItemArray:(NSArray*)componentItemArray
                writeSuccess:(WriteSuccessCacheBlock)writeSuccessBlock;

-(NSInteger)rowCountWithApiName:(NSString *)apiName
                      withParam:(NSDictionary *)param
             componentItemClass:(Class)componentItemClass
             withFetchCondition:(NSDictionary*)fetchCondition;

-(void)readCacheWithApiName:(NSString*)apiName
                   withParam:(NSDictionary*)param
         withFetchCondition:(NSDictionary*)fetchCondition
          componentItemClass:(Class)componentItemClass
                readSuccess:(ReadSuccessCacheBlock)readSuccessBlock;

-(void)clearCacheWithApiName:(NSString*)apiName
                  withParam:(NSDictionary*)param
         withFetchCondition:(NSDictionary*)fetchCondition
          componentItemClass:(Class)componentItemClass;

@end
