//
//  KSRegisterViewCtl.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSRegisterViewCtl.h"
#import "KSLoginMaroc.h"

#define register_width  (self.frame.size.width - kSpaceX * 2)
#define view_width      (self.frame.size.width)

#define text_height     (40.0)

@interface KSRegisterViewCtl()<UITextFieldDelegate>

@end

@implementation KSRegisterViewCtl

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

- (UIImageView *)logo_imgView
{
    if(!_logo_imgView)
    {
        _logo_imgView = [[UIImageView alloc]initWithFrame:CGRectMake((view_width - 60)/2, 30, 60, 60)];
        _logo_imgView.backgroundColor = [UIColor redColor];
        [self addSubview:_logo_imgView];
    }
    return _logo_imgView;
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

- (WeAppBasicFieldView *)text_psw
{
    if(!_text_psw)
    {
        _text_psw = [WeAppBasicFieldView getSecurityFieldView];
        _text_psw.textView.placeholder = @"请输入密码";
        [self addSubview:_text_psw];
    }
    return _text_psw;
}

- (WeAppBasicFieldView *)text_inviteCode
{
    if(!_text_inviteCode)
    {
        _text_inviteCode = [WeAppBasicFieldView getCommonFieldView];
        _text_inviteCode.textView.placeholder = @"邀请码";
        [self addSubview:_text_inviteCode];
    }
    return _text_inviteCode;
}

- (WeAppBasicFieldView *)text_userName
{
    if(!_text_userName)
    {
        _text_userName = [WeAppBasicFieldView getCommonFieldView];
        _text_userName.textView.placeholder = @"用户名";
        [self addSubview:_text_userName];
    }
    return _text_userName;
}

- (UIButton *)btn_register
{
    if(!_btn_register)
    {
        _btn_register = [[UIButton alloc]initWithFrame:CGRectMake(kSpaceX, CGRectGetMaxY(_text_psw.frame) + 30, register_width, text_height)];
        _btn_register.layer.cornerRadius = 4;
        _btn_register.layer.masksToBounds = YES;
        [_btn_register setTitle:@"下一步" forState:UIControlStateNormal];
        _btn_register.titleLabel.font = [UIFont systemFontOfSize:16];
        _btn_register.titleLabel.textColor = [UIColor whiteColor];
        [_btn_register setBackgroundColor:[UIColor colorWithRed:0xdc/255.0 green:0x78/255.0 blue:0x68/255.0 alpha:1.0]];
        
        [_btn_register addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_register];
    }
    
    return _btn_register;
}

- (UIButton *)btn_next
{
    if(!_btn_next)
    {
        _btn_next = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_btn_next setTitle:@"下一步" forState:UIControlStateNormal];
        _btn_next.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_btn_next setBackgroundImage:[UIImage imageNamed:@"btn_complete_n"] forState:UIControlStateNormal];
        [_btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_next setTitleColor:UINEXTBUTTON_UNSELECT_COLOR forState:UIControlStateDisabled];
        [_btn_next addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        _btn_next.enabled = NO;
        [self addSubview:_btn_next];
    }
    
    return _btn_next;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _text_phoneNum.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_logo_imgView.frame) + 40, register_width, text_height);
    _text_psw.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_phoneNum.frame) + text_border, register_width, text_height);
    if (_btn_next.superview == self) {
        _btn_next.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_psw.frame) + 65, register_width, text_height);
    }
    _text_inviteCode.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_psw.frame) + text_border, register_width, text_height);
    _text_userName.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_inviteCode.frame) + text_border, register_width, text_height);
    _smsCodeView.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_psw.frame) + text_border, register_width, text_height);
    if (_smsCodeView) {
        _btn_register.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_smsCodeView.frame) + 30, register_width, text_height);
    }
}

- (void)cancelRegister
{
    if (self.cancelRegisterBlock) {
        self.cancelRegisterBlock(self);
    }
}

- (void)registerButtonTapped
{
    if (self.registerBlock) {
        self.registerBlock(self);
    }
}

-(void)nextButtonTapped{
    if (self.nextBlock) {
        self.nextBlock(self);
    }
}

-(void)dealloc{
    self.registerBlock = nil;
    self.cancelRegisterBlock = nil;
}

@end
