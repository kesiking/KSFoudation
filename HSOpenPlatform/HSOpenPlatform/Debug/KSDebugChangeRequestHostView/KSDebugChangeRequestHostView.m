//
//  KSDebugChangeRequestHostView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/16.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugChangeRequestHostView.h"
#import "KSDebugOperationView.h"
#import "KSDebugUtils.h"
#import "KSDebugRequestHostCenter.h"

@interface KSDebugChangeRequestHostView()<UITextFieldDelegate>

@property(nonatomic, strong)  UILabel               *   infoLabel;

@property(nonatomic, strong)  UITextField           *   originHostDebutTextView;

@property(nonatomic, strong)  UITextField           *   redirectHostDebutTextView;

@property(nonatomic, strong)  UITextField           *   originPortDebutTextView;

@property(nonatomic, strong)  UITextField           *   redirectPortDebutTextView;

@property(nonatomic, strong)  UIButton              *   doneBtn;

@end

@implementation KSDebugChangeRequestHostView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"请求重定向",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)setupView{
    [super setupView];
    [self.originHostDebutTextView setOpaque:YES];
    [self.originPortDebutTextView setOpaque:YES];
    [self.redirectHostDebutTextView setOpaque:YES];
    [self.redirectPortDebutTextView setOpaque:YES];
    [self.doneBtn setOpaque:YES];

    self.needCancelBackgroundAction = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
}

-(UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 20 * 2, 40)];
        [_infoLabel setBackgroundColor:[UIColor blackColor]];
        [_infoLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_infoLabel setTextColor:[UIColor whiteColor]];
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.layer.cornerRadius = 10;
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setText:@"设置请求的host及port"];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

-(UITextField *)originHostDebutTextView{
    if (_originHostDebutTextView == nil) {
        _originHostDebutTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.infoLabel.frame.origin.x, CGRectGetMaxY(self.infoLabel.frame) + 2, self.infoLabel.frame.size.width, 44)];
        _originHostDebutTextView.layer.masksToBounds = YES;
        _originHostDebutTextView.layer.cornerRadius = 10;
        _originHostDebutTextView.placeholder = @"请输入原始host";
        _originHostDebutTextView.text = [[KSDebugRequestHostCenter sharedInstance] orignalHost];
        _originHostDebutTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _originHostDebutTextView.returnKeyType = UIReturnKeyDone;
        //键盘类型
        _originHostDebutTextView.keyboardType = UIKeyboardTypeDefault;
        _originHostDebutTextView.delegate = self;

        [self addSubview:_originHostDebutTextView];
    }
    return _originHostDebutTextView;
}

-(UITextField *)originPortDebutTextView{
    if (_originPortDebutTextView == nil) {
        _originPortDebutTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.originHostDebutTextView.frame.origin.x, CGRectGetMaxY(self.originHostDebutTextView.frame) + 2, self.originHostDebutTextView.frame.size.width, 44)];
        _originPortDebutTextView.layer.masksToBounds = YES;
        _originPortDebutTextView.layer.cornerRadius = 10;
        _originPortDebutTextView.placeholder = @"请输入原始port";
        _originPortDebutTextView.text = [[KSDebugRequestHostCenter sharedInstance] orignalPort];
        _originPortDebutTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _originPortDebutTextView.returnKeyType = UIReturnKeyDone;
        //键盘类型
        _originPortDebutTextView.keyboardType = UIKeyboardTypeDefault;
        _originPortDebutTextView.delegate = self;
        
        [self addSubview:_originPortDebutTextView];
    }
    return _originPortDebutTextView;
}

-(UITextField *)redirectHostDebutTextView{
    if (_redirectHostDebutTextView == nil) {
        _redirectHostDebutTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.originPortDebutTextView.frame.origin.x, CGRectGetMaxY(self.originPortDebutTextView.frame) + 2, self.originPortDebutTextView.frame.size.width, 44)];
        _redirectHostDebutTextView.layer.masksToBounds = YES;
        _redirectHostDebutTextView.layer.cornerRadius = 10;
        _redirectHostDebutTextView.placeholder = @"请输入重定向host";
        _redirectHostDebutTextView.text = [[KSDebugRequestHostCenter sharedInstance] redirectHost];
        _redirectHostDebutTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _redirectHostDebutTextView.returnKeyType = UIReturnKeyDone;
        //键盘类型
        _redirectHostDebutTextView.keyboardType = UIKeyboardTypeDefault;
        _redirectHostDebutTextView.delegate = self;

        [self addSubview:_redirectHostDebutTextView];
    }
    return _redirectHostDebutTextView;
}

-(UITextField *)redirectPortDebutTextView{
    if (_redirectPortDebutTextView == nil) {
        _redirectPortDebutTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.redirectHostDebutTextView.frame.origin.x, CGRectGetMaxY(self.redirectHostDebutTextView.frame) + 2, self.redirectHostDebutTextView.frame.size.width, 44)];
        _redirectPortDebutTextView.layer.masksToBounds = YES;
        _redirectPortDebutTextView.layer.cornerRadius = 10;
        _redirectPortDebutTextView.placeholder = @"请输入重定向port";
        _redirectPortDebutTextView.text = [[KSDebugRequestHostCenter sharedInstance] redirectPort];
        _redirectPortDebutTextView.backgroundColor = [UIColor whiteColor];
        //返回键的类型
        _redirectPortDebutTextView.returnKeyType = UIReturnKeyDone;
        //键盘类型
        _redirectPortDebutTextView.keyboardType = UIKeyboardTypeDefault;
        _redirectPortDebutTextView.delegate = self;
        
        [self addSubview:_redirectPortDebutTextView];
    }
    return _redirectPortDebutTextView;
}

-(UIButton *)doneBtn{
    if (_doneBtn == nil) {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.redirectPortDebutTextView.frame.origin.x, CGRectGetMaxY(self.redirectPortDebutTextView.frame) + 10, self.redirectPortDebutTextView.frame.size.width, 44)];
        
        [_doneBtn setBackgroundColor:KSDebugRGB(0x23, 0x74, 0xfa)];
        [_doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        _doneBtn.layer.cornerRadius = 6;
        _doneBtn.layer.masksToBounds = YES;
        
        [_doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneBtn];
    }
    return _doneBtn;
}

-(void)doneBtnClicked:(id)sender{
    [self.originHostDebutTextView resignFirstResponder];
    [self.originPortDebutTextView resignFirstResponder];
    [self.redirectHostDebutTextView resignFirstResponder];
    [self.redirectPortDebutTextView resignFirstResponder];
    [self setupDebugRequestCenter];
    [self canceBackgroundlAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self setupDebugRequestCenter];
    return YES;
}

-(void)setupDebugRequestCenter{
    if (self.originHostDebutTextView.text && self.originHostDebutTextView.text.length > 0) {
        [[KSDebugRequestHostCenter sharedInstance] setOrignalHost:self.originHostDebutTextView.text];
    }
    if (self.originPortDebutTextView.text && self.originPortDebutTextView.text.length > 0) {
        [[KSDebugRequestHostCenter sharedInstance] setOrignalPort:self.originPortDebutTextView.text];
    }
    if (self.redirectHostDebutTextView.text && self.redirectHostDebutTextView.text.length > 0) {
        [[KSDebugRequestHostCenter sharedInstance] setRedirectHost:self.redirectHostDebutTextView.text];
    }
    if (self.redirectPortDebutTextView.text && self.redirectPortDebutTextView.text.length > 0) {
        [[KSDebugRequestHostCenter sharedInstance] setRedirectPort:self.redirectPortDebutTextView.text];
    }
}

@end
