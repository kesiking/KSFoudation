//
//  KSBasicURLResolver.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSBasicURLResolver.h"

@implementation KSBasicURLResolver

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
    
    if (urlAction.navigationParams == nil) {
        urlAction.navigationParams = [[TBNavigationParams alloc] init];
    }
    urlAction.navigationParams.navigationType = TBNavigationTypePush;
    urlAction.navigationParams.animated = YES;
    if (urlAction.extraInfo == nil) {
        return;
    }
    
    id animated = [urlAction.extraInfo objectForKey:ACTION_ANIMATION_KEY];
    if (animated) {
        urlAction.navigationParams.animated = [animated boolValue];
    }
    
    id needLogin = [urlAction.extraInfo objectForKey:ACTION_NEEDLOGIN_KEY];
    if (needLogin) {
        urlAction.navigationParams.needLogin = [needLogin boolValue];
    }
}

-(UIViewController *)viewControllerWithAction:(TBURLAction *)action {
    NSString* viewClassNamePath = [action isActionURLLegal] ? [action getURLPathWithoutSlash] : action.urlPath;
    UIViewController* viewController = [self viewControllerWithAction:action forPath:viewClassNamePath];
    return viewController;
}

-(UIViewController*)viewControllerWithAction:(TBURLAction*)action forPath:(NSString*)path{
    Class controllerClass = NSClassFromString([[[KSNavigator navigator] registeredPlugin] objectForKey:path]);
    if (controllerClass && [controllerClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController* controller = [[controllerClass alloc] initWithNavigatorURL:action.URL query:action.extraInfo nativeParams:action.nativeParams];
        return controller;
    }else if([[action.URL scheme] isEqualToString:@"http"] || [[action.URL scheme] isEqualToString:@"https"]){
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:action.urlPath];
        return webViewController;
    }else if(controllerClass == nil){
        controllerClass = NSClassFromString(path);
        if (controllerClass && [controllerClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController* controller = [[controllerClass alloc] initWithNavigatorURL:action.URL query:action.extraInfo nativeParams:action.nativeParams];
            return controller;
        }
    }
    return nil;
}

@end
