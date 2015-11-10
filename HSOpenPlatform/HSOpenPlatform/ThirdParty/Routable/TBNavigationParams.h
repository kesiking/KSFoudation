//
//  TBNavigationParams.h
//  Taobao2013
//
//  Created by 晨燕 on 13-2-5.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBNavigationType.h"

#define kTBNavigationParamsKey      @"_navigation_params"
#define kTBObjectPropertyKey        @"_obj_properties"

@interface TBNavigationParams : NSObject

//是否需要动画，默认YES
@property (nonatomic, assign) BOOL                      animated;

//是否需要navigationController包装，默认NO
@property (nonatomic, assign) BOOL                      needNavigationCtrl;

//是否需要登陆，默认NO
@property (nonatomic, assign) BOOL                      needLogin;

//是否需要安全码，默认NO
@property (nonatomic, assign) BOOL                      needSafeCode;

//是否需要把当前页面present出来的controller dismiss掉，默认YES
@property (nonatomic, assign) BOOL                      needDissmiss;

//默认push
@property (nonatomic, assign) TBNavigationType          navigationType;

//默认为空
@property (nonatomic, copy) NSString*                   target;


- (NSString *)stringofNavigationParams;
+ (TBNavigationParams *)navigationParamsofDictionary:(NSDictionary *)dic;

@end
