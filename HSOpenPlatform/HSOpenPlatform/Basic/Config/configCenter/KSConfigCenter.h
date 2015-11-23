//
//  KSConfigCenter.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSConfigCenter : NSObject

+(void)configMatrix;

+(Class)getUrlResolverClassWithName:(NSString*)name;

+(Class)getWebViewUrlResolverClassWithURL:(NSURL*)url;

+(Class)getReactViewUrlResolverClassWithURL:(NSURL*)url;

+(BOOL)isHttpUrlWithURL:(NSURL*)url;

+(BOOL)isReactUrlWithURL:(NSURL*)url;

+(NSDictionary*)getViewContollerNameToClassDict;

@end
