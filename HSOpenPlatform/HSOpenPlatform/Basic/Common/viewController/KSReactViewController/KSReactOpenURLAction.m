//
//  KSReactOpenURLAction.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_ReactNative

#import "KSReactOpenURLAction.h"

@implementation KSReactOpenURLAction

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(openURL:(NSString *)urlPath query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams)
{
    if ([NSThread isMainThread]) {
        TBOpenURLFromTargetWithNativeParams(urlPath, [[UIApplication sharedApplication] keyWindow].rootViewController, query, nativeParams);
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            TBOpenURLFromTargetWithNativeParams(urlPath, [[UIApplication sharedApplication] keyWindow].rootViewController, query, nativeParams);
        });
    }
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end

#endif
