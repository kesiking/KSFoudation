//
//  KSLoginService.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterService.h"
#import "KSLoginMaroc.h"

#define login_api_name              @"doLogin"

#define logout_api_name             @"doLoginOut"

#define register_api_name           @"doReg"

#define checkAccountName_api_name   @"isReg"

#define reset_api_name              @"resetPwd"

#define modifyPwd_api_name          @"updatePwd"

#define sendValidateCode_api_name   @"getCode"

#define checkValidateCode_api_name  @"checkCode"

typedef NS_ENUM(NSUInteger, KSLoginServiceSendValidateCodeOptType) {
    KSLoginServiceSendValidateCodeRegister      = 1,
    KSLoginServiceSendValidateCodeResetPassword = 2,
};

@interface KSLoginService : KSAdapterService

/*!
 *  @brief  登录接口
 *
 *  @param accountName 用户手机号
 *  @param password    用户密码
 *
 *  @since 1.0
 */
-(void)loginWithAccountName:(NSString*)accountName password:(NSString*)password;
/*!
 *  @brief  登出接口
 *
 *  @param accountName 用户手机号
 *
 *  @since 1.0
 */
-(void)logoutWithAccountName:(NSString*)accountName;
/*!
 *  @brief  获取验证码接口，默认获取注册的验证码
 *
 *  @param accountName 用户手机号
 *
 *  @since 1.0
 */
-(void)sendValidateCodeWithAccountName:(NSString*)accountName;
/*!
 *  @author 孟希羲, 2016-03-30 09:03:38
 *
 *  @brief 获取验证码接口
 *
 *  @param accountName 用户手机号
 *  @param optType     验证码类型，如注册用的，找回密码用的
 *
 *  @since 1.0
 */
-(void)sendValidateCodeWithAccountName:(NSString*)accountName withOptType:(KSLoginServiceSendValidateCodeOptType)optType;
/*!
 *  @brief  检验验证码接口，默认校验注册的验证码
 *
 *  @param accountName  用户手机号
 *  @param validateCode 验证码
 *
 *  @since 1.0
 */
-(void)checkValidateCodeWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode;
/*!
 *  @author 孟希羲, 2016-03-30 09:03:09
 *
 *  @brief 检验验证码接口
 *
 *  @param accountName  用户手机号
 *  @param validateCode 验证码
 *  @param optType      验证码类型，如注册用的，找回密码用的
 *
 *  @since 1.0
 */
-(void)checkValidateCodeWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode withOptType:(KSLoginServiceSendValidateCodeOptType)optType;
/*!
 *  @brief  找回密码接口
 *
 *  @param accountName  用户手机号
 *  @param validateCode 验证码
 *  @param newPassword  新密码
 *
 *  @since 1.0
 */
-(void)resetPasswordWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode newPassword:(NSString*)newPassword;
/*!
 *  @brief  修改密码接口
 *
 *  @param accountName 用户手机号
 *  @param oldPassword 原密码
 *  @param newPassword 新密码
 *
 *  @since 1.0
 */
-(void)modifyPasswordWithAccountName:(NSString*)accountName oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword;
/*!
 *  @brief  修改手机接口
 *
 *  @param oldAccountName 用户原手机号
 *  @param newAccountName 用户新手机号
 *  @param password       用户密码
 *  @param validateCode   验证码
 *
 *  @since 1.0
 */
-(void)modifyPhoneNumberWithOldAccountName:(NSString*)oldAccountName newAccountName:(NSString*)newAccountName password:(NSString*)password validateCode:(NSString*)validateCode;
/*!
 *  @brief  注册接口
 *
 *  @param accountName  用户手机号
 *  @param password     用户密码
 *  @param userName     用户昵称
 *  @param validateCode 验证码
 *  @param inviteCode   邀请码
 *
 *  @since 1.0
 */
-(void)registerWithAccountName:(NSString*)accountName password:(NSString*)password userName:(NSString*)userName validateCode:(NSString*)validateCode inviteCode:(NSString*)inviteCode;
/*!
 *  @brief  用户是否注册，并获取验证码
 *
 *  @param accountName 用户手机号
 *
 *  @since 1.0
 */
-(void)checkAccountName:(NSString*)accountName;

@end

#define get_user_info_api_name      @"getUserInfo"

@interface KSUserInfoService : KSAdapterService

-(void)getAccountInfoWithAccountName:(NSString*)accountName;

@end
