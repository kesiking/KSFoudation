//
//  KSDebugResponseEvents.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/22.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugResponseEvents : NSObject

+ (instancetype)sharedEvents;

+(void)beginLoading:(NSString *)eventId;
+(void)beginLoading:(NSString *)eventId atViewController:(NSString *)viewControllerName;

+(void)didFinishLoading:(NSString *)eventId content:(BOOL)isEmpty;
+(void)didFinishLoading:(NSString *)eventId content:(BOOL)isEmpty atViewController:(NSString *)viewControllerName;

+(void)beginRenderingPageView:(NSString *)viewControllerName;
+(void)didFinishRenderingPageView:(NSString *)viewControllerName;

+(void)didFailLoading:(NSString *)eventId withError:(NSError *)error;
+(void)didFailLoading:(NSString *)eventId atViewController:(NSString *)viewControllerName withError:(NSError *)error;


@end
