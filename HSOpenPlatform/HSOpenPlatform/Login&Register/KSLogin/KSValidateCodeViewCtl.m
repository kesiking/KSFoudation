//
//  KSValidateCodeViewCtl.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/9.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSValidateCodeViewCtl.h"
#import "KSLoginMaroc.h"

@interface KSValidateCodeViewCtl(){
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UIColor               *defaultSmsCodeBtnColor;

@property (nonatomic, strong) UIColor               *selectSmsCodeBtnColor;

@end

@implementation KSValidateCodeViewCtl
@synthesize smsCodeLabel = _smsCodeLabel;
@synthesize text_smsCode = _text_smsCode;
@synthesize btn_smsCode = _btn_smsCode;
@synthesize smsCodeView = _smsCodeView;


-(instancetype)init{
    self = [super init];
    if (self) {
        self.defaultSmsCodeBtnColor = UILOGINNAVIGATIONBAR_COLOR;
        self.selectSmsCodeBtnColor = UILOGINBUTTON_UNSELECT_COLOR;
        self.smsCodeSeconds = 60;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultSmsCodeBtnColor = UILOGINNAVIGATIONBAR_COLOR;
        self.selectSmsCodeBtnColor = UILOGINBUTTON_UNSELECT_COLOR;
        self.smsCodeSeconds = 60;
    }
    return self;
}

-(UILabel *)smsCodeLabel{
    if (!_smsCodeLabel) {
        _smsCodeLabel = [UILabel new];
        _smsCodeLabel.font = [UIFont systemFontOfSize:11];
        [_smsCodeLabel setTextColor:[UIColor colorWithWhite:0x66/255.0 alpha:1]];
        _smsCodeLabel.frame = CGRectMake(kValidateCodeSpaceX, 10, validate_width, text_height);
        [self addSubview:_smsCodeLabel];
    }
    return _smsCodeLabel;
}

-(WeAppBasicFieldView *)text_smsCode{
    if (!_text_smsCode) {
        _text_smsCode = [WeAppBasicFieldView getCommonFieldView];
        _text_smsCode.textView.borderStyle = UITextBorderStyleRoundedRect;
        _text_smsCode.frame = CGRectMake(_smsCodeLabel.frame.origin.x, CGRectGetMaxY(_smsCodeLabel.frame) + text_border, text_smsCode_width, text_height);
        _text_smsCode.textView.placeholder = @"请输入验证码";
        [_text_smsCode setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_text_smsCode];
    }
    return _text_smsCode;
}

-(UIButton *)btn_smsCode{
    if (!_btn_smsCode) {
     _btn_smsCode = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 20 - btn_smsCode_width, CGRectGetMinY(_text_smsCode.frame), btn_smsCode_width, _text_smsCode.frame.size.height)];
        
        
        _btn_smsCode.layer.cornerRadius = 3;
        _btn_smsCode.layer.masksToBounds = YES;
        [_btn_smsCode.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_btn_smsCode setTitle:@"验证码" forState:UIControlStateNormal];
//        [_btn_smsCode setBackgroundColor:self.defaultSmsCodeBtnColor];
        [_btn_smsCode setBackgroundColor:KSLOGINCor19];

        [_btn_smsCode addTarget:self action:@selector(getValidateCode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_smsCode];
    }
    return _btn_smsCode;
}

- (UIView *)smsCodeView
{
    if(!_smsCodeView)
    {
        _smsCodeView = [[UIView alloc]initWithFrame:CGRectMake(_smsCodeLabel.frame.origin.x, CGRectGetMaxY(_smsCodeLabel.frame) + text_border, validate_width, text_height)];
        _smsCodeView.backgroundColor = [UIColor clearColor];
    }
    
    return _smsCodeView;
}

- (void)getValidateCode
{
    //判断逻辑待完善
    BOOL canGetValidateCode = NO;
    
    if (self.getValidateColdBlock) {
        canGetValidateCode = self.getValidateColdBlock(self);
    }
    
    if (!canGetValidateCode) {
        return;
    }
    if (self.smsCodeSeconds > 0) {
        [self showSecondTimeout:self.smsCodeSeconds target:self timerOutAction:@selector(updateUIWhenSecondTimeout:)];
    }
}

-(void)dealloc{
    self.getValidateColdBlock = nil;
    [self resetTimer];
}

#pragma mark - helper functions
- (void)updateUIWhenSecondTimeout:(NSDictionary*)userinfo
{
    BOOL bEnd = [[userinfo objectForKey:@"timerend"] boolValue];
    if (bEnd)
    {
        _btn_smsCode.enabled = YES;
        //设置界面的按钮显示
        [_btn_smsCode setBackgroundColor:EHCor20];
        [_btn_smsCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_smsCode setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    else
    {
        NSUInteger remainTime = [[userinfo objectForKey:@"remaintime"] unsignedIntegerValue];
        NSString *strTime = [NSString stringWithFormat:@"%lus",(unsigned long)remainTime];
        
        _btn_smsCode.enabled = NO;
        //设置界面的按钮显示
//        [_btn_smsCode setBackgroundColor:self.selectSmsCodeBtnColor];
//        [_btn_smsCode setTitleColor:[UIColor colorWithWhite:0x99/255.0 alpha:1] forState:UIControlStateNormal];
        [_btn_smsCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_btn_smsCode setBackgroundColor:KSLOGINCor20];
        [_btn_smsCode setTitle:strTime forState:UIControlStateDisabled];
    }
}

- (void)showSecondTimeout:(NSUInteger)time target:(id)target timerOutAction:(SEL)action
{
    __block NSUInteger timeout= time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:[NSNumber numberWithBool:YES] forKey:@"timerend"];
                [target performSelector:action withObject:userInfo];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:[NSNumber numberWithBool:NO] forKey:@"timerend"];
                [userInfo setObject:[NSNumber numberWithUnsignedInteger:timeout] forKey:@"remaintime"];
                [target performSelector:action withObject:userInfo];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(void)resetTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

-(void)resetSmsCodeButton{
    [self resetTimer];
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGSELF
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithBool:YES] forKey:@"timerend"];
        [strongSelf updateUIWhenSecondTimeout:userInfo];
    });
}

-(void)showLoadingSmsCodeButton{
    if (self.smsCodeSeconds > 0) {
        [self showSecondTimeout:self.smsCodeSeconds target:self timerOutAction:@selector(updateUIWhenSecondTimeout:)];
    }
}

@end
