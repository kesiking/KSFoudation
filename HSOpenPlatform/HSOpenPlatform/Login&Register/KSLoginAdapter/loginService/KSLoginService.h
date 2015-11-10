//
//  KSLoginService.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterService.h"
#import "KSLoginMaroc.h"

#define login_api_name              @"terUserAction/loginCheck.do"

#define logout_api_name             @"terUserAction/memberLoginOut.do"

#define register_api_name           @"terUserAction/registerMember.do"

#define checkAccountName_api_name   @"terUserAction/checkUserPhone.do"

#define reset_api_name              @"terUserAction/updatePassword.do"

#define modifyPwd_api_name          @"terUserAction/changeUserInfo.do"

#define sendValidateCode_api_name   @"terUserAction/resendRandomNum.do"

#define checkValidateCode_api_name  @"terUserAction/checkSecurityCode.do"

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
 *  @brief  获取验证码接口
 *
 *  @param accountName 用户手机号
 *
 *  @since 1.0
 */
-(void)sendValidateCodeWithAccountName:(NSString*)accountName;
/*!
 *  @brief  检验验证码接口
 *
 *  @param accountName  用户手机号
 *  @param validateCode 验证码
 *
 *  @since 1.0
 */
-(void)checkValidateCodeWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode;
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

#define get_user_info_api_name      @"user/getUserInfo.do"

@interface KSUserInfoService : KSAdapterService

-(void)getAccountInfoWithAccountName:(NSString*)accountName;

@end
