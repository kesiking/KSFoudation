//
//  TBCAUtils.h
//  TBWeiTao
//
//  Created by rocky on 14-1-7.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef unsigned long long LongIdType;
typedef unsigned long long LongTimeType;
typedef unsigned long long BigNumberType;

// render type
typedef NS_ENUM(NSInteger, WeAppRenderType) {
    WeAppRenderTypePageName = 1,    // 页面名称渲染
    WeAppRenderTypeComponentType,   // 组建id渲染
    WeAppRenderTypeString,          // json字符串渲染
    WeAppRenderTypeDict,            // json数据字典渲染
};

// 技术数据类型
typedef NS_ENUM(NSInteger, WeAppDataType) {
    WeAppDataTypeItem, // TBItem及其子类
    WeAppDataTypeArray,// NSArray及其子类
    WeAppDataTypePagedList,// 可翻页的list
    WeAppDataTypeNumber,// 数值类型
    WeAppDataTypeObject,// 任意对象类型
    WeAppDataTypeOperation // TBSNSBatOperationResult(操作类型)及其子类
};

// 刷新Model类型
typedef NS_ENUM(NSInteger, WeAppRefreshDataModelType) {
    WeAppRefreshDataModelType_All = 0,                   // default：默认为刷新所有
    WeAppRefreshDataModelType_StyleBindingAndData,       // 仅刷新style与data
    WeAppRefreshDataModelType_ConditionAndData,          // 仅刷新conditon与data
    WeAppRefreshDataModelType_Data,                      // 仅刷新data
    WeAppRefreshDataModelType_DataFrameChange,           // 刷新data与frame
    
//    WeAppRefreshDataModelType_AllFrameNotChange,         // 刷新所有但是frame不变
//    WeAppRefreshDataModelType_ConditionAndDataFrameNotChange, // 刷新conditon与data,但是frame不变
};

#define SAFE_STRING(obj) ([WeAppUtils getSafeString:obj])
#define SAFE_OBJECT(obj) ([WeAppUtils getSafeObject:obj])
#define IS_NULL(obj) ([WeAppUtils isEmpty:obj]) // 是否未空，请参照isEmpty

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_A(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface WeAppUtils : NSObject

void ks_swizzleSelector(Class classType, SEL originalSelector, SEL swizzledSelector);

+ (UIColor *)colorFromString:(NSString *)string;

+ (NSArray *)keyChainsFromParseString:(NSString *)string;
+ (NSString*)getCollectionStringWithKeys:(NSArray*)keys withSeparatedByString:(NSString *)separator;
+ (NSString*)getJSONStringWithDictionary:(NSDictionary*)dict;

+(NSString*)trimWhitespaceAndNewlineCharacterWithString:(NSString*)string;

+ (BOOL)keyNeedParseFromString:(NSString *)string;
+ (BOOL)keyNeedParseFromString:(NSString *)string withCharacter:(unichar)car;
+ (BOOL)keyHasApiListPathFromString:(NSString *)string;
+ (NSString*)getListPathFromApiListPathString:(NSString *)string;

+ (BOOL)string:(NSString*)string withIndex:(NSUInteger)index equalCharacter:(unichar)car;

//将cell模版修改为数据池中可用的数据
+ (NSString*)parseDataBindingWithString:(NSString*)string Index:(NSUInteger)index prefix:(NSString*)prefix;

+(NSMutableDictionary*)parseDataBinding:(NSDictionary*)dataBinding index:(NSUInteger)index prefix:(NSString*)prefix;

+(NSMutableDictionary*)parseDataBinding:(NSDictionary*)dataBinding index:(NSUInteger)index;

+(CGSize)getTextSize:(NSString*)text byFont:(UIFont*)font constrainedToSize:(CGSize)size;

//将dictionary转为可变的dictionary
+(NSMutableDictionary*)parseDictionaryToMutableDictionary:(NSDictionary*)dic;
//将NSArray转为可变的NSArray
+(NSMutableArray*)parseArrayToMutableArray:(NSArray*)array;


// 是否为空，如果是集合，则判断是否集合中有元素，没有则为空。如果是字符串则判断是否为空串，是则为空
+(BOOL)isEmpty:(NSObject*)obj;
+(BOOL)isNotEmpty:(NSObject*)obj;
+(NSString*)intToString:(NSInteger)intValue;
+(NSString*)longToString:(long)longValue;
+(NSString*)unsignedLongLongToString:(unsigned long long)numberValue;
// number缩写
+(NSString*)longAbbreviation:(long)longValue;
// number缩写
+(NSString*)intAbbreviation:(int)intValue;

// 数字超过999显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue;
// 数字超过num位数，如num为3，则显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue number:(NSUInteger)num;

+(NSString*)getSafeString:(NSObject*)obj;
+(NSObject*)getSafeObject:(NSObject*)obj;

+(BOOL)isStringUrlNative:(NSString*)url;
+(NSString*)stringUrltoImage:(NSString*)url;

// ios在中文状态时候输入拼音后不选择中文字符输入，输入英文字母这个时候输出的字符会带一个小的utf8空格 \xe2\x80\x86 (SIX-PER-EM SPACE ) 这个空格需要干掉它
+(NSString*)stringRemoveUtf8Space:(NSString*)str;

@end
