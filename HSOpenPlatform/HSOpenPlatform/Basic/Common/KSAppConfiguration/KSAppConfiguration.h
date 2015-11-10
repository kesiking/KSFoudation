//
//  KSAppConfiguration.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KSNetworkReachabilityStatus) {
    KSNetworkReachabilityStatusUnknown          = -1,
    KSNetworkReachabilityStatusNotReachable     = 0,
    KSNetworkReachabilityStatusReachableViaWWAN = 1,
    KSNetworkReachabilityStatusReachableViaWiFi = 2,
};

#ifndef _KSAppConfiguration_
    #define _KSAppConfiguration_
#endif

@interface KSAppConfiguration : NSObject

@property (nonatomic, assign) KSNetworkReachabilityStatus networkReachabilityStatus;

+ (instancetype)sharedCenter;

@end
