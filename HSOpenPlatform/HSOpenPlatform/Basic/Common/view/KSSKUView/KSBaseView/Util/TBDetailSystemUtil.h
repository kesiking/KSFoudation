//
//  TBDetailSystemUtil.h
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface TBDetailSystemUtil : NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - System Version
/**
 *  获取当前操作系统版本
 *
 *  @return 操作系统版本号
 */
+ (float)getSystemVersion;

/**
 *  判断当前系统版本是否低于iOS6.0
 *
 *  @return YES:低于6.0; NO:等于或高于6.0
 */
+ (BOOL)systemVersionIsLessThan6_0;

/**
 *  判断当前系统版本是否低于iOS7.0
 *
 *  @return YES:低于7.0; NO:等于或高于7.0
 */
+ (BOOL)systemVersionIsLessThan7_0;

/**
 *  判断当前系统版本是否低于iOS8.0
 *
 *  @return YES:低于8.0; NO:等于或高于8.0
 */
+ (BOOL)systemVersionIsLessThan8_0;

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Screen Size
/**
 *  获取iPhone4/4s的屏幕大小
 *
 *  @return 屏幕大小
 */
+ (CGSize)getiPhone4ScreenSize;

/**
 *  获取iPhone5/5S屏幕大小
 *
 *  @return 屏幕大小
 */
+ (CGSize)getiPhone5ScreenSize;

/**
 *  获取iPhone6屏幕大小
 *
 *  @return 屏幕大小
 */
+ (CGSize)getiPhone6ScreenSize;

/**
 *  获取iPhone6P屏幕大小
 *
 *  @return 屏幕大小
 */
+ (CGSize)getiPhone6PScreenSize;

/**
 *  获取当前设备屏幕宽度与iPhone4的比例
 *
 *  @return 比例(>=1)
 */
+ (CGFloat)getWidthRatioCompareToIphone4;

/**
 *  获取当前设备屏幕高度与iPhone5的比例
 *
 *  @return 比例(>=1)
 */
+ (CGFloat)getHeightRatioCompareToIphone4;

/**
 *  获取当前设备屏幕高度与iPhone5的比例
 *
 *  @return 比例(>=1)
 */
+ (CGFloat)getHeightRatioCompareToIphone5;
/**
 *  获取当前设备的宽度
 *
 *  @return 宽度
 */
+ (CGFloat)getCurrentDeviceWidth;

/**
 *  获取当前设备的高度
 *
 *  @return 高度
 */
+ (CGFloat)getCurrentDeviceHeight;

@end
