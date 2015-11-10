//
//  KSModifyPhoneSecurityView.m
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSModifyPhoneSecurityView.h"
#import "KSLoginUtils.h"

@interface KSModifyPhoneSecurityView()

@end

@implementation KSModifyPhoneSecurityView

-(void)setupView{
    [super setupView];
    [self initResetViewCtl];
}

-(void)initResetViewCtl{
    
    self.securityViewCtl.text_newPwd.hidden = NO;
   
    self.securityViewCtl.text_newPwd.textView.placeholder = @"请输入您的登录密码";
    WEAKSELF
    self.securityViewCtl.text_newPwd.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
    
    [self addSubview:self.securityViewCtl];
}

-(void)setSecurityViewCtl:(KSResetViewCtl *)securityViewCtl{
    if (_securityViewCtl != securityViewCtl) {
        _securityViewCtl = nil;
        _securityViewCtl = securityViewCtl;
        [self setupSecurityViewCtl];
    }
}

-(KSResetViewCtl *)getSecurityViewCtl{
    if (_securityViewCtl == nil) {
        _securityViewCtl = [[KSResetViewCtl alloc] initWithFrame:self.bounds];
        [self setupSecurityViewCtl];
    }
    return _securityViewCtl;
}

-(void)setupSecurityViewCtl{
    WEAKSELF
    
    _securityViewCtl.nextStepBlock = ^(KSResetViewCtl* resetViewCtl){
        STRONGSELF
        //判断逻辑待完善
        if (![KSLoginUtils isValidPassword:resetViewCtl.text_newPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        
        NSString* pwd = [[KSLoginComponentItem sharedInstance] getPassword];
        if (![pwd isEqualToString:resetViewCtl.text_newPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNCOLLECT_INFO];
            return;
        }
        
        TBOpenURLFromTargetWithNativeParams(internalURL(kModifyPhonePage), strongSelf, nil , @{@"user_password":resetViewCtl.text_newPwd.text});
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [KSLoginUtils isNotEmptyString:self.securityViewCtl.text_newPwd.text];
    self.securityViewCtl.btn_nextStep.enabled = loginBtnEnable;
}

@end
