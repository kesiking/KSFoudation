//
//  ManWuLoginResolver.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-11.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginResolver.h"

@implementation KSLoginResolver

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
    TBNavigationType type = TBNavigationTypeNone;
    
    NSString* path = [urlAction isActionURLLegal] ? [urlAction getURLPathWithoutSlash] : urlAction.urlPath;
    
    if ([path isEqualToString:loginPath]) {
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
    if (viewController) {
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBar.translucent = NO;
        
        // 设置bar颜色
        
        if([navigationController.navigationBar respondsToSelector:@selector(barTintColor)]){
            navigationController.navigationBar.barTintColor = UILOGINNAVIGATIONBAR_COLOR;
        }
        if([navigationController.navigationBar respondsToSelector:@selector(tintColor)]){
            navigationController.navigationBar.tintColor  =   UILOGINNAVIGATIONBAR_TITLE_COLOR;
        }
        
        // 修改navbar title颜色
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   UILOGINNAVIGATIONBAR_TITLE_COLOR, NSForegroundColorAttributeName,
                                                   [UIFont boldSystemFontOfSize:UILOGINNAVIGATIONBAR_TITLE_SIZE], NSFontAttributeName, nil];
        
        [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];

        return navigationController;
    }
    return viewController;
}

-(UIViewController*)viewControllerWithAction:(TBURLAction*)action forPath:(NSString*)path{
    if (![path isEqualToString:loginPath]) {
        return nil;
    }
    Class controllerClass = NSClassFromString([[[KSNavigator navigator] registeredPlugin] objectForKey:path]);
    if (controllerClass == nil || ![controllerClass isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    UIViewController* controller = [[controllerClass alloc] initWithNavigatorURL:action.URL query:action.extraInfo nativeParams:action.nativeParams];
    return controller;
}

@end
