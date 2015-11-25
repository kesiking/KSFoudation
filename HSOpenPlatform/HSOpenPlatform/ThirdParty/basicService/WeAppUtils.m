//
//  TBCAUtils.m
//  TBWeiTao
//
//  Created by rocky on 14-1-7.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "WeAppUtils.h"
#import "WeAppComponentBaseItem.h"
#import "WeAppConstant.h"

typedef struct
{
	BOOL stringUsable;
}TBCADataStringResult;

@implementation WeAppUtils

void ks_swizzleSelector(Class classType, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(classType, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(classType, swizzledSelector);
    if (class_addMethod(classType, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(classType, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (UIColor *)colorFromString:(NSString *)string{
    if (string == nil
        || ![string isKindOfClass:[NSString class]]
        || ![string hasPrefix:@"#"]) {
        return nil;
    }
    if (string && string.length == 7) {
        // 不带透明色 #RRGGBB
        NSString * strR = [string substringWithRange:NSMakeRange(1, 2)];
        NSString * strG = [string substringWithRange:NSMakeRange(3, 2)];
        NSString * strB = [string substringWithRange:NSMakeRange(5, 2)];
        
        unsigned long r = strtoul([strR UTF8String],0,16);
        unsigned long g = strtoul([strG UTF8String],0,16);
        unsigned long b = strtoul([strB UTF8String],0,16);
        
        return RGB(r, g ,b);
    } else if(string && string.length > 8) {
        // 带透明色 #AARRGGBB
        NSString * strA = [string substringWithRange:NSMakeRange(1, 2)];
        NSString * strR = [string substringWithRange:NSMakeRange(3, 2)];
        NSString * strG = [string substringWithRange:NSMakeRange(5, 2)];
        NSString * strB = [string substringWithRange:NSMakeRange(7, 2)];

        unsigned long a = strtoul([strA UTF8String],0,16);
        unsigned long r = strtoul([strR UTF8String],0,16);
        unsigned long g = strtoul([strG UTF8String],0,16);
        unsigned long b = strtoul([strB UTF8String],0,16);
        return RGB_A(r, g, b, (float)a/255);
    } else {
        return nil;
    }
}

+(BOOL)keyHasApiListPathFromString:(NSString *)string{
    if (string == nil || string.length <= 0) {
        return NO;
    }
    if ([string hasPrefix:@"${"]) {
        return YES;
    }
    return NO;
}

+(NSString*)getListPathFromApiListPathString:(NSString *)string{
    if (![self keyHasApiListPathFromString:string]) {
        return nil;
    }
    NSRange strStart = [string rangeOfString:@"}."];
    if (strStart.location != NSNotFound) {
        return [string substringFromIndex:(strStart.location + strStart.length)];
    }else{
        return nil;
    }
    return nil;
}

+ (BOOL )keyNeedParseFromString:(NSString *)string{
    if (string == nil) {
        return NO;
    }
    
    NSUInteger count = string.length;
    
    if (count == 0) {
        return NO;
    }
    
    if (count > 1 && [self string:string withIndex:0 equalCharacter:'$']){
        return YES;
    }
    return NO;
}

+ (BOOL )keyNeedParseFromString:(NSString *)string withCharacter:(unichar)car{
    if (string == nil || ![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSUInteger count = string.length;
    
    if (count == 0) {
        return NO;
    }
    
    if (count > 1 && [self string:string withIndex:0 equalCharacter:car]){
        return YES;
    }
    return NO;
}

+ (NSArray *)keyChainsFromParseString:(NSString *)string{
    if (string == nil) {
        return nil;
    }
    NSUInteger count = string.length;
    if (count == 0) {
        return nil;
    }
    if (count > 1 && [self string:string withIndex:0 equalCharacter:'$']) {
        //如果以$符号开头则表示需要从data池中取数据
        TBCADataStringResult *result = (TBCADataStringResult*)malloc(sizeof(TBCADataStringResult));
        
        NSString *keyWord = [self string:string trimmingCharacters:&result];

        if (keyWord == nil || keyWord.length <= 0 || !(*result).stringUsable) {
            return nil;
        }
        
        
        NSArray *keyChains = [keyWord componentsSeparatedByString:@"@"];
        
        if (result != nil) {
            free(result);
        }
        
        return keyChains;
    }else{
        //否则不需要解析keyChains
        return nil;
    }
    return nil;
}

+(BOOL)string:(NSString*)string withIndex:(NSUInteger)index equalCharacter:(unichar)car{
    if (string == nil || string.length <= index) {
        return NO;
    }
    if ([string characterAtIndex:index] == car) {
        return YES;
    }
    return NO;
}

+(NSString*)string:(NSString*)string trimmingCharacters:(TBCADataStringResult **)result{
    
    if (string == nil || string.length <= 0) {
        if (result != nil) {
            (**result).stringUsable = NO;
        }
        
        return nil;
    }
    
    NSInteger  bracketCount     = 0;
    NSUInteger strIndex         = 0;
    BOOL       needChangeChar   = YES;
    unichar   *newStrChar       = malloc(sizeof(unichar)*[string length] + 1);
    
    for (NSUInteger index = 0; index < [string length]; index++) {
        unichar strChar = [string characterAtIndex:index];
        switch (strChar) {
            case '{':{
                bracketCount++;
                needChangeChar = NO;
            }
                break;
            case '}':{
                bracketCount--;
                
                if (bracketCount == 0) {
                    needChangeChar = YES;
                }
            }
            case '$':
                break;
            case '.':{
                if (needChangeChar) {
                    newStrChar[strIndex++] = '@';
                }else{
                    newStrChar[strIndex++] = '.';
                }
            }
                break;
            default:
            {
                newStrChar[strIndex++] = strChar;
            }
                break;
        }
    }
    newStrChar[strIndex] = '\0';
    
    __autoreleasing NSString *newString = [NSString stringWithCharacters:newStrChar length:strIndex];
    
    if (bracketCount == 0) {
        if (result != nil) {
            (**result).stringUsable = YES;
        }
    }
    
    if (newStrChar != nil) {
        free(newStrChar);
    }
    
    return newString;
}

+ (NSString*)getCollectionStringWithKeys:(NSArray*)keys withSeparatedByString:(NSString *)separator{
    if ([self isEmpty:keys] || [self isEmpty:separator]) {
        return nil;
    }
    NSMutableString* keyStr = [NSMutableString string];
    NSUInteger count = [keys count];
    for (NSString* key in keys) {
        if (key == nil || ![key isKindOfClass:[NSString class]]) {
            continue;
        }
        [keyStr appendString:key];
        NSUInteger index = [keys indexOfObject:key];
        if (index < count - 1) {
            [keyStr appendString:separator];
        }
    }
    return keyStr;
}

+ (NSString*)getJSONStringWithDictionary:(NSDictionary*)dict{
    if ([self isEmpty:dict]) {
        return nil;
    }
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString*)dict;
    }
    NSError* jsonError = nil;
    
    NSData*  jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if ([jsonData length] > 0 && jsonError == nil){
        id paramObj = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return paramObj;
    }
    
    return nil;
}

//将cell模版修改为数据池中可用的数据
+ (NSString*)parseDataBindingWithString:(NSString*)string Index:(NSUInteger)index prefix:(NSString*)prefix{
    if (string == nil) {
        return nil;
    }
    NSMutableString *newStr = [[NSMutableString alloc] init];
    if (prefix != nil) {
        if ([self keyNeedParseFromString:string]) {
            //如果是$开头的则加在$后面，如prefix为123 string 为$abc,则$123.abc
            [newStr appendString:@"$"];
            [newStr appendString:prefix];
            [newStr appendFormat:@".[%lu]",(unsigned long)index];
            [newStr appendString:[string substringFromIndex:1]];
        }else{
            //如果不是$开头直接加在prefix后面，如prefix为123 string 为abc,则123.abc
//            [newStr appendString:prefix];
//            [newStr appendString:@"."];
//            [newStr appendString:string];
            return string;
        }
    }else{
        if ([self keyNeedParseFromString:string]) {
            //如果是$开头的则做操作，如string为$abc.[?].123,则$123.[index].abc
            NSRange strStart = [string rangeOfString:@"[?]"];
            if (strStart.location != NSNotFound) {
                NSString *strTmp = [string stringByReplacingCharactersInRange:strStart withString:[NSString stringWithFormat:@"[%lu]",(unsigned long)index]];
                [newStr appendString:strTmp];
            }else{
                //如果没有需要操作的直接返回string
                return string;
            }
        }else{
            //如果不是$开头直接返回string
            return string;
        }
    }
    return newStr;
}

+(NSMutableDictionary*)parseDictionaryToMutableDictionary:(NSDictionary*)dic{
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]] || [dic count] <= 0) {
        return nil;
    }
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithCapacity:[dic count]];
    
    NSArray *allkeys = [dic allKeys];
    
    for (NSString* key in allkeys) {
        if (key && [key isKindOfClass:[NSString class]]) {
            id value = [dic objectForKey:key];

            if (value == nil || [value isKindOfClass:[NSNull class]] || [value isEqual:[NSNull null]]) {
                continue;
            }

            if([value isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary* newParam = [self parseDictionaryToMutableDictionary:(NSDictionary*)value];
                if (newParam && [newParam count] > 0) {
                    [newDic setObject:newParam forKey:key];
                }
            }else if([value isKindOfClass:[NSArray class]]){
                NSMutableArray* newArray = [self parseArrayToMutableArray:(NSArray*)value];
                if (newArray && [newArray count] > 0) {
                    [newDic setObject:newArray forKey:key];
                }
            }else{
                [newDic setObject:value forKey:key];
            }
        }
    }
    if (newDic) {
        return newDic;
    }
    return nil;
}

+(NSMutableArray*)parseArrayToMutableArray:(NSArray*)array{
    if (array == nil || ![array isKindOfClass:[NSArray class]] || [array count] <= 0) {
        return nil;
    }
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (id value in array) {
        if (value == nil || [value isKindOfClass:[NSNull class]] || [value isEqual:[NSNull null]]) {
            continue;
        }
        
        if([value isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary* newParam = [self parseDictionaryToMutableDictionary:(NSDictionary*)value];
            if (newParam && [newParam count] > 0) {
                [newArray addObject:newParam];
            }
        }else if([value isKindOfClass:[NSArray class]]){
            NSMutableArray* newArray = [self parseArrayToMutableArray:(NSArray*)value];
            if (newArray && [newArray count] > 0) {
                [newArray addObject:newArray];
            }
        }else{
            [newArray addObject:value];
        }
    }
    if (newArray) {
        return newArray;
    }
    return nil;
}

+(NSString*)trimWhitespaceAndNewlineCharacterWithString:(NSString*)string{
    if (string == nil) {
        return nil;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (string.length == 0) {
        return string;
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//模板数据填充
+(NSMutableDictionary*)parseDataBinding:(NSDictionary*)dataBinding index:(NSUInteger)index{
    return [self parseDataBinding:dataBinding index:index prefix:nil];
}

+(NSMutableDictionary*)parseDataBinding:(NSDictionary*)dataBinding index:(NSUInteger)index prefix:(NSString*)prefix{
    if (dataBinding && [dataBinding isKindOfClass:[NSDictionary class]] && [dataBinding count] > 0) {
        NSMutableDictionary *newDataBinding = [[NSMutableDictionary alloc] initWithCapacity:[dataBinding count]];
        NSArray *allkeys = [dataBinding allKeys];
        
        for (NSString* key in allkeys) {
            if (key && [key isKindOfClass:[NSString class]]) {
                id value = [dataBinding objectForKey:key];
                id newKey = [self parseDataBindingWithString:key Index:index prefix:prefix];
                if (value == nil) {
                    continue;
                }
                if (newKey == nil || ![newKey isKindOfClass:[NSString class]]) {
                    newKey = key;
                }
                if ([value isKindOfClass:[NSString class]]) {
                    id newValue = [self parseDataBindingWithString:value Index:index prefix:prefix];
                    if(newValue)
                        [newDataBinding setObject:newValue forKey:newKey];
                }else if([value isKindOfClass:[NSDictionary class]]){
                    NSMutableDictionary* newParam = [self parseDataBinding:(NSDictionary*)value index:index prefix:prefix];
                    if (newParam && [newParam count] > 0) {
                        [newDataBinding setObject:newParam forKey:newKey];
                    }
                }else if([value isKindOfClass:[NSArray class]]){
                    NSMutableArray* newArray = [self parseDataBindingWithArray:(NSArray*)value index:index prefix:prefix];
                    if (newArray && [newArray count] > 0) {
                        [newDataBinding setObject:newArray forKey:newKey];
                    }
                }else{
                    [newDataBinding setObject:value forKey:newKey];
                }
            }
        }
        if (newDataBinding) {
            return newDataBinding;
        }
    }
    return nil;
}

+(NSMutableArray*)parseDataBindingWithArray:(NSArray*)dataBinding index:(NSUInteger)index prefix:(NSString*)prefix{
    if (dataBinding && [dataBinding isKindOfClass:[NSArray class]] && [dataBinding count] > 0) {
        NSMutableArray *newDataBinding = [[NSMutableArray alloc] initWithCapacity:[dataBinding count]];
        
        for (id value in dataBinding) {
            if (value == nil) {
                continue;
            }
            if ([value isKindOfClass:[NSString class]]) {
                id newValue = [self parseDataBindingWithString:value Index:index prefix:prefix];
                if (newValue) {
                    [newDataBinding addObject:newValue];
                }
            }else if([value isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary* newParam = [self parseDataBinding:(NSDictionary*)value index:index prefix:prefix];
                if (newParam && [newParam count] > 0) {
                    [newDataBinding addObject:newParam];
                }
            }else if([value isKindOfClass:[NSArray class]]){
                NSMutableArray* newArray = [self parseDataBindingWithArray:(NSArray*)value index:index prefix:prefix];
                if (newArray && [newArray count] > 0) {
                    [newDataBinding addObject:newArray];
                }
            }else{
                [newDataBinding addObject:value];
            }
        }
        if (newDataBinding) {
            return newDataBinding;
        }
    }
    return nil;
}

+(CGSize)getTextSize:(NSString*)text byFont:(UIFont*)font constrainedToSize:(CGSize)size {
    
    if (IOS_VERSION >= 7.0)
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }
    else
    {
        return [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}

+(BOOL)isEmpty:(NSObject *)obj {
    if (SAFE_OBJECT(obj) == nil) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj performSelector:@selector(length)] <= 0;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return [(NSArray *)obj count] <= 0;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)obj count] <= 0;
    }
    if ([obj isKindOfClass:[WeAppBasicPagedList class]]) {
        return [(WeAppBasicPagedList *)obj count] <= 0;
    }
    if (![obj isKindOfClass:[WeAppComponentBaseItem class]]) {
        return YES;
    }
    
    return NO;
}

+(BOOL)isNotEmpty:(NSObject *)obj {
    return ![self isEmpty:obj];
}

+(NSArray*)collectionClassArray {
    static NSArray *s2cMap = nil;
    if (!s2cMap) {
        s2cMap = [NSArray arrayWithObjects:[NSArray class],[NSDictionary class],[NSMutableArray class],[NSMutableDictionary class], nil];
    }
    return s2cMap;
}

+(NSString *)longToString:(long)longValue {
    return [NSString stringWithFormat:@"%ld",longValue];
}

+(NSString *)intToString:(NSInteger)intValue {
    return [NSString stringWithFormat:@"%ld",intValue];
}

+(NSString *)unsignedLongLongToString:(unsigned long long)numberValue {
    return [NSString stringWithFormat:@"%llu",numberValue];
}

+(NSString *)intAbbreviation:(int)intValue {
    
    NSString *intStr = [self intToString:intValue];
    
    return [self abbreviationWithString:intStr];
}

+(NSString *)longAbbreviation:(long)longValue {
    NSString *longStr = [self longToString:longValue];
    
    return [self abbreviationWithString:longStr];
}

// 数字超过999显示为“999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue {
    NSString * numStr = nil;
    
    if(longValue <= 0) {
        numStr = @"";
    } else if (longValue > 999) {
        numStr = @"999+";
    } else {
        numStr = [NSString stringWithFormat:@"%llu", longValue];
    }
    
    return numStr;
}

// 数字超过num显示为num个9+，如num为5，显示为“99999+”
+(NSString*)longNumberAbbreviation:(LongIdType)longValue number:(NSUInteger)num {
    NSString * numStr = nil;
    
    LongIdType showNumber = 0;
    NSUInteger numCount = num;
    for (; numCount > 0; numCount--) {
        showNumber = showNumber * 10 + 9;
    }
    
    if(longValue <= 0) {
        numStr = @"";
    } else if (longValue > showNumber) {
        numStr = [NSString stringWithFormat:@"%llu+",showNumber];
    } else {
        numStr = [NSString stringWithFormat:@"%llu", longValue];
    }
    
    return numStr;
}

//0~9999：原数字
//10000~9999999：x万/x.x万，小数点后最多一位
//10000000~99999999：x万，无小数点
//100000000及以上：x亿
+(NSString *)abbreviationWithString:(NSString*)str {
    if (str.length <= 4) {
        return str;
    }
    
    NSRange rangeYi = NSMakeRange(0, str.length - 8);
    NSRange rangeWan = NSMakeRange(0, str.length - 4);
    NSRange rangeQian = NSMakeRange(str.length - 4, 1);
    
    if (str.length < 8 && ![[str substringWithRange:rangeQian] isEqualToString:@"0"]) {
        NSLog(@"%@",[str substringWithRange:rangeWan]);
        NSLog(@"%@",[str substringWithRange:rangeQian]);
        
        return [NSString stringWithFormat:@"%@.%@万",[str substringWithRange:rangeWan],[str substringWithRange:rangeQian]];
    }else if(str.length < 9){
        return [NSString stringWithFormat:@"%@万",[str substringWithRange:rangeWan]];
    }
    
    
    return [NSString stringWithFormat:@"%@亿",[str substringWithRange:rangeYi]];
}

+(NSString *)getSafeString:(NSObject *)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return (NSString*)obj;
}

+(NSObject *)getSafeObject:(NSObject *)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return obj;
}

+(BOOL)isStringUrlNative:(NSString*)url{
    return ([url rangeOfString:@"bundle://"].location != NSNotFound);
}

+(NSString*)stringUrltoImage:(NSString*)url{
    NSUInteger location = [url rangeOfString:@"bundle://"].location;
    return [url substringFromIndex: location+9];
}

+(NSString*)stringRemoveUtf8Space:(NSString *)str {
    char* utf8Replace = "\xe2\x80\x86\0";
    NSData* data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];
    NSString* utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString* mutableStr = [NSMutableString stringWithString:str];
    NSString* result =  [mutableStr stringByReplacingOccurrencesOfString:utf8_str_format withString:@""];
    return result;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
 * Deprecated
 */
- (NSDictionary*)tbQueryDictionaryUsingEncoding:(NSStringEncoding)encoding withString:(NSString*)string{
    if (string == nil) {
        return nil;
    }
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        if (!pairString) {
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            continue;
        }
        //        NSArray* kvPair = [pairString componentsSeparatedByString:@"="]; // modify by Tim Cao 2012/08/14, custom separator
        NSMutableArray* kvPair = [NSMutableArray array];
        NSUInteger equalSignPosition = [pairString rangeOfString:@"="].location;
        if (equalSignPosition == NSNotFound) {
            [kvPair addObject:pairString];
            
        } else {
            [kvPair addObject:[pairString substringToIndex:equalSignPosition]];
            if (equalSignPosition != pairString.length-1)
                [kvPair addObject:[pairString substringFromIndex:equalSignPosition+1]];
        }
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            if (key && value) {
                // add by Tim Cao 2012/08/14, avoid nil value(wrong encoding) to be added to dictionary
                [pairs setObject:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


@end
