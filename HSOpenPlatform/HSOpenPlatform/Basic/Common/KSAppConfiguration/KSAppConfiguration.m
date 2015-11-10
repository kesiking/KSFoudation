//
//  KSAppConfiguration.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAppConfiguration.h"

@implementation KSAppConfiguration


+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
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
    
}

- (void)config{
    [self initNetworkMonitoring];
    [self setNetworkReachabilityStatus:KSNetworkReachabilityStatusReachableViaWiFi];
}

-(void)initNetworkMonitoring{
#ifdef _AFNETWORKING_
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self setNetworkReachabilityStatus:(KSNetworkReachabilityStatus)status];
    }];
#endif
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - send network message method

@end
