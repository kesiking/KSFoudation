//
//  UIViewController+KSNavigator.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "UIViewController+KSNavigator.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const OpenNavigateTypeKey = @"OpenNavigateTypeKey";

@implementation UIViewController (KSNavigator)

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
    if (self = [self init]) {
    }
    return self;
}

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams {
    if (!nativeParams) {
        self = [self initWithNavigatorURL:URL query:query];
    } else {
        self = [self init];
    }
    return self;
}

- (void)setupNavigatorURL:(NSURL*)URL query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams{
    
}

- (TBNavigationType)openNavigateType {
    NSNumber* num = objc_getAssociatedObject(self, ((__bridge void*)OpenNavigateTypeKey));
    TBNavigationType type = (TBNavigationType)[num integerValue];
    return type;
}

- (void)setOpenNavigateType:(TBNavigationType)openNavigateType {
    objc_setAssociatedObject(self, ((__bridge void*)OpenNavigateTypeKey), [NSNumber numberWithInteger:openNavigateType], OBJC_ASSOCIATION_RETAIN);
}

- (void)addSubcontroller:(UIViewController*)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypePresent == type) {
        [self presentViewController:controller animated:animated completion:NULL];
    }
}

- (void)removeSubController:(UIViewController *)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypeDismiss == type) {
        [self dismissViewControllerAnimated:animated completion:NULL];
    }
}

@end

@implementation UINavigationController (KSNavigator)

- (void)addSubcontroller:(UIViewController*)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypePush == type && ![controller isKindOfClass:[UINavigationController class]]) {
        [self pushViewController:controller animated:animated];
    } else if (TBNavigationTypePresent == type ) {
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self presentViewController:controller animated:animated completion:NULL];
        }else{
            [self presentModalViewController:controller animated:animated];
        }
    } 
}


- (void)removeSubController:(UIViewController *)controller navigateType:(TBNavigationType)type animated:(BOOL)animated {
    if (TBNavigationTypePop == type) {
        [self popViewControllerAnimated:animated];
        
    } else if (TBNavigationTypeDismiss == type) {
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self dismissViewControllerAnimated:animated completion:NULL];
        }else{
            [self dismissModalViewControllerAnimated:animated];
        }
    }
}

@end
