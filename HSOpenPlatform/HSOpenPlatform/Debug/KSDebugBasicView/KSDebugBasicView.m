//
//  WeAppDebugBasicView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugBasicView.h"

@interface KSDebugBasicView()

@property(nonatomic, strong)  UIButton*   cancelButton;

@end

@implementation KSDebugBasicView
@synthesize debugEnviromeng = _debugEnviromeng;
@synthesize debugViewReference = _debugViewReference;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)dealloc{
    
}

-(void)setupView{
    self.needCancelBackgroundAction = YES;
    self.cancelButton.hidden = YES;
}

-(UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 110, CGRectGetMaxY(self.frame) - 50, 100, 40)];
        _closeButton.backgroundColor = [UIColor whiteColor];
        _closeButton.layer.masksToBounds = YES;
        _closeButton.layer.cornerRadius = 10;
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:self.bounds];
        _cancelButton.backgroundColor = [UIColor blackColor];
        _cancelButton.hidden = YES;
        _cancelButton.alpha = 0.3;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(void)cancelButtonClick:(id)sender{
    [self canceBackgroundlAction];
}

-(void)showBackgroundAction{
    if (self.needCancelBackgroundAction) {
        self.cancelButton.hidden = NO;
    }
}

-(void)canceBackgroundlAction{
    if (self.needCancelBackgroundAction) {
        self.cancelButton.hidden = YES;
    }
    [self endDebug];
    if ([self shouldNotificationDidClosedMessage]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KSDebugBasicViewDidClosedNotification object:self userInfo:@{}];
    }
}

-(void)closeButtonClick:(id)sender{
    [self closeButtonDidSelect];
    [self endDebug];
    if ([self shouldNotificationDidClosedMessage]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KSDebugBasicViewDidClosedNotification object:self userInfo:@{}];
    }
}

-(void)closeButtonDidSelect{
    
}

-(BOOL)shouldNotificationDidClosedMessage{
    return YES;
}

-(void)startDebug{
    self.isDebuging = YES;
    [self showBackgroundAction];
}

-(void)endDebug{
    self.isDebuging = NO;
}

@end
