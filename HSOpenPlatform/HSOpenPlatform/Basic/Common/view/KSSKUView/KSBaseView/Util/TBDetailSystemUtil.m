//
//  TBDetailSystemUtil.m
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailSystemUtil.h"

@implementation TBDetailSystemUtil
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - System Version
+ (float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)systemVersionIsLessThan6_0
{
    if ([TBDetailSystemUtil getSystemVersion] < 6.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)systemVersionIsLessThan7_0
{
    if ([TBDetailSystemUtil getSystemVersion] < 7.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)systemVersionIsLessThan8_0
{
    if ([TBDetailSystemUtil getSystemVersion] < 8.0) {
        return YES;
    }
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Screen Size
+ (CGSize)getiPhone4ScreenSize
{
    return CGSizeMake(320.0f, 480.0f);
}

+ (CGSize)getiPhone5ScreenSize
{
    return CGSizeMake(320.0f, 568.0f);
}

+ (CGSize)getiPhone6ScreenSize
{
    return CGSizeMake(375.0f, 667.0f);
}

+ (CGSize)getiPhone6PScreenSize
{
    return CGSizeMake(414.0f, 736.0f);
}

+ (CGFloat)getCurrentDeviceWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)getCurrentDeviceHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)getWidthRatioCompareToIphone4
{
    return [TBDetailSystemUtil getCurrentDeviceWidth] / 320.0f;
}

+ (CGFloat)getHeightRatioCompareToIphone4
{
    return [TBDetailSystemUtil getCurrentDeviceHeight] / 480.0f;
}

+ (CGFloat)getHeightRatioCompareToIphone5
{
    return [TBDetailSystemUtil getCurrentDeviceHeight] / 568.0f;
}

@end
