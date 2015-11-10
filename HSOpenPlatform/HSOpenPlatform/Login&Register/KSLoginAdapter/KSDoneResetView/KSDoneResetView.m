//
//  KSDoneResetView.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSDoneResetView.h"
#import "KSLoginUtils.h"

@interface KSDoneResetView()

@property (nonatomic, strong) UILabel                   *doneResetDescriptionLabel;

@end

@implementation KSDoneResetView

-(void)setupView{
    [super setupView];
    [self initResetViewCtl];
    [self reloadData];
}

-(void)initResetViewCtl{
//    self.resetViewCtl.text_renewPwd.hidden = NO;
    self.resetViewCtl.text_newPwd.hidden = NO;
    
    WEAKSELF
    self.resetViewCtl.text_newPwd.textValueDidChanged = ^(UITextField* textView){
        STRONGSELF
        [strongSelf checkNextBtnEnable];
    };
        
    [self addSubview:self.resetViewCtl];
    
    _doneResetDescriptionLabel = [UILabel new];
    _doneResetDescriptionLabel.font = [UIFont systemFontOfSize:11];
    _doneResetDescriptionLabel.textColor = RGB(0x66, 0x66, 0x66);
    _doneResetDescriptionLabel.textAlignment = NSTextAlignmentRight;
    _doneResetDescriptionLabel.text = @"注：请确保输入的密码为6-20位数字或字母组合";
    _doneResetDescriptionLabel.frame = CGRectMake(kSpaceX+10, self.resetViewCtl.text_newPwd.bottom + 12, self.width-2*kSpaceX, 15);
    [self addSubview:_doneResetDescriptionLabel];
}

-(void)reloadData{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _doneResetDescriptionLabel.frame = CGRectMake(kSpaceX+10, self.resetViewCtl.text_newPwd.bottom + 12, self.width-2*kSpaceX, 15);
}

-(void)setService:(KSLoginService *)service{
    if (_service != service) {
        _service = nil;
        _service = service;
        [self setupService];
    }
}

-(KSLoginService *)getService{
    if (_service == nil) {
        _service = [[KSLoginService alloc] init];
        [self setupService];
    }
    return _service;
}

-(void)setupService{
    WEAKSELF
    _service.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        STRONGSELF
        [WeAppToast toast:@"重置密码成功"];
        if (strongSelf.resetPasswordAction) {
            strongSelf.resetPasswordAction(YES);
        }
    };
    
    _service.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
        NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
        [WeAppToast toast:errorInfo];
    };
}

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
    
    _resetViewCtl.nextStepBlock = ^(KSResetViewCtl* resetViewCtl){
        STRONGSELF
        //判断逻辑待完善
        if(![KSLoginUtils isValidMobile:strongSelf.phoneNum])
        {
            [WeAppToast toast:LOGIN_INPUT_ACCOUNTNAME_UNLOGGICAL_INFO];
            return;
        }
        if(strongSelf.smsCode == nil || strongSelf.smsCode.length == 0)
        {
            [WeAppToast toast:LOGIN_INPUT_CHECKCODE_UNLOGGICAL_INFO];
            return;
        }
        if (![KSLoginUtils isValidPassword:resetViewCtl.text_newPwd.text]) {
            [WeAppToast toast:LOGIN_INPUT_PASSWORD_UNLOGGICAL_INFO];
            return;
        }
        /*
         * 去除确认新密码环节
        if (![KSLoginUtils isValidPassword:resetViewCtl.text_renewPwd.text]) {
            [WeAppToast toast:@"请输入正确的确认密码"];
            return;
        }
        if(![resetViewCtl.text_renewPwd.text isEqualToString:resetViewCtl.text_newPwd.text]){
            [WeAppToast toast:@"确认密码与新密码不相符"];
            return;
        }
         */

        [strongSelf.service resetPasswordWithAccountName:strongSelf.phoneNum validateCode:strongSelf.smsCode newPassword:resetViewCtl.text_newPwd.text];
    };
}

#pragma mark - UITextField check next button
-(void)checkNextBtnEnable{
    BOOL loginBtnEnable = [KSLoginUtils isNotEmptyString:self.resetViewCtl.text_newPwd.text];
    self.resetViewCtl.btn_nextStep.enabled = loginBtnEnable;
}

@end
