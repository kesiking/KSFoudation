//
//  KSLoginViewCtl.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginViewCtl.h"
#import "KSLoginMaroc.h"
#import "KSLoginUtils.h"

#define kLoginSpaceX  (0.0)

#define login_width (self.frame.size.width - kSpaceX * 2)
#define view_width  (self.frame.size.width)

#define text_label_width ((43.0))

#define text_height     (49.0)
#define text_border     (0.0)

#define login_button_space_x    (70.0)
#define login_button_width      (self.frame.size.width - login_button_space_x * 2)
#define login_button_height     (44.0)

#define account_label_description  @"账户"
#define password_label_description @"登陆密码"

//#define needCheckLoginWithPhoneNumAndPassword

@interface KSLoginViewCtl()<UITextFieldDelegate>

@end

@implementation KSLoginViewCtl

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

-(UIButton *)btn_register{
    if (!_btn_register) {
        _btn_register = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_register.frame = CGRectMake(view_width - 50, 25, 80, 34);
        _btn_register.titleLabel.textAlignment = NSTextAlignmentRight;
        _btn_register.layer.cornerRadius = 2;
        _btn_register.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn_register.clipsToBounds = YES;
        _btn_register.userInteractionEnabled = YES;
        [_btn_register setTitle:@"用户注册" forState:UIControlStateNormal];
        [_btn_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_register addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_register];
    }
    return _btn_register;
}

-(UIButton *)btn_cancel{
    if (!_btn_cancel) {
        _btn_cancel = [UIButton new];
        _btn_cancel.frame = CGRectMake(10, 25, 195, 33);
        _btn_cancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _btn_cancel.layer.cornerRadius = _btn_cancel.height/2;
        _btn_cancel.layer.borderWidth = 1.0;
        _btn_cancel.layer.borderColor = [UIColor whiteColor].CGColor;
        _btn_cancel.clipsToBounds = YES;
        _btn_cancel.userInteractionEnabled = YES;
        [_btn_cancel setTitle:@"试用体验" forState:UIControlStateNormal];
        [_btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_cancel addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_cancel];
    }
    return _btn_cancel;
}

- (UIImageView *)logo_imgView
{
    if(!_logo_imgView)
    {
        _logo_imgView = [[UIImageView alloc]initWithFrame:CGRectMake((view_width - 147)/2, 30, 147, 147)];
//        _logo_imgView.image = [UIImage imageNamed:@"ico_login_logo"];
        _logo_imgView.opaque = YES;
        [self addSubview:_logo_imgView];
    }
    return _logo_imgView;
}

- (UIImageView *)description_logo_imgView
{
    if(!_description_logo_imgView)
    {
        _description_logo_imgView = [[UIImageView alloc]initWithFrame:CGRectMake((view_width - 88)/2, _logo_imgView.bottom + 5, 88, 25)];
//        _description_logo_imgView.image = [UIImage imageNamed:@"writing_login"];
        _description_logo_imgView.opaque = YES;
        [self addSubview:_description_logo_imgView];
    }
    return _description_logo_imgView;
}

- (WeAppBasicFieldView *)text_phoneNum
{
    if(!_text_phoneNum)
    {
        _text_phoneNum = [WeAppBasicFieldView getCommonFieldView];
        _text_phoneNum.textView.placeholder = @"输入用户名";
        _text_phoneNum.textView.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _text_phoneNum.textView.colorWhileEditing = nil;
        [_text_phoneNum.backgroundImage setImage:[UIImage imageNamed:@"btn_input"]];
        /*
         * placeholder颜色
        [_text_phoneNum.textView setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
         */
        [_text_phoneNum.textView setTextColor:[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1]];
        _text_phoneNum.textView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _text_phoneNum.aDelegate = self;
        WEAKSELF
        _text_phoneNum.textValueDidChanged = ^(UITextField *textField){
            STRONGSELF
            [strongSelf setupLeftViewWithTextField:textField];
            // check login
            /*
             * 登录按钮有效性验证
             */
            [strongSelf checkLoginBtnEnable];
        };
        [self addSubview:_text_phoneNum];
        
        UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, text_label_width, _text_phoneNum.height)];
        /*
        UILabel *account_label = [[UILabel alloc] initWithFrame:leftView.bounds];
        account_label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        account_label.textAlignment = NSTextAlignmentLeft;
        account_label.textColor = [UIColor whiteColor];
        account_label.text = account_label_description;
        account_label.font = [UIFont boldSystemFontOfSize:16];
        account_label.tag = 1003;
        [leftView addSubview:account_label];
         */
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.frame.size.width - 20)/2, (leftView.frame.size.height - 20)/2, 20, 20)];
        imageView.tag = 1001;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [imageView setImage:[UIImage imageNamed:@"icon_user"]];
        [leftView addSubview:imageView];

        /*
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 0.5, CGRectGetMinY(leftView.frame) + 0.5, 0.5, CGRectGetMaxY(leftView.frame) - 0.5)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.tag = 1002;
        line.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [leftView addSubview:line];
         */
        
        _text_phoneNum.textView.leftView = leftView;
        _text_phoneNum.textView.leftViewMode = UITextFieldViewModeAlways;
    }
    return _text_phoneNum;
}

- (WeAppBasicFieldView *)text_psw
{
    if(!_text_psw)
    {
        _text_psw = [WeAppBasicFieldView getSecurityFieldView];
        _text_psw.textView.placeholder = @"输入密码";
        _text_psw.textView.rightNormalImage = [UIImage imageNamed:@"ico_input_password_normal"];
        _text_psw.textView.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _text_psw.textView.colorWhileEditing = nil;
        [_text_psw.backgroundImage setImage:[UIImage imageNamed:@"btn_input"]];
//        [_text_psw.textView setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_text_psw.textView setTextColor:[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1]];
        _text_psw.textView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _text_psw.aDelegate = self;
        WEAKSELF
        _text_psw.textValueDidChanged = ^(UITextField *textField){
            STRONGSELF
            [strongSelf setupLeftViewWithTextField:textField];
            // check login
            /*
             * 登录按钮有效性验证
             */
            [strongSelf checkLoginBtnEnable];
        };
        [self addSubview:_text_psw];
        
        UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, text_label_width, _text_psw.height)];
        /*
        UILabel *password_label = [[UILabel alloc] initWithFrame:leftView.bounds];
        password_label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        password_label.textAlignment = NSTextAlignmentLeft;
        password_label.textColor = [UIColor whiteColor];
        password_label.text = password_label_description;
        password_label.font = [UIFont boldSystemFontOfSize:16];
        password_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        password_label.tag = 1003;
        [leftView addSubview:password_label];
         */
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.frame.size.width - 20)/2, (leftView.frame.size.height - 20)/2, 20, 20)];
        imageView.tag = 1001;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"icon_password"];
        [leftView addSubview:imageView];

        /*
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 0.5, CGRectGetMinY(leftView.frame) + 0.5, 0.5, CGRectGetMaxY(leftView.frame) - 0.5)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.tag = 1002;
        line.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [leftView addSubview:line];
         */
        
        _text_psw.textView.leftView = leftView;
        _text_psw.textView.leftViewMode = UITextFieldViewModeAlways;
    }
    return _text_psw;
}

- (UIButton *)btn_forgetPwd
{
    if(!_btn_forgetPwd)
    {
        _btn_forgetPwd = [[UIButton alloc]initWithFrame:CGRectMake(view_width-kSpaceX-80, CGRectGetMaxY(_text_psw.frame) + 15, 80, 15)];
        [_btn_forgetPwd setTitle:@"|    忘记密码" forState:UIControlStateNormal];
        [_btn_forgetPwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_forgetPwd setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [_btn_forgetPwd.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _btn_forgetPwd.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btn_forgetPwd addTarget:self action:@selector(doResetPwd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_forgetPwd];
    }
    
    return _btn_forgetPwd;
}

- (UIButton *)btn_login
{
    if(!_btn_login)
    {
        _btn_login = [[UIButton alloc]initWithFrame:CGRectMake(kSpaceX, CGRectGetMaxY(_btn_forgetPwd.frame) + 20, login_width, text_height)];
        [_btn_login setBackgroundImage:[UIImage imageNamed:@"btn_login_n"] forState:UIControlStateNormal];
        [_btn_login setBackgroundImage:[UIImage imageNamed:@"btn_login_h"] forState:UIControlStateDisabled];
        [_btn_login setTitle:@"登录" forState:UIControlStateNormal];
        [_btn_login.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        _btn_login.titleLabel.textColor = [UIColor whiteColor];
        [_btn_login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        _btn_login.enabled = NO;
        [self addSubview:_btn_login];
    }
    
    return _btn_login;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _logo_imgView.frame = CGRectMake((view_width - caculateHeightNumber(147))/2, caculateHeightNumber(30), caculateHeightNumber(147), caculateHeightNumber(147));
    _description_logo_imgView.frame = CGRectMake((view_width - 88)/2, CGRectGetMaxY(_logo_imgView.frame) + 5, 88, 25);
    _text_phoneNum.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_description_logo_imgView.frame) + caculateHeightNumber(40), login_width, caculateNumber(text_height));
    _text_psw.frame = CGRectMake(kSpaceX, CGRectGetMaxY(_text_phoneNum.frame) + 15, login_width, caculateNumber(text_height));
    _btn_login.frame = CGRectMake(login_button_space_x, CGRectGetMaxY(_text_psw.frame) + 35, login_button_width, login_button_height);
    _btn_register.frame = CGRectMake((view_width - 80 - 80 - 10)/2, CGRectGetMaxY(_btn_login.frame) + 20, 80, 15);
    _btn_forgetPwd.frame = CGRectMake(CGRectGetMaxX(_btn_register.frame), CGRectGetMaxY(_btn_login.frame) + 20, 80, 15);
    _btn_cancel.frame = CGRectMake((view_width - 195)/2, self.height - _btn_cancel.height - caculateHeightNumber(35), 195, _btn_cancel.height);
}

#pragma mark - UITextField check login button
-(void)checkLoginBtnEnable{
#ifdef needCheckLoginWithPhoneNumAndPassword
    BOOL loginBtnEnable = [EHUtils isValidMobile:self.text_phoneNum.textView.text] && [EHUtils isValidPassword:self.text_psw.textView.text];
#else
    BOOL loginBtnEnable = YES;
#endif
    self.btn_login.enabled = loginBtnEnable;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self setupLeftViewWithTextField:textField];
}

-(void)setupLeftViewWithTextField:(UITextField*)textField{
    if (textField.text.length > 0) {
        UIView *leftView = textField.leftView;
        UILabel* label = (UILabel*)[leftView viewWithTag:1003];
        if (label) {
            label.textColor = [UIColor colorWithRed:0xff/255.0 green:0xe8/255.0 blue:0x66/255.0 alpha:1];
        }
        // 修改line颜色
        UIView* line = [leftView viewWithTag:1002];
        if (line) {
            line.backgroundColor = [UIColor colorWithRed:0xff/255.0 green:0xe8/255.0 blue:0x66/255.0 alpha:1];
        }
        // 修改imageView展示
        UIImageView* imageView = (UIImageView*)[leftView viewWithTag:1001];
        if (imageView) {
            if (textField == self.text_psw.textView) {
                [imageView setImage:[UIImage imageNamed:@"icon_password"]];
            }else{
                [imageView setImage:[UIImage imageNamed:@"icon_user"]];
            }
        }
    }else{
        UIView *leftView = textField.leftView;
        UILabel* label = (UILabel*)[leftView viewWithTag:1003];
        if (label) {
            label.textColor = [UIColor whiteColor];
        }
        UIView* line = [leftView viewWithTag:1002];
        if (line) {
            line.backgroundColor = [UIColor whiteColor];
        }
        UIImageView* imageView = (UIImageView*)[leftView viewWithTag:1001];
        if (imageView) {
            if (textField == self.text_psw.textView) {
                imageView.image = [UIImage imageNamed:@"icon_password"];
            }else{
                [imageView setImage:[UIImage imageNamed:@"icon_user"]];
            }
        }
    }
}

#pragma mark - action method block callback
- (void)login
{
    if (self.loginBlock) {
        self.loginBlock(self);
    }
}

- (void)doRegister
{
    if (self.registerBlock) {
        self.registerBlock(self);
    }
}

- (void)doResetPwd
{
    if (self.resetPwdBlock) {
        self.resetPwdBlock(self);
    }
}

- (void)cancelLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginCancelNotification object:nil userInfo:nil];
    if (self.cancelLoginBlock) {
        self.cancelLoginBlock(self);
    }
}

-(void)dealloc{
    self.loginBlock = nil;
    self.resetPwdBlock = nil;
    self.registerBlock = nil;
    self.cancelLoginBlock = nil;
}

@end
