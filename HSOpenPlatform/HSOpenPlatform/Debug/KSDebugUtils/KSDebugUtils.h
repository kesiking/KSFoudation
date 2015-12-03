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

/*!
 *  @author 孟希羲, 15-12-03 09:12:38
 *
 *  @brief  获取instance变量的属性名称及属性变量
 *
 *  @param  instanse 变量实例
 *
 *  @return property dict
 *
 *  @since  1.0
 */
+(NSMutableDictionary*)getInstansePropertyWithInstanse:(id)instanse;

@end
