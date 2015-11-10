//
//  .m
//  Taobao2013
//
//  Created by 晨燕 on 13-2-5.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "TBNavigationType.h"

NSString* stringofNavigationType(TBNavigationType type) {
    NSString* navStr;
    if (TBNavigationTypePush == type) {
        navStr = @"push";
    } else if (TBNavigationTypePop == type) {
            navStr = @"pop";
    } else if (TBNavigationTypePresent == type) {
        navStr = @"present";
    } else if (TBNavigationTypeDismiss == type) {
        navStr = @"dismiss";
    } else if (TBNavigationTypeTabbarSelect == type) {
        navStr = @"tabbarSelect";
    } else if (TBNavigationTypeTabbarBack == type) {
        navStr = @"tabbarBack";
    } 
    return navStr;
}

TBNavigationType navigationTypeofString(NSString* navStr) {
    TBNavigationType type = TBNavigationTypeNone;
    if ([navStr isEqualToString:@"push"]) {
        type = TBNavigationTypePush;
    } else if ([navStr isEqualToString:@"pop"]) {
        type = TBNavigationTypePop;
    } else if ([navStr isEqualToString:@"present"]) {
        type = TBNavigationTypePresent;
    } else if ([navStr isEqualToString:@"dismiss"]) {
        type = TBNavigationTypeDismiss;
    } else if ([navStr isEqualToString:@"tabbarSelect"]) {
        type = TBNavigationTypeTabbarSelect;
    } else if ([navStr isEqualToString:@"tabbarBack"]) {
        type = TBNavigationTypeTabbarBack;
    }
    return type;
}

TBNavigationType reverseNavigateType(TBNavigationType openType) {
    if (TBNavigationTypePush == openType) {
        return TBNavigationTypePop;
    } else if (TBNavigationTypePop == openType) {
        return TBNavigationTypePush;
    } else if (TBNavigationTypePresent == openType) {
        return TBNavigationTypeDismiss;
    } else if (TBNavigationTypeDismiss == openType) {
        return TBNavigationTypePresent;
    } else if (TBNavigationTypeTabbarSelect == openType) {
        return TBNavigationTypeTabbarBack;
    } else if (TBNavigationTypeTabbarBack == openType) {
        return TBNavigationTypeTabbarSelect;
    }
    return TBNavigationTypeNone;
}
