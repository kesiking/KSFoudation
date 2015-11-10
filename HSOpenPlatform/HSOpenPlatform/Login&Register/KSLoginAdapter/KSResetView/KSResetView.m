//
//  KSResetView.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSResetView.h"
#import "KSLoginUtils.h"
#import "KSLoginComponentItem.h"
#import "KSLoginUrlPath.h"
#import "KSCheckRegisterService.h"

@interface KSResetView()

@property (nonatomic, strong)      KSCheckRegisterService*                 checkRegister;

@end

@implementation KSResetView

-(void)setupView{
    [super setupView];
    [self initLoginViewCtl];
    [self reloadData];
}

-(void)initLoginViewCtl{
    self.resetViewCtl.text_phoneNum.hidden = NO;
    self.resetViewCtl.text_smsCode.hidden = NO;
    self.resetViewCtl.btn_smsCode.hidden = NO;
    
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
    self.resetViewCtl.text_phoneNum.text = [[KSLoginComponentItem sharedInstance] getAccountName];
}

-(void)setUser_phone:(NSString *)user_phone{
    _user_phone = user_phone;
    self.resetViewCtl.text_phoneNum.text = user_phone;
}

-(void)layoutSubviews{
    [super layoutSubviews];
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
#pragma mark - validateCodeCheckService  邀请码验证
-(void)setValidateCodeCheckService:(KSLoginService *)validateCodeCheckService{
    if (_validateCodeCheckService != validateCodeCheckService) {
        _validateCodeCheckService = nil;
        _validateCodeCheckService = validateCodeCheckService;
        [self setupValidateCodeCheckServcie];
    }
}

-(KSLoginService *)getValidateCodeCheckService{
    if (_validateCodeCheckService == nil) {
        _validateCodeCheckService = [[KSLoginService alloc] init];
        [self setupValidateCodeCheckServcie];
    }
    return _validateCodeCheckService;
}

-(void)setupValidateCodeCheckServcie{
    
    WEAKSELF
    _validateCodeCheckService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        /*!
         *  @brief  检验验证码成功后跳转到下一步
         *
         *  @since
         */
        if(![KSLoginUtils isValidMobile:strongSelf.resetViewCtl.text_phoneNum.text])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }else if(strongSelf.resetViewCtl.text_smsCode.text == nil
                 || strongSelf.resetViewCtl.text_smsCode.text.length == 0)
        {
            [WeAppToast toast:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO];
            return;
        }
        NSString* smsCode = strongSelf.resetViewCtl.text_smsCode.text;
        NSString* phoneNum = strongSelf.resetViewCtl.text_phoneNum.text;
        NSDictionary* params= @{@"smsCode":smsCode,@"phoneNum":phoneNum};
        TBOpenURLFromTargetWithNativeParams(internalURL(kDoneResetPwdPage), strongSelf, nil,params);
    };
    
    _validateCodeCheckService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        NSString* errorInfo = [error.userInfo objectForKey:NSLocalizedDescriptionKey]?:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO;
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
        [strongSelf showLoadingView];
        // 检查是否注册
        [strongSelf.checkRegister checkRegisterWithAccountName:((KSResetViewCtl*)resetViewCtl).text_phoneNum.text checkRegister:^(BOOL isRegister,NSError* error) {
            if (isRegister) {
                // 已经注册过则申请发送邀请码
                [strongSelf.validateCodeService sendValidateCodeWithAccountName:((KSResetViewCtl*)resetViewCtl).text_phoneNum.text];
            }else{
                [strongSelf hideLoadingView];
                [strongSelf.resetViewCtl resetSmsCodeButton];
                [WeAppToast toast:HAS_NOT_REGISTER_ACCOUNT_INFO];
            }
        }];
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
        }
        
        [strongSelf.validateCodeCheckService checkValidateCodeWithAccountName:resetViewCtl.text_phoneNum.text validateCode:resetViewCtl.text_smsCode.text];
        
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [KSLoginUtils isNotEmptyString:self.resetViewCtl.text_phoneNum.text] && [KSLoginUtils isNotEmptyString:self.resetViewCtl.text_smsCode.text];
    self.resetViewCtl.btn_nextStep.enabled = loginBtnEnable;
}

@end
