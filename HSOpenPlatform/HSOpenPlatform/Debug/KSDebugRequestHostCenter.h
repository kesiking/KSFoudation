//
//  KSDebugRequestHostCenter.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/17.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugRequestHostCenter : NSObject

@property (nonatomic, strong)  NSString*   redirectHost;

@property (nonatomic, strong)  NSString*   orignalHost;

@property (nonatomic, strong)  NSString*   redirectPort;

@property (nonatomic, strong)  NSString*   orignalPort;

+ (instancetype)sharedInstance;

+ (BOOL)needRedirectInRequset;

+ (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request;

@end
