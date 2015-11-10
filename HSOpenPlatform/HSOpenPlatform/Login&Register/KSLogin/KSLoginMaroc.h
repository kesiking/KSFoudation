//
//  KSLoginMaroc.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#ifndef basicFoundation_KSLoginMaroc_h
#define basicFoundation_KSLoginMaroc_h

#define loginFailCode      (1004)
#define loginFailDomain    @"login failed"

#define kLoginSuccessBlock @"loginSuccessBlock"
#define kLoginCancelBlock  @"loginCancelBlock"

#define kSpaceX (25.0)

#define UserInfo @"userInfo"   //登录用户信息
#define USERID   @"userId"   //登录用户id

#define LOGIN_FLAG @"alreadyLogin"  //标识已登录

typedef void (^loginActionBlock)(BOOL loginSuccess);
typedef void (^cancelActionBlock)(void);

static NSString * const  kUserLoginSuccessNotification = @"kUserLoginSuccessNotification";
static NSString * const  kUserLoginFailNotification = @"kUserLoginFailNotification";
static NSString * const  kUserLoginCancelNotification = @"kUserLoginCancelNotification";

static NSString * const  kUserLogoutSuccessNotification = @"kUserLogoutSuccessNotification";
static NSString * const  kUserLogoutFailNotification = @"kUserLogoutFailNotification";

static NSString * const  kUserRegisterSuccessNotification = @"kUserRegisterSuccessNotification";
static NSString * const  kUserRegisterFailNotification = @"kUserRegisterFailNotification";

#endif
