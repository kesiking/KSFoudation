//
//  KSLoginService.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginService.h"
#import "KSLoginComponentItem.h"

#define LOGIN_DEFAULT_SCHEME @"https"
#define LOGIN_DEFAULT_HOST @"112.54.207.8"
#define LOGIN_DEFAULT_PORT @"8081"
#define LOGIN_DEFAULT_PARH @"PersonSafeManagement/"
#define LOGIN_DEFAULT_BASE_URL [NSString stringWithFormat:@"%@://%@:%@/%@",LOGIN_DEFAULT_SCHEME,LOGIN_DEFAULT_HOST,LOGIN_DEFAULT_PORT,LOGIN_DEFAULT_PARH]

@interface KSLoginService()

@property (nonatomic, strong) NSString          *accountName;

@property (nonatomic, strong) NSString          *password;

@property (nonatomic, strong) KSUserInfoService *userInfoService;

@end

@implementation KSLoginService

-(void)setupService{
    [super setupService];
    self.serviceContext.baseUrl = LOGIN_DEFAULT_BASE_URL;
    [self.serviceContext.serviceContextDict setObject:@"outPut_msg" forKey:@"resultString"];
    [self.serviceContext.serviceContextDict setObject:@"outPut_time" forKey:@"resultTime"];
    [self.serviceContext.serviceContextDict setObject:@"outPut_status" forKey:@"resultCode"];
    [self.serviceContext.serviceContextDict setObject:@YES forKey:@"requestSerializerNeedJson"];
    [self.serviceContext.serviceContextDict setObject:@"text/html" forKey:@"Content-Type"];
}

-(void)loginWithAccountName:(NSString*)accountName password:(NSString*)password{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil || password == nil) {
        return;
    }
    self.accountName = accountName;
    self.password = password;
    [self setItemClass:[KSLoginComponentItem class]];
    [self loadItemWithAPIName:login_api_name params:@{@"user_phone":self.accountName, @"user_password":self.password} version:nil];
}

-(void)logoutWithAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil) {
        return;
    }
    [self loadItemWithAPIName:logout_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)sendValidateCodeWithAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil) {
        return;
    }
    [self loadNumberValueWithAPIName:sendValidateCode_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)checkValidateCodeWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]
        || [WeAppUtils isEmpty:validateCode]) {
        return;
    }
    [self loadNumberValueWithAPIName:checkValidateCode_api_name params:@{@"user_phone":accountName,@"securityCode":validateCode} version:nil];
}

-(void)modifyPasswordWithAccountName:(NSString*)accountName oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil
        || oldPassword == nil
        || newPassword == nil) {
        return;
    }
    self.password = newPassword;
    [self loadItemWithAPIName:modifyPwd_api_name params:@{@"user_phone":accountName,@"old_psw":oldPassword,@"new_psw":newPassword,@"flag":@"00000010"} version:nil];
}

-(void)modifyPhoneNumberWithOldAccountName:(NSString*)oldAccountName newAccountName:(NSString*)newAccountName password:(NSString*)password validateCode:(NSString*)validateCode{
    if (oldAccountName == nil) {
        oldAccountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (oldAccountName == nil
        || newAccountName == nil
        || password == nil
        || validateCode == nil) {
        return;
    }
    [self loadItemWithAPIName:modifyPwd_api_name params:@{@"user_phone":newAccountName,@"old_phone":oldAccountName,@"new_phone":newAccountName,@"user_psd":password,@"securityCode":validateCode,@"flag":@"00000001"} version:nil];
}

-(void)resetPasswordWithAccountName:(NSString*)accountName validateCode:(NSString*)validateCode newPassword:(NSString*)newPassword{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil
        || validateCode == nil
        || newPassword == nil) {
        return;
    }
    self.accountName = accountName;
    self.password = newPassword;
    [self loadNumberValueWithAPIName:reset_api_name params:@{@"user_phone":accountName,@"user_password":newPassword,@"securityCode":validateCode} version:nil];
}

-(void)registerWithAccountName:(NSString*)accountName password:(NSString*)password userName:(NSString*)userName validateCode:(NSString*)validateCode inviteCode:(NSString*)inviteCode{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]
        || [WeAppUtils isEmpty:password]
        || [WeAppUtils isEmpty:userName]) {
        return;
    }
    self.accountName = accountName;
    self.password = password;
    self.jsonTopKey = @"responseData";
    NSMutableDictionary* params = [@{@"user_phone":accountName, @"user_password":password , @"nick_name":userName,@"user_head_img":@"",@"user_head_img_small":@""} mutableCopy];
    if (![WeAppUtils isEmpty:inviteCode]) {
        [params setObject:inviteCode forKey:@"code"];
    }
    if (![WeAppUtils isEmpty:validateCode]) {
        [params setObject:validateCode forKey:@"validateCode"];
    }
    [self setItemClass:[KSLoginComponentItem class]];
    
    [self loadItemWithAPIName:register_api_name params:params version:nil];
}

-(void)checkAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if ([WeAppUtils isEmpty:accountName]) {
        return;
    }
    [self loadItemWithAPIName:checkAccountName_api_name params:@{@"user_phone":accountName} version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    if ([model.apiName isEqualToString:login_api_name]) {
        // 返回成功后记录下登陆账号与密码
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
        // 更新userInfo信息，更新登陆信息
        [[KSLoginComponentItem sharedInstance] updateUserInfo:[model.item toDictionary]];
        [[KSLoginComponentItem sharedInstance] updateUserLogin:YES];
        // 发送成功登陆消息
        /*!
         *  @author 孟希羲, 15-10-29 10:10:11
         *
         *  @brief  使用第三方库(安全开放平台)登录,登录完成后拉取自己平台的用户信息，拉取成功才算登录成功
         *
         *  @since  1.0
         */
        [self.userInfoService getAccountInfoWithAccountName:self.accountName];
        /*!
         *  @author 孟希羲, 15-10-29 10:10:36
         *
         *  @brief  发送登录成功消息，鉴于用第三方登录，因此需要再本地平台再拉取一次数据，数据拉取成功后再发送消息
         *
         *  @since  1.0
         */
        /*
         *
         [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification object:nil userInfo:nil];
         */
    }else if([model.apiName isEqualToString:logout_api_name]){
        [[KSLoginComponentItem sharedInstance] updateUserLogin:NO];
        // 清除登录内容状态
        [[KSLoginComponentItem sharedInstance] clearPassword];
        // 发送成功登出消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccessNotification object:nil userInfo:nil];
    }else if ([model.apiName isEqualToString:register_api_name]){
        // 返回成功后记录下登陆账号与密码
        if (!self.accountName) {
            self.accountName = [model.params objectForKey:@"user_phone"];
        }
        if (!self.password) {
            self.password = [model.params objectForKey:@"user_password"];
        }
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
        // 发送成功注册消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserRegisterSuccessNotification object:nil userInfo:nil];
    }else if ([model.apiName isEqualToString:reset_api_name]){
        // 返回成功后记录下登陆账号与密码
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
        [[KSLoginComponentItem sharedInstance] setAccountName:self.accountName];
    }else if ([model.apiName isEqualToString:modifyPwd_api_name]){
//        [[KSLoginComponentItem sharedInstance] clearPassword];
        [[KSLoginComponentItem sharedInstance] setPassword:self.password];
    }
    [super modelDidFinishLoad:model];
}

-(void)model:(WeAppBasicRequestModel *)model didFailLoadWithError:(NSError *)error{
    if ([model.apiName isEqualToString:login_api_name]) {
        // 发送登陆失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginFailNotification object:nil userInfo:@{@"error":error?:@""}];

    }else if([model.apiName isEqualToString:logout_api_name]){
        // 发送登出失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutFailNotification object:nil userInfo:@{@"error":error?:@""}];
    }else if ([model.apiName isEqualToString:register_api_name]){
        // 发送注册失败消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserRegisterFailNotification object:nil userInfo:@{@"error":error?:@""}];
    }
    [super model:model didFailLoadWithError:error];
}

-(KSUserInfoService *)userInfoService{
    if (_userInfoService == nil) {
        _userInfoService = [KSUserInfoService new];
        WEAKSELF
        _userInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            // 发送成功注册消息
            if (service.item && [service.item isKindOfClass:[KSLoginComponentItem class]]) {
                [[KSLoginComponentItem sharedInstance] updateUserComponentItem:(KSLoginComponentItem*)service.item];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserRegisterSuccessNotification object:nil userInfo:nil];
            }else{
                NSError* error = [NSError errorWithDomain:@"获取个人信息失败，请稍微再试" code:400 userInfo:nil];
                [strongSelf model:strongSelf.requestModel didFailLoadWithError:error];
            }
        };
        _userInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service ,NSError* error){
            STRONGSELF
            // 发送成功注册消息
            [strongSelf model:strongSelf.requestModel didFailLoadWithError:error];
        };
    }
    return _userInfoService;
}

@end

@implementation KSUserInfoService : KSAdapterService

-(void)getAccountInfoWithAccountName:(NSString*)accountName{
    if (accountName == nil) {
        accountName = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (accountName == nil) {
        return;
    }
    [self setItemClass:[KSLoginComponentItem class]];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    [self loadItemWithAPIName:get_user_info_api_name params:@{@"userPhone":accountName} version:nil];
}

@end
