//
//  KSAuthenticationCenter.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-11.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSLoginMaroc.h"

#define kAuthenticationCenterMarocExist

#define kTestAccountName @"18888888888"  //  18867101652   18019437985

@interface KSAuthenticationCenter : NSObject

+ (instancetype)sharedCenter;

+ (NSString*)userId;

+ (NSString*)userPhone;

+ (NSString*)preUserPhone;

+ (KSLoginComponentItem*)userComponent;

+ (BOOL)isLogin;

+ (BOOL)isTestAccount;

+ (void)logoutWithCompleteBolck:(dispatch_block_t)completeBlock;

- (void)authenticateWithLoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock;
/*!
 *  @brief  登录检验，如果未登录拉起登录界面，登录后调用loginActionBlock回调，取消登录调用cancelActionBlock回调
 *
 *  @param loginActionBlock  登录后调用loginActionBlock回调
 *  @param cancelActionBlock 取消登录调用cancelActionBlock回调
 *  @param source            指定在哪个viewController上拉起登陆框，可以传UIViewController或是UIView
 *
 *  @since 1.0
 */
- (void)authenticateWithLoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock source:(id)source;

/*!
 *  @brief  登录检验，有弹出提示，确定后检查登录，调用authenticateWithLoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock source:(id)source方法逻辑
 *
 *  @param message           alertView的警告提示
 *  @param loginActionBlock  登录后调用loginActionBlock回调
 *  @param cancelActionBlock 取消登录调用cancelActionBlock回调
 *  @param source            指定在哪个viewController上拉起登陆框，可以传UIViewController或是UIView
 *
 *  @since 1.0
 */
- (void)authenticateWithAlertViewMessage:(NSString*)message LoginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock source:(id)source;

- (void)autoLoginWithCompleteBlock:(dispatch_block_t)completeBlock;

/*!
 *  @brief  重复登录被挤掉时调用接口，message为弹出aleatview的警告语
 *
 *  @param message           弹出aleatview的警告语
 *  @param loginActionBlock  登录后回调
 *  @param cancelActionBlock 取消登录后回调
 *
 *  @since 1.0
 */
- (void)repeatLoginAleatViewWithMessage:(NSString*)message loginActionBlock:(loginActionBlock)loginActionBlock cancelActionBlock:(cancelActionBlock)cancelActionBlock;

@end
