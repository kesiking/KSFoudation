//
//  KSDebugUtils.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugUtils : NSObject

/*!
 *  @author 孟希羲, 15-12-02 10:12:04
 *
 *  @brief  获取当前展示在屏幕上的viewController
 *
 *  @return CurrentAppearedViewController
 *
 *  @since  1.0
 */
+ (UIViewController*)getCurrentAppearedViewController;

@end
