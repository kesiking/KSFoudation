//
//  KSModifyPhoneView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSModifyPhoneView.h"
#import "KSLoginUtils.h"
#import "KSCheckRegisterService.h"

@interface KSModifyPhoneView()

@property (nonatomic, strong)      KSCheckRegisterService*                 checkRegister;

@end

@implementation KSModifyPhoneView

-(void)setupView{
    [super setupView];
    [self initLoginViewCtl];
    [self reloadData];
}

-(void)initLoginViewCtl{
    self.resetViewCtl.text_phoneNum.hidden = NO;
    self.resetViewCtl.text_smsCode.hidden = NO;
    self.resetViewCtl.btn_smsCode.hidden = NO;
    self.resetViewCtl.btn_finish.hidden = NO;
    self.resetViewCtl.btn_finish.enabled = NO;

    WEAKSELF
    self.resetViewCtl.text_phoneNum.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    
    self.resetViewCtl.text_smsCode.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    
    self.resetViewCtl.smsCodeSeconds = 60;
    
    [self.resetViewCtl.text_smsCode setFrame:CGRectMake(self.resetViewCtl.text_phoneNum.left, self.resetViewCtl.text_phoneNum.bottom + 8, self.resetViewCtl.text_smsCode.width, self.resetViewCtl.text_smsCode.height)];
    [self.resetViewCtl.btn_smsCode setFrame:CGRectMake(CGRectGetMaxX(self.resetViewCtl.frame) - 20 - btn_smsCode_width, self.resetViewCtl.text_smsCode.top, self.resetViewCtl.btn_smsCode.width, self.resetViewCtl.btn_smsCode.height)];
    
    [self addSubview:self.resetViewCtl];
    
    _checkRegister = [KSCheckRegisterService new];
}

-(void)reloadData{
    
}

-(void)setUser_password:(NSString *)user_password{
    _user_password = user_password;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - getValidateCodeService 获取验证码
-(KSLoginService *)getValidateCodeService{
    if (_validateCodeService == nil) {
        _validateCodeService = [[KSLoginService alloc] init];
        [self setupValidateCodeServcie];
    }
    return _validateCodeService;
}

-(void)setValidateCodeService:(KSLoginService *)validateCodeService{
    if (_validateCodeService != validateCodeService) {
        _validateCodeService = nil;
        _validateCodeService = validateCodeService;
        [self setupValidateCodeServcie];
    }
}

-(void)setupValidateCodeServcie{
    WEAKSELF
    _validateCodeService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:CHECKCODE_HAS_ALREADY_SEND];
    };
    
    _validateCodeService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        // 验证码获取失败需要重新获取
        [strongSelf.resetViewCtl resetSmsCodeButton];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        [WeAppToast toast:errorInfo];
    };
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - getValidateCodeService 获取验证码
-(KSLoginService *)getModifyService{
    if (_modifyService == nil) {
        _modifyService = [[KSLoginService alloc] init];
        [self setupModifyService];
    }
    return _modifyService;
}

-(void)setModifyService:(KSLoginService *)modifyService{
    if (_modifyService != modifyService) {
        _modifyService = nil;
        _modifyService = modifyService;
        [self setupModifyService];
    }
}

-(void)setupModifyService{
    WEAKSELF
    _modifyService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:@"更改账号成功"];
        if (strongSelf.modifyPhoneSuccessAction) {
            strongSelf.modifyPhoneSuccessAction(YES);
        }
    };
    
    _modifyService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        // 验证码获取失败需要重新获取
        [strongSelf.resetViewCtl resetSmsCodeButton];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"]?:@"更改账号失败，请稍微再试";
        [WeAppToast toast:errorInfo];
    };
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - resetViewCtl 忘记密码控件配置
-(void)setResetViewCtl:(KSResetViewCtl *)resetViewCtl{
    if (_resetViewCtl != resetViewCtl) {
        _resetViewCtl = nil;
        _resetViewCtl = resetViewCtl;
        [self setupResetViewCtl];
    }
}

-(KSResetViewCtl *)getResetViewCtl{
    if (_resetViewCtl == nil) {
        _resetViewCtl = [[KSResetViewCtl alloc] initWithFrame:self.bounds];
        [self setupResetViewCtl];
    }
    return _resetViewCtl;
}

-(void)setupResetViewCtl{
    WEAKSELF
    _resetViewCtl.getValidateColdBlock = ^(KSValidateCodeViewCtl* resetViewCtl){
        STRONGSELF
        if(![KSLoginUtils isValidMobile:((KSResetViewCtl*)resetViewCtl).text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return NO;
        }
        [strongSelf.checkRegister checkRegisterWithAccountName:((KSResetViewCtl*)resetViewCtl).text_phoneNum.text checkRegister:^(BOOL isRegister,NSError* error) {
            if (isRegister) {
                // 已经注册过弹出提示
                [WeAppToast toast:ALREADY_HAS_REGISTER_ACCOUNT_INFO];
                [strongSelf hideLoadingView];
                [strongSelf.resetViewCtl resetSmsCodeButton];
            }else{
                [strongSelf.validateCodeService sendValidateCodeWithAccountName:((KSResetViewCtl*)resetViewCtl).text_phoneNum.text];
            }
        }];
        [strongSelf showLoadingView];
        return YES;
    };
    
    _resetViewCtl.nextStepBlock = ^(KSResetViewCtl* resetViewCtl){
        STRONGSELF
        //判断逻辑待完善
        if(![KSLoginUtils isValidMobile:resetViewCtl.text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }else if(![KSLoginUtils isValidAuthCode:resetViewCtl.text_smsCode.text])
        {
            [WeAppToast toast:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO];
            return;
        }else if([KSLoginUtils isEmptyString:strongSelf.user_password])
        {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        
        [strongSelf.modifyService modifyPhoneNumberWithOldAccountName:nil newAccountName:resetViewCtl.text_phoneNum.text password:strongSelf.user_password validateCode:resetViewCtl.text_smsCode.text];
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [KSLoginUtils isNotEmptyString:self.resetViewCtl.text_phoneNum.text] && [KSLoginUtils isNotEmptyString:self.resetViewCtl.text_smsCode.text];
    self.resetViewCtl.btn_nextStep.enabled = loginBtnEnable;
}

@end
