//
//  TBNavigatorURLParams.h
//  TaobaoPlugin
//
//  Created by 晨燕 on 13-3-5.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

typedef enum {
    TBTabHome = 0,
    TBTabMessage,
    TBTabSearch,
    TBTabCart,
    TBTabMyTaobao
} TBTab;


typedef enum {
    TBSimplePayStatusSuccess,
    TBSimplePayStatusFail,
    TBSimplePayStatusWAPBack
} TBSimplePayStatus;

typedef void(^SimplePayCallbackBlock)(TBSimplePayStatus status);

#define kInternalNavigationURLScheme            @"app"
#define kInternalGoToURLHost                    @"go"
#define kInternalTabbarURLHost                  @"tabbar"
#define kInternalReactNativeURLScheme           @"reactNative"

#define loginPath                               @"login"

#define tabbarURL(tab)                          [NSString stringWithFormat:@"%@://%@/%@",kInternalNavigationURLScheme, kInternalTabbarURLHost,tab]

#define internalURL(vcName)                     [NSString stringWithFormat:@"%@://%@/%@",kInternalNavigationURLScheme, kInternalGoToURLHost,vcName]

#define loginURL                                [NSString stringWithFormat:@"%@://%@/%@",kInternalNavigationURLScheme, kInternalGoToURLHost,loginPath]
