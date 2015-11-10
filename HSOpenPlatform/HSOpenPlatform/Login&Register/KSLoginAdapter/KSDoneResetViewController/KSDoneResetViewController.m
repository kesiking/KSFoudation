//
//  KSDoneResetViewController.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSDoneResetViewController.h"
#import "KSDoneResetView.h"

@interface KSDoneResetViewController ()

@property (nonatomic, strong) KSDoneResetView *resetView;

@property (nonatomic, strong) NSString        *smsCode;

@property (nonatomic, strong) NSString        *phoneNum;

@end

@implementation KSDoneResetViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.smsCode = [nativeParams objectForKey:@"smsCode"];
        self.phoneNum = [nativeParams objectForKey:@"phoneNum"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    
    self.resetView.resetViewCtl.btn_nextStep.enabled = NO;

    [self.view addSubview:self.resetView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(KSDoneResetView *)resetView{
    if (_resetView == nil) {
        _resetView = [[KSDoneResetView alloc] initWithFrame:self.view.bounds];
        _resetView.phoneNum = self.phoneNum;
        _resetView.smsCode = self.smsCode;
        WEAKSELF
        _resetView.resetPasswordAction = ^(BOOL resetSuccess){
            STRONGSELF
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _resetView;
}

@end
