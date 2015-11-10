//
//  KSManWuTabBarViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "RDVTabBarController.h"

typedef NS_ENUM(NSInteger, EHTabBarViewControllerType) {
    EHTabBarViewControllerType_Home                  = 0,  //0主页,1为运动,2为我的
    EHTabBarViewControllerType_Sport                 = 1,
    EHTabBarViewControllerType_MyInfo                = 2,
};

@interface EHTabBarViewController : RDVTabBarController

-(UIViewController*)getViewControllerWithURL:(NSString*)url;

@end

@interface UIViewController (KSManWuTabBarViewController)

-(UINavigationController *)KSNavigationController;

@end

@interface EHTabBarViewController (UIApplication)

+(EHTabBarViewController*)getTabBarViewController;

@end

