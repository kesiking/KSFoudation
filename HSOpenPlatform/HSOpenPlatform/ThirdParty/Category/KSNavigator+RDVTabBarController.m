//
//  KSNavigator+RDVTabBarController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSNavigator+RDVTabBarController.h"

@implementation RDVTabBarController (KSNavigator)

- (void)addSubcontroller:(UIViewController *)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypeTabbarSelect == type) {
        if (controller.rdv_tabBarController) {
            [self.navigationController popToViewController:controller.rdv_tabBarController animated:animated];
        }
        [self setSelectedViewController:controller];
    } else if (TBNavigationTypePresent == type) {
        [self presentViewController:controller animated:animated completion:^{
            NSLog(@"-----> success");
        }];
    }
}

- (void)removeSubController:(UIViewController *)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypeTabbarBack == type) {
    } else if (TBNavigationTypeDismiss == type) {
        [self dismissViewControllerAnimated:animated completion:NULL];
    }
}

@end
