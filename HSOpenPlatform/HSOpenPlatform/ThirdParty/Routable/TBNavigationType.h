//
//  TBNavigationType.h
//  Taobao2013
//
//  Created by 晨燕 on 13-2-5.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TBNavigationTypeNone = 0,
    TBNavigationTypePush = 1,
    TBNavigationTypePop,
    TBNavigationTypePresent,
    TBNavigationTypeDismiss,
    TBNavigationTypeTabbarSelect,
    TBNavigationTypeTabbarBack
}TBNavigationType;

NSString* stringofNavigationType(TBNavigationType type);
TBNavigationType navigationTypeofString(NSString* string);
TBNavigationType reverseNavigateType(TBNavigationType openType);