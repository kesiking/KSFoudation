//
//  EHDeviceStatusCenter.h
//  eHome
//
//  Created by 孟希羲 on 15/7/1.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HSDeviceDataCenter : NSObject

@property (nonatomic,strong)  CLLocation              *currentLocation;
@property (nonatomic,assign)  CLLocationCoordinate2D   currentPhoneCoordinate;

+ (instancetype)sharedCenter;

+(NSString*)appName;

+(NSString*)appVersion;

+(NSString*)appIdentifier;

+(NSString*)appShortVersion;

- (BOOL)canGetCurrentPhoneLoaction;

/*!
 *  @brief  needShakeNotice, needVoiceNotice, neednNoticeNotice 返回设置状态
 *
 *  @return 默认为YES
 *
 *  @since 1.0
 */
- (BOOL)needShakeNotice;

- (BOOL)needVoiceNotice;

- (BOOL)neednNoticeNotice;

@end
