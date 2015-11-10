//
//  KSHomeURLResolver.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSTabbarURLResolver.h"
#import "EHTabBarViewController.h"

@implementation KSTabbarURLResolver

- (BOOL)handleURLAction:(TBURLAction*)urlAction{
    [self preprocessURLAction:urlAction];
    UIViewController* viewController = [self viewControllerWithAction:urlAction];
    if (viewController == nil) {
        return NO;
    }
    urlAction.targetController = viewController;
    return YES;
}

-(void)preprocessURLAction:(TBURLAction*)urlAction{
    if (urlAction.urlPath == nil) {
        return;
    }
    [super preprocessURLAction:urlAction];
    TBNavigationType type = TBNavigationTypeNone;
    
    NSURL* url = [NSURL URLWithString:urlAction.urlPath];
    
    if ([[url host] isEqualToString:kInternalTabbarURLHost]){
        type = TBNavigationTypeTabbarSelect;
    } else if ([[url path] isEqualToString:loginPath]) {
        type = TBNavigationTypePresent;
    } else {
        type = TBNavigationTypePush;
    }
    
    if (urlAction.navigationParams == nil) {
        urlAction.navigationParams = [[TBNavigationParams alloc] init];
    }
    urlAction.navigationParams.navigationType = type;
}

-(UIViewController *)viewControllerWithAction:(TBURLAction *)action {
    NSString* viewClassNamePath = [action isActionURLLegal] ? [action getURLPathWithoutSlash] : action.urlPath;
    UIViewController* viewController = [self viewControllerWithAction:action forPath:viewClassNamePath];
    if (viewController == nil) {
        return [super viewControllerWithAction:action];
    }
    return viewController;
}

-(UIViewController*)viewControllerWithAction:(TBURLAction*)action forPath:(NSString*)path{
    RDVTabBarController* tabVC = action.sourceController.rdv_tabBarController;
    UIViewController* controller = nil;
    if (tabVC && [tabVC isKindOfClass:[EHTabBarViewController class]]) {
        controller = [((EHTabBarViewController*)tabVC) getViewControllerWithURL:path];
    }
    if ([controller respondsToSelector:@selector(setupNavigatorURL:query:nativeParams:)]) {
        [controller setupNavigatorURL:action.URL query:action.extraInfo nativeParams:action.nativeParams];
    }
    return controller;
}

@end
