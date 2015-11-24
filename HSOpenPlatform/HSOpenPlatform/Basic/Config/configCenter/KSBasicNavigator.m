//
//  KSBasicNavigator.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSBasicNavigator.h"
#import "RDVTabBarController.h"
#import "KSConfigCenter.h"

@implementation KSBasicNavigator

+(void)configNavigator{
    // 设置全局跳转引擎
    [KSNavigator setNavigator:[[KSBasicNavigator alloc] init]];
    NSDictionary* nametoClass = [KSConfigCenter getViewContollerNameToClassDict];
    if (nametoClass && [nametoClass isKindOfClass:[NSDictionary class]]) {
        [nametoClass enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (key
                && [key isKindOfClass:[NSString class]]
                && obj) {
                [KSNavigator registerClass:obj withPath:key];
            }
        }];
    }
}

- (BOOL)openURLAction:(TBURLAction*)action {
    Class urlResolverClass = nil;
    if ([KSConfigCenter isHttpUrlWithURL:action.URL]) {
        urlResolverClass = [KSConfigCenter getWebViewUrlResolverClassWithURL:action.URL];
    }else if([KSConfigCenter isReactUrlWithURL:action.URL]){
        urlResolverClass = [KSConfigCenter getReactViewUrlResolverClassWithURL:action.URL];
    }else{
        NSString* classNamePath = [action isActionURLLegal] ? [action getURLPathWithoutSlash] : action.urlPath;
        urlResolverClass = [KSConfigCenter getUrlResolverClassWithName:classNamePath];
    }
    if (urlResolverClass == nil || ![urlResolverClass isSubclassOfClass:[KSBasicURLResolver class]]) {
        return [super openURLAction:action];
    }
    KSBasicURLResolver* urlResolver = [[urlResolverClass alloc] init];
    if(![urlResolver handleURLAction:action])
        return NO;
    UIViewController* continerViewController = [self containerViewControllerForController:action.sourceController navigateType:action.navigationParams.navigationType];
    if (continerViewController == nil) {
        return NO;
    }
    if (!action.targetController) {
        return NO;
    }
#ifdef kAuthenticationCenterMarocExist
    if (action.navigationParams.needLogin && ![KSAuthenticationCenter isLogin]) {
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:^(BOOL loginSuccess) {
            if (loginSuccess){
                TBOpenURLFromTargetWithNativeParams(action.urlPath, action.sourceController, action.extraInfo, action.nativeParams);
            }
        } cancelActionBlock:^{
            
        }];
        return NO;
    }
#endif
    if ([action.targetController isKindOfClass:[UINavigationController class]] && [((UINavigationController*)action.targetController).viewControllers count] > 0) {
        [[((UINavigationController*)action.targetController) topViewController] setOpenNavigateType:action.navigationParams.navigationType];
    }else{
        [action.targetController setOpenNavigateType:action.navigationParams.navigationType];
    }
    if (!action.targetController.rdv_tabBarController) {
        [action.targetController rdv_setTabBarController:action.sourceController.rdv_tabBarController];
    }
    [continerViewController addSubcontroller:action.targetController navigateType:action.navigationParams.navigationType animated:action.navigationParams.animated];
    return YES;
}

- (BOOL)backURLAction:(TBURLAction*)action {
    UIViewController* controller = action.sourceController;
    TBNavigationType type = reverseNavigateType([controller openNavigateType]);
    if (type == TBNavigationTypeNone) {
        if (controller.navigationController && [[controller.navigationController viewControllers] count] > 1) {
            type = TBNavigationTypePop;
        }
    }
    if (type == TBNavigationTypeNone) {
        UIViewController* parentController = controller;
        while (parentController != nil) {
            type = reverseNavigateType([controller openNavigateType]);
            if (type != TBNavigationTypeNone) {
                break;
            }
            parentController = parentController.parentViewController;
        }
    }
    if (type == TBNavigationTypeNone) {
        UIViewController* parent = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
            parent =  [action sourceController].presentingViewController;
        } else {
            parent = [action sourceController].parentViewController;
        }
        if (parent) {
            type = TBNavigationTypeDismiss;
        } else {
            type = TBNavigationTypeTabbarBack;
        }
    }
    UIViewController* containerViewController = [self containerViewControllerForController:controller navigateType:type];
    [containerViewController removeSubController:controller navigateType:type animated:YES];
    return YES;
}

- (BOOL)openMenuFromSource:(UIViewController *)source sender:(id)sender {
    return NO;
}

- (UIViewController*)containerViewControllerForController:(UIViewController *)viewController navigateType:(TBNavigationType)type {
    if ((type == TBNavigationTypePush || TBNavigationTypePop == type)) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            return viewController;
        }else if (viewController.navigationController) {
            return viewController.navigationController;
        }else if ([viewController isKindOfClass:[RDVTabBarController class]]) {
            RDVTabBarController* tabbarCtrl = (RDVTabBarController *)viewController;
            if ([tabbarCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
                return tabbarCtrl.selectedViewController;
            } else {
                return tabbarCtrl.selectedViewController.navigationController;
            }
        }else{
            UINavigationController* nav = viewController.navigationController;
            if (nav == nil) {
                RDVTabBarController* tabBarVC = viewController.rdv_tabBarController;
                return tabBarVC.navigationController;
            }
        }
    } else if ( TBNavigationTypeDismiss == type) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f ){
            return viewController.parentViewController;
        } else {
            return viewController.presentingViewController;
        }
    } else if (TBNavigationTypeTabbarSelect == type || TBNavigationTypeTabbarBack == type) {
        if (viewController.rdv_tabBarController) {
            return viewController.rdv_tabBarController;
        }
    } else if (TBNavigationTypePresent == type) {
        if (viewController.rdv_tabBarController) {
            return viewController.rdv_tabBarController;
        } else {
            return viewController;
        }
    }
    return nil;
}

@end
