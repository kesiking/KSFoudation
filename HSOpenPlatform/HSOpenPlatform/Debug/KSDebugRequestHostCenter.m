//
//  KSDebugRequestHostCenter.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/17.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestHostCenter.h"

@implementation KSDebugRequestHostCenter : NSObject

static KSDebugRequestHostCenter *sharedInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t KSDebugChangeRequestHostView_OnceToken;
    
    dispatch_once(&KSDebugChangeRequestHostView_OnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

+(BOOL)needRedirectInRequset{
    return [self needRedirectHostInRequset] || [self needRedirectPortInRequset];
}

+(BOOL)needRedirectHostInRequset{
    return ([[self sharedInstance] redirectHost] && [[self sharedInstance] redirectHost].length != 0) && ([[self sharedInstance] orignalHost] && [[self sharedInstance] orignalHost].length != 0) &&  (![[[self sharedInstance] orignalHost] isEqualToString:[[self sharedInstance] redirectHost]]);
}

+(BOOL)needRedirectPortInRequset{
    return ([[self sharedInstance] redirectPort] && [[self sharedInstance] redirectPort].length != 0) && ([[self sharedInstance] orignalPort] && [[self sharedInstance] orignalPort].length != 0) &&  (![[[self sharedInstance] orignalPort] isEqualToString:[[self sharedInstance] redirectPort]]);
}

+(NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *urlString = originUrlString;
    
    if ([self needRedirectHostInRequset]){
        NSString *originHostString = [request.URL host];
        NSRange hostRange = [originUrlString rangeOfString:originHostString];
        if (hostRange.location != NSNotFound && [originHostString isEqualToString:[[self sharedInstance] orignalHost]]) {
            // 定向到redirectHost
            NSString *redirectHost = [[self sharedInstance] redirectHost];
            // 替换域名
            urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:redirectHost];
        }
    }
    
    // 替换端口 redirectPort 如果需要替换的端口及原始端口存在且他们不相同
    if ([self needRedirectPortInRequset]) {
        NSString *originPortString = [[request.URL port] stringValue];
        NSRange portRange = [urlString rangeOfString:[[self sharedInstance] orignalPort]];
        if (portRange.location != NSNotFound && [originPortString isEqualToString:[[self sharedInstance] orignalPort]]) {
            urlString = [urlString stringByReplacingCharactersInRange:portRange withString:[[self sharedInstance] redirectPort]];
        }
    }
    
    // 如果没有发生替换则原样返回
    if ([urlString isEqualToString:originUrlString]) {
        return request;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    
    return request;
}

@end
