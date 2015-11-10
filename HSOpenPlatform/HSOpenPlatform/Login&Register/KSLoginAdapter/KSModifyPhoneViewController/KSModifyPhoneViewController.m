//
//  KSModifyPhoneViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSModifyPhoneViewController.h"
#import "KSModifyPhoneView.h"

@interface KSModifyPhoneViewController ()

@property (nonatomic, strong) KSModifyPhoneView                 *modifyPhoneView;

@property (nonatomic, strong) NSString                          *user_password;

@end

@implementation KSModifyPhoneViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.user_password = [nativeParams objectForKey:@"user_password"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号更改";
    
//    [self.modifyPhoneView.resetViewCtl.btn_nextStep setTitle:@"完成" forState:UIControlStateNormal];
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.modifyPhoneView.resetViewCtl.btn_nextStep];
//    self.modifyPhoneView.resetViewCtl.btn_nextStep.enabled = NO;
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.view addSubview:self.modifyPhoneView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(KSModifyPhoneView *)modifyPhoneView{
    if (_modifyPhoneView == nil) {
        _modifyPhoneView = [[KSModifyPhoneView alloc] initWithFrame:self.view.bounds];
        _modifyPhoneView.user_password = self.user_password;
        WEAKSELF
        _modifyPhoneView.modifyPhoneSuccessAction = ^(BOOL modifyPhoneSuccess){
            STRONGSELF
            if (modifyPhoneSuccess) {
                [KSAuthenticationCenter logoutWithCompleteBolck:^{
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        };
    }
    return _modifyPhoneView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
