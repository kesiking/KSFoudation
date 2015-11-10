//
//  KSRegisterValidateCodeCheckView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/13.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSRegisterValidateCodeCheckView.h"
#import "KSLoginUtils.h"

#define register_width  (self.frame.size.width - kRegisterSpaceX * 2)
#define view_width      (self.frame.size.width)

#define kRegisterSpaceX (15.0)

#define text_height     (40.0)

@implementation KSRegisterValidateCodeCheckView

-(void)setupView{
    [super setupView];
    [self initRegisterViewCtl];
    [self reloadData];
}

-(void)initRegisterViewCtl{
    _validateCodeView = [[KSValidateCodeViewCtl alloc] initWithFrame:self.bounds];
    _validateCodeView.smsCodeLabel.hidden = NO;
    _validateCodeView.text_smsCode.hidden = NO;
    _validateCodeView.btn_smsCode.hidden = NO;
    _validateCodeView.text_smsCode.textView.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    WEAKSELF
    _validateCodeView.getValidateColdBlock = ^(KSValidateCodeViewCtl* resetViewCtl){
        STRONGSELF
        if(![KSLoginUtils isValidMobile:strongSelf.user_phone])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return NO;
        }
        [strongSelf showLoadingView];
        [strongSelf.validateCodeService sendValidateCodeWithAccountName:strongSelf.user_phone];
        return YES;
    };
    
    [_validateCodeView showLoadingSmsCodeButton];
    
    _validateCodeView.text_smsCode.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    
    [self addSubview:_validateCodeView];
    
    _btn_next = [[UIButton alloc] init];
    _btn_next.frame = CGRectMake(kSpaceX, 150, view_width-2*kSpaceX, 40);
    [_btn_next setTitle:@"完成" forState:UIControlStateNormal];
    _btn_next.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_btn_next setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
    [_btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_next setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
    [_btn_next addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _btn_next.enabled = NO;
    [self addSubview:_btn_next];
}

-(void)reloadData{
    
}

-(void)setUser_phone:(NSString *)user_phone{
    _user_phone = user_phone;
    _validateCodeView.smsCodeLabel.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码",user_phone];
    if([KSLoginUtils isValidMobile:user_phone])
    {
        [self.validateCodeService sendValidateCodeWithAccountName:self.user_phone];
    }
}

-(void)nextButtonTapped{
    if(![KSLoginUtils isValidMobile:self.user_phone])
    {
        [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
        return;
    }else if(![KSLoginUtils isValidAuthCode:self.validateCodeView.text_smsCode.text])
    {
        [WeAppToast toast:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO];
        return;
    }
    if(![KSLoginUtils isValidPassword:self.user_password])
    {
        [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
        return;
    }
    
    [self showLoadingView];
    
    [self.validateCodeCheckService checkValidateCodeWithAccountName:self.user_phone validateCode:self.validateCodeView.text_smsCode.text];

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - getValidateCodeService 重新获取验证码
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
        [strongSelf.validateCodeView resetSmsCodeButton];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        [WeAppToast toast:errorInfo];
    };
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - registerService  注册service
-(void)setRegisterService:(KSLoginService *)registerService{
    if (_registerService != registerService) {
        _registerService = nil;
        _registerService = registerService;
        [self setupRegisterService];
    }
}

-(KSLoginService *)getRegisterService{
    if (_registerService == nil) {
        _registerService = [[KSLoginService alloc] init];
        [self setupRegisterService];
    }
    return _registerService;
}

-(void)setupRegisterService{
    WEAKSELF
    _registerService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [strongSelf hideLoadingView];
        [WeAppToast toast:REGISTER_SUCCESS_INFO];
        if (strongSelf.registerActionBlock) {
            strongSelf.registerActionBlock(YES);
        }
    };
    
    _registerService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"]?:REGISTER_FAIL_INFO;
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
         *  @brief  本来应该直接在注册接口中验证验证码等信息，目前接口设计成分为两步，后续可能会修改
         *
         *  @since
         */
        [strongSelf.registerService registerWithAccountName:strongSelf.user_phone password:strongSelf.user_password userName:strongSelf.user_phone validateCode:strongSelf.validateCodeView.text_smsCode.text inviteCode:nil];
    };
    
    _validateCodeCheckService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        NSString* errorInfo = [error.userInfo objectForKey:NSLocalizedDescriptionKey]?:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO;
        [WeAppToast toast:errorInfo];
    };
    
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [KSLoginUtils isNotEmptyString:self.validateCodeView.text_smsCode.text];
    self.btn_next.enabled = loginBtnEnable;
}

@end
