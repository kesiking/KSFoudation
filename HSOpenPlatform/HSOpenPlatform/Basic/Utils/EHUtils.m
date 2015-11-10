//
//  EHUtils.m
//  eHome
//
//  Created by louzhenhua on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUtils.h"
#import "NSString+TrimmingAdditions.h"
#import "AFNetworkReachabilityManager.h"

@implementation EHUtils

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isEmptyString:(NSString*)string
{
    if (string == nil || [string length] == 0) {
        return YES;
    }
    return NO;
}
+ (BOOL)isNotEmptyString:(NSString*)str
{
    return ![self isEmptyString:str];
}

+ (void)showSecondTimeout:(NSUInteger)time timerOutHandler:(void(^)(BOOL end, NSUInteger remaintime))timerOutHandler
{
    __block NSUInteger timeout= time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                timerOutHandler(YES, 0);
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                timerOutHandler(NO, timeout);
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

+ (BOOL)isAuthority:(NSString*)authority
{

    if ([authority isEqualToString:@"1"])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isBoy:(NSNumber*)sex
{
    if ([sex integerValue] == 1) {
        return YES;
    }
    return NO;
}

+ (BOOL)isGirl:(NSNumber*)sex
{
    if ([sex integerValue] == 2) {
        return YES;
    }
    return NO;
}

+ (NSDate*)convertDateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if ([self isEmptyString:dateFormat]) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:dateFormat];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *destDateString = [dateFormatter stringFromDate:date];

    
    return destDateString;
    
}
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat
{
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if ([self isEmptyString:dateFormat]) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *destDateString = [formatter stringFromDate:date];
    return destDateString;
}

+ (BOOL)isValidString:(NSString*)name
{
    NSString *regex = @"^[\\dA-Za-z _\\u4e00-\\u9fa5]{1,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:name];
    
}

+ (BOOL)isValidAuthCode:(NSString*)authCode
{
    NSString *regex = @"^\\d{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:authCode];
}

+ (NSString*)trimmingHeadAndTailSpaceInstring:(NSString*)str
{
    NSString*strWithoutSpace = [str stringByTrimmingLeftCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strWithoutSpace = [strWithoutSpace stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return strWithoutSpace;
}


//现有手机号段:
//移动：139   138   137   136   135   134   147   150   151   152   157   158    159   178  182   183   184   187   188
//联通： 130   131   132   155   156   185   186   145   176
//电信： 133   153   177   180   181   189
+ (BOOL)isValidMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])| (17[678])|(14[57]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidPassword:(NSString *)password
{
    if (password == nil) {
        return NO;
    }
    if (![password isKindOfClass:[NSString class]]) {
        return NO;
    }

    NSString *      regex = @"^[A-Za-z0-9\x21-\x7e]{6,20}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];  ;
}

//根据2进制数据获取一星期中被选择了哪些天。e.g. - weekBinaryStr:@"1111111" return:"周日至周周六"。注意：这里是从周日开始为第一天。
+ (NSString *)getWeekSelectedDaysStr:(NSString *)weekBinaryStr {
    
    NSMutableString *resultStr = [[NSMutableString alloc]init];
    NSArray *weekStrArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSInteger num = weekStrArr.count;
    
    if (weekBinaryStr.length != num) {
        NSLog(@"timeStr length error!");
        return weekBinaryStr;
    }
    //这里先将第一天的周日移到最后方便处理
    NSString *weekStr = [NSString stringWithFormat:@"%@%@",[weekBinaryStr substringFromIndex:1],[weekBinaryStr substringToIndex:1]];
    
    for (NSInteger i = 0; i < num; i++) {
        
        NSRange iRange = NSMakeRange(i, 1);
        NSString *iStr = [weekStr substringWithRange:iRange];

        //如果当天被选择，则加入当天，并往后遍历检测连续重复的个数再做处理
        if ([iStr isEqualToString:@"1"]) {
            
            [resultStr appendString:[resultStr isEqualToString:@""]?@"":@" "];
            [resultStr appendString:weekStrArr[i]];
            
            for (NSInteger j = (i + 1); j < num; j++) {
                NSRange jRange = NSMakeRange(j, 1);
                NSString *jStr = [weekStr substringWithRange:jRange];
                
                //工作日判断
                if ((i == 0) && (j == (num - 2))) {
                    resultStr = [NSMutableString stringWithString:@"工作日"];
                    i = j-1;
                    break;
                }
                
                //直到遇到一个不为1的位置
                if (![jStr isEqualToString:@"1"]) {
                    //若只有连续2个为1，则往后加
                    if ((j - i) == 2) {
                        [resultStr appendString:@"  "];
                        [resultStr appendString:weekStrArr[j-1]];
                    }
                    //若3个或3个以上为1，则进行缩略
                    if ((j - i) > 2) {
                        [resultStr appendString:@"至"];
                        [resultStr appendString:weekStrArr[j-1]];
                    }
                    i = j;
                    break;
                }
                //或者是最后一个位置为1
                else if (j == (num - 1)) {
                    //若只有连续2个为1，则往后加
                    if ((j- i) == 1) {
                        [resultStr appendString:@"  "];
                        [resultStr appendString:weekStrArr[j]];
                    }
                    //若3个或3个以上为1，则进行缩略
                    if ((j - i) > 1) {
                        [resultStr appendString:@"-"];
                        [resultStr appendString:weekStrArr[j]];
                    }
                    i = j;
                    break;
                }
            }

        }
    }
    return (NSString *)resultStr;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
            
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

+ (BOOL)networkReachable
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
