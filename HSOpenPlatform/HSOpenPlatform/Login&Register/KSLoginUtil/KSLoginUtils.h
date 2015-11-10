//
//  EHUtils.h
//  eHome
//
//  Created by louzhenhua on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSLoginUtils : NSObject

+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isEmptyString:(NSString*)string;
+ (BOOL)isNotEmptyString:(NSString*)str;

+ (void)showSecondTimeout:(NSUInteger)time timerOutHandler:(void(^)(BOOL end, NSUInteger remaintime))timerOutHandler;


+ (BOOL)isAuthority:(NSString*)authority;
+ (BOOL)isBoy:(NSNumber*)sex;
+ (BOOL)isGirl:(NSNumber*)sex;

+ (NSDate*)convertDateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

+ (BOOL)isValidString:(NSString*)name;

+ (BOOL)isValidAuthCode:(NSString*)authCode;

+ (BOOL)isValidMobile:(NSString *)mobile;
+ (BOOL)isValidPassword:(NSString *)password;

@end
