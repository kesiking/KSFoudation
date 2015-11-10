//
//  KSTabBarViewControllerProtocol.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@protocol KSTabBarViewControllerProtocol <NSObject>

// 是否能够被选中，默认返回YES
// 例如需要登陆却没有登陆情况应当返回NO
// 传入viewController其实是RDVTabBarController类型的
-(BOOL)shouldSelectViewController:(UIViewController*)viewController;

// 点击选中
-(void)didSelectViewController:(UIViewController*)viewController;

// 重复点击选中
-(void)didSelectSameViewController:(UIViewController *)viewController;

// 设置选中viewController的frame
-(CGRect)selectViewControllerRectForBounds:(CGRect)bounds;

@end
