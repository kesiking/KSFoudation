//
//  EHUtils.m
//  eHome
//
//  Created by louzhenhua on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSLoginUtils.h"

@implementation KSLoginUtils

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

@end
