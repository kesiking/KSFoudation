//
//  KSDebugURLProtocol.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/2.
//  Copyright © 2015年 孟希羲. All rights reserved.
//  参考 - NetowrkEye

#import <Foundation/Foundation.h>

@interface KSDebugURLProtocol : NSURLProtocol

+ (void)registerProtocol;

+ (void)unRegisterProtocol;

@end
