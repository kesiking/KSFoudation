//
//  TBSNSJsonUtil.h
//  Taobao2013
//
//  Created by 神逸 on 13-1-28.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppUtils.h"

@interface WeAppJsonUtil : NSObject

+(id)parseJson:(NSObject *)dataJosnValue toObject:(NSObject *)object withObjectClass:(Class)objectClass  withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass params:(NSDictionary*)params;

// dataJosnValue为要解析的json数据
// object：该属性目前仅用于分页数据，因为之前的数据不能丢弃，要将新数据添加到老数据的后面
// objectClass: 用于描述分页数据的类名，动态生成pageList的子类
// dataType：最终返回的数据类型，详见TBSNSDataType
// itemClass：如果dataType为TBSNSDataTypeItem，则itemClass为返回数据的类型；如果dataType为TBSNSDataTypeArray或TBSNSDataTypePagedList，则itemClass为数组中元素的类型
+(id)parseJson:(NSObject *)dataJosnValue toObject:(NSObject *)object withObjectClass:(Class)objectClass  withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass;
// dataJosnValue为要解析的json数据
// object：该属性目前仅用于分页数据，因为之前的数据不能丢弃，要将新数据添加到老数据的后面
// dataType：最终返回的数据类型，详见TBSNSDataType
// itemClass：如果dataType为TBSNSDataTypeItem，则itemClass为返回数据的类型；如果dataType为TBSNSDataTypeArray或TBSNSDataTypePagedList，则itemClass为数组中元素的类型
+(id) parseJson:(NSObject*)dataJosnValue toObject:(NSObject*)object withDataType:(WeAppDataType)dataType itemClass:(Class)itemClass;

+(NSString*)object2JsonString:(NSObject*)object;

@end
