//
//  KSReactShareInsance.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/24.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#ifdef USE_ReactNative

#import "KSReactShareInsance.h"

@implementation KSReactShareInsance

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getUserPhone:(RCTResponseSenderBlock)callback)
{
    callback(@[[KSAuthenticationCenter userPhone]?:[NSNull null]]);
}

RCT_EXPORT_METHOD(getUserId:(RCTResponseSenderBlock)callback)
{
    callback(@[[KSAuthenticationCenter userId]?:[NSNull null]]);
}

RCT_EXPORT_METHOD(isLogin:(RCTResponseSenderBlock)callback)
{
    callback(@[@([KSAuthenticationCenter isLogin])?:[NSNull null]]);
}

RCT_EXPORT_METHOD(getAppName:(RCTResponseSenderBlock)callback)
{
    callback(@[[HSDeviceDataCenter appName]?:[NSNull null]]);
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end

#endif