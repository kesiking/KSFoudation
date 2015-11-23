//
//  KSReactOpenURLAction.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSReactOpenURLAction.h"

@implementation KSReactOpenURLAction

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(openURL:(NSString *)urlPath params:(NSDictionary *)params)
{
    if ([NSThread isMainThread]) {
        TBOpenURLFromSourceAndParams(urlPath, [[UIApplication sharedApplication] keyWindow].rootViewController, params);
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            TBOpenURLFromSourceAndParams(urlPath, [[UIApplication sharedApplication] keyWindow].rootViewController, params);
        });
    }
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
