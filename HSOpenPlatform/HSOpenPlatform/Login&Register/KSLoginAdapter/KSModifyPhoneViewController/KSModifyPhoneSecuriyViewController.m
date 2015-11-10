//
//  KSModifyPhoneSecuriyViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/15.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSModifyPhoneSecuriyViewController.h"
#import "KSModifyPhoneSecurityView.h"

@interface KSModifyPhoneSecuriyViewController ()

@property (nonatomic, strong) KSModifyPhoneSecurityView         *modifyPhoneSecurityView;

@end

@implementation KSModifyPhoneSecuriyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号更改";
    
    self.modifyPhoneSecurityView.securityViewCtl.btn_nextStep.enabled = NO;
    
    [self.view addSubview:self.modifyPhoneSecurityView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(KSModifyPhoneSecurityView *)modifyPhoneSecurityView{
    if (_modifyPhoneSecurityView == nil) {
        _modifyPhoneSecurityView = [[KSModifyPhoneSecurityView alloc] initWithFrame:self.view.bounds];
    }
    return _modifyPhoneSecurityView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
