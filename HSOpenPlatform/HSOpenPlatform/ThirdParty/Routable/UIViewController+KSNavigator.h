//
//  UIViewController+KSNavigator.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBNavigationType.h"

@protocol UIViewControllerKSNavigator <NSObject>

@optional

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;

// 预留Native参数，解决为了安全等问题，不方便在url中传输入的参数
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams;

// 用于已经存在的viewController，就不能使用init函数，而是需要把参数透过该方法传入
- (void)setupNavigatorURL:(NSURL*)URL query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams;

@end


@interface UIViewController (KSNavigator)<UIViewControllerKSNavigator>

@property (nonatomic, assign) TBNavigationType    openNavigateType;

- (void)addSubcontroller:(UIViewController*)controller navigateType:(TBNavigationType)type animated:(BOOL)animated;
- (void)removeSubController:(UIViewController *)controller navigateType:(TBNavigationType)type animated:(BOOL)animated;

@end
