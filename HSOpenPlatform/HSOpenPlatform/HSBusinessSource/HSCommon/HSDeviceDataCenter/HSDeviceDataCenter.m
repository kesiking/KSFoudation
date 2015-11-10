//
//  EHDeviceStatusCenter.m
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSDeviceDataCenter.h"
#define kEHShakeNoticeKey @"shakeNoticeKey"     //震动
#define kEHVoiceNoticeKey @"voiceNoticeKey"     //声音
#define kEHNoticeKey @"noticeKey"               //通知提醒

@interface HSDeviceDataCenter()

@end

@implementation HSDeviceDataCenter

static NSDictionary * bundleInfo = nil;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+(void)initialize{
    if (bundleInfo == nil) {
        bundleInfo = [[NSBundle mainBundle] infoDictionary];     //获取info－plist
    }
}

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

+(NSString*)appName{
    return [bundleInfo objectForKey:@"CFBundleDisplayName"];               //获取Bundle name
}

+(NSString*)appIdentifier{
    return [bundleInfo objectForKey:@"CFBundleIdentifier"];                //获取Bundle Identifier
}

+(NSString*)appVersion{
    return [bundleInfo valueForKey:@"CFBundleVersion"];                    //获取Bundle Version
}

+(NSString*)appShortVersion{
    return [bundleInfo valueForKey:@"CFBundleShortVersionString"];          //获取Bundle Short Version
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)config{
    [self initNotification];
}

-(void)initNotification{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timer init method

-(void)initTimer{
    
}

- (void)invalidateTimer{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - queryDeviceData

- (BOOL)canGetCurrentPhoneLoaction{
    return self.currentLocation != nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- needShakeNotice, needVoiceNotice, neednNoticeNotice
/*!
 *  @brief  needShakeNotice, needVoiceNotice, neednNoticeNotice 返回设置状态
 *
 *  @return 默认为YES
 *
 *  @since 1.0
 */
-(BOOL)needShakeNotice{
    NSNumber *shakeNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //震动
    if ([userDefaults objectForKey:kEHShakeNoticeKey]) {
        shakeNumber = [userDefaults objectForKey:kEHShakeNoticeKey];
    }
    return [shakeNumber boolValue];
}

-(BOOL)needVoiceNotice{
    NSNumber *voiceNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //声音
    if ([userDefaults objectForKey:kEHVoiceNoticeKey]) {
        voiceNumber = [userDefaults objectForKey:kEHVoiceNoticeKey];
    }
    return [voiceNumber boolValue];
}

-(BOOL)neednNoticeNotice{
    NSNumber *noticeNumber = @YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //声音
    if ([userDefaults objectForKey:kEHNoticeKey]) {
        noticeNumber = [userDefaults objectForKey:kEHNoticeKey];
    }
    return [noticeNumber boolValue];
}

@end
