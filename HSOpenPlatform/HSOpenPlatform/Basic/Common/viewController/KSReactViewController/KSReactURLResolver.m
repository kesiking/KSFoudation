//
//  KSReactURLResolver.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_ReactNative

#import "KSReactURLResolver.h"
#import "KSReactViewController.h"

#define APP_REACT_NATIVE_SCHEME_URL @"http"// APP_DEFAULT_SCHEME

@implementation KSReactURLResolver

- (BOOL)handleURLAction:(TBURLAction*)urlAction{
    [self preprocessURLAction:urlAction];
    UIViewController* viewController = [self viewControllerWithAction:urlAction];
    if (viewController == nil) {
        return NO;
    }
    urlAction.targetController = viewController;
    return YES;
}

-(UIViewController *)viewControllerWithAction:(TBURLAction *)action {
    NSURL* url = action.URL;
    if (url == nil || ![action isActionURLLegal]) {
        return nil;
    }
    
    UIViewController* viewController = nil;
    if ([[url scheme] isEqualToString:kInternalReactNativeURLScheme]) {
        NSString* newSchemeUrl = [url.absoluteString stringByReplacingOccurrencesOfString:kInternalReactNativeURLScheme withString:APP_REACT_NATIVE_SCHEME_URL];
        viewController = [[KSReactViewController alloc] initWithNavigatorURL:newSchemeUrl?[NSURL URLWithString:newSchemeUrl]:action.URL query:action.extraInfo nativeParams:action.nativeParams];
    }
    if (viewController == nil) {
        return [super viewControllerWithAction:action];
    }
    
    return viewController;
}

@end

#endif
