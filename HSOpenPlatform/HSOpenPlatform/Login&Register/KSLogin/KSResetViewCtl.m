//
//  KSResetViewCtl.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSResetViewCtl.h"
#import "KSLoginMaroc.h"

#define reset_width     (self.frame.size.width - kResetSpaceX * 2)
#define kResetSpaceX    (25.0)

@interface KSResetViewCtl()<UITextFieldDelegate>

@end

@implementation KSResetViewCtl

-(id)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
}

-(WeAppBasicFieldView *)text_oldPwd{
    if(!_text_oldPwd)
    {
        _text_oldPwd = [WeAppBasicFieldView getSecurityFieldView];
        _text_oldPwd.textView.placeholder = @"请输入原始密码";
        [self addSubview:_text_oldPwd];
    }
    return _text_oldPwd;
}

- (WeAppBasicFieldView *)text_newPwd
{
    if(!_text_newPwd)
    {
        _text_newPwd = [WeAppBasicFieldView getSecurityFieldView];
        _text_newPwd.textView.placeholder = @"请输入新密码";
        [self addSubview:_text_newPwd];
    }
    return _text_newPwd;
}

- (WeAppBasicFieldView *)text_renewPwd
{
    if(!_text_renewPwd)
    {
        _text_renewPwd = [WeAppBasicFieldView getSecurityFieldView];;
        _text_renewPwd.textView.placeholder = @"确认新密码";
        [self addSubview:_text_renewPwd];
    }
    return _text_renewPwd;
}

- (UIButton *)btn_done
{
    if(!_btn_done)
    {
        _btn_done = [[UIButton alloc]initWithFrame:CGRectMake(kResetSpaceX, CGRectGetMaxY(_text_renewPwd.frame) + 30, reset_width, text_height)];
        _btn_done.layer.cornerRadius = 5;
        _btn_done.layer.masksToBounds = YES;
        [_btn_done setTitle:@"完成" forState:UIControlStateNormal];
        [_btn_done.titleLabel setFont:[UIFont systemFontOfSize:18]];
        _btn_done.titleLabel.textColor = [UIColor whiteColor];
        [_btn_done setBackgroundColor:UILOGINNAVIGATIONBAR_COLOR];
        [_btn_done addTarget:self action:@selector(resetPwdDone) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_done];
    }
    
    return _btn_done;
}

- (WeAppBasicFieldView *)text_phoneNum
{
    if(!_text_phoneNum)
    {
        _text_phoneNum = [WeAppBasicFieldView getCommonFieldView];
        _text_phoneNum.textView.placeholder = @"请输入手机号码";
        [self addSubview:_text_phoneNum];
    }
    return _text_phoneNum;
}

- (UIButton *)btn_nextStep
{
    if(!_btn_nextStep)
    {
        _btn_nextStep = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_btn_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
        [_btn_nextStep.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btn_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_nextStep setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_btn_nextStep setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
        [_btn_nextStep addTarget:self action:@selector(doNextStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_nextStep];
    }
    
    return _btn_nextStep;
}

- (UIButton *)btn_finish
{
    if(!_btn_finish)
    {
        _btn_finish = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_finish setTitle:@"完成" forState:UIControlStateNormal];
        [_btn_finish.layer setMasksToBounds:YES];
        [_btn_finish.layer setCornerRadius:7.0]; //设置矩形四个圆角半径

        [_btn_finish.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btn_finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_finish setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_btn_finish setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
        _btn_finish.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_finish addTarget:self action:@selector(doNextStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_finish];
    }
    
    return _btn_finish;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    _text_oldPwd.frame = CGRectMake(kResetSpaceX, 40, reset_width, text_height);
    if (_text_oldPwd) {
        _text_newPwd.frame = CGRectMake(kResetSpaceX, CGRectGetMaxY(_text_oldPwd.frame) + text_border, reset_width, text_height);
    }else{
        _text_newPwd.frame = CGRectMake(kResetSpaceX, 40, reset_width, text_height);
    }
    _text_renewPwd.frame = CGRectMake(kResetSpaceX, CGRectGetMaxY(_text_newPwd.frame) + text_border, reset_width, text_height);
    if (_text_renewPwd) {
        _btn_done.frame = CGRectMake(kResetSpaceX, CGRectGetMaxY(_text_renewPwd.frame) + 30, reset_width, text_height);
    }else{
        _btn_done.frame = CGRectMake(kResetSpaceX, CGRectGetMaxY(_text_newPwd.frame) + 30, reset_width, text_height);
    }
    
    _text_phoneNum.frame = CGRectMake(kResetSpaceX, 40, 222*SCREEN_SCALE , text_height);
    
    [_text_smsCode setFrame:CGRectMake(_text_phoneNum.left, _text_phoneNum.bottom + 8,self.frame.size.width-50, _text_smsCode.height)];
    
    [_btn_smsCode setFrame:CGRectMake(222*SCREEN_SCALE+35, 40,self.frame.size.width - 60 - (222*(SCREEN_SCALE)), _btn_smsCode.height)];
    
    [_btn_finish setFrame:CGRectMake(25, 170,  (self.frame.size.width - 50), text_height)];
    
    if (_text_smsCode) {
        [_btn_nextStep setFrame:CGRectMake(_text_smsCode.left, _text_smsCode.bottom+40, _text_smsCode.width, 40)];
    }else if(_text_newPwd)
    {
        [_btn_nextStep setFrame:CGRectMake(_text_newPwd.left, _text_newPwd.bottom+60, _text_newPwd.width, 40)];
    }
    
}

- (void)doNextStep
{
    _btn_finish.backgroundColor = EHCor21;
    //判断逻辑待完善
    if (self.nextStepBlock) {
        self.nextStepBlock(self);
    }
}

- (void)resetPwdDone
{
    if (self.resetPwdDoneBlock) {
        self.resetPwdDoneBlock(self);
    }
}

-(void)dealloc{
    self.nextStepBlock = nil;
    self.resetPwdDoneBlock = nil;
}

@end
