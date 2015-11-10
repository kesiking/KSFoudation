//
//  WeAppComponentBaseItem.h
//  TBWeApp
//
//  Created by zhuge.zzy on 6/26/14.
//  Copyright (c) 2014 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBJSONModelKeyMapper.h"

//! TOP 中所有实体对象的基类
@interface WeAppComponentBaseItem :NSObject <NSCoding> {
    BOOL _treatBoolAsStringWhenModelToJSON;
}

@property(nonatomic, strong) NSDictionary* componentDict;

/*!
 创建一个 TBModel 实例
 */
+ (id)model;

/*!
 使用一个 JSON 来创建 TBModel 实例
 @param json 以 NSDictionary 表示的 JSON 对象
 */
+ (id)modelWithJSON:(NSDictionary*)json;

/*!
 使用一个数组类型的 JSON 来创建 TBModel 数组
 @param jsonArray 以 NSArray 表示的 JSON 数组对象
 */
+ (NSArray *)modelArrayWithJSON:(NSArray *)jsonArray;

/*!
 使用 JSON 初始化一个 TBModel 实例
 @param dict 以 NSDictionary 表示的 JSON 对象
 */
- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)parseModule:(NSDictionary*) dict;

//! 初始化设置TBModal
- (void)setup;

/*!
 从一个 JSON Dictionary 设置 TBModel 的属性
 @param dict 以 NSDictionary 表示的 JSON 对象
 */
- (void)setFromDictionary:(NSDictionary*)dict;

/*!
 将 TBModel 转换为一个 NSDictaionry
 */
- (NSDictionary*)toDictionary;

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON;

+ (TBJSONModelKeyMapper *)modelKeyMapper;

@end
