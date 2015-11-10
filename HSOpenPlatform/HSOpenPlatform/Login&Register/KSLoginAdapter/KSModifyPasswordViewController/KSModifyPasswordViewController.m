//
//  KSModifyPasswordViewController.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/10.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSModifyPasswordViewController.h"
#import "KSModifyPasswordView.h"
#import "KSLoginComponentItem.h"

@interface KSModifyPasswordViewController ()

@property (nonatomic, strong) KSModifyPasswordView  *modifyPasswordView;

@property (nonatomic, strong) NSString              *user_phone;

@end

@implementation KSModifyPasswordViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.user_phone = [nativeParams objectForKey:@"user_phone"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更改密码";
    [self.view addSubview:self.modifyPasswordView];
    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.modifyPasswordView.resetViewCtl.btn_nextStep];
//    self.modifyPasswordView.resetViewCtl.btn_nextStep.enabled = NO;
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(KSModifyPasswordView *)modifyPasswordView{
    if (_modifyPasswordView == nil) {
        _modifyPasswordView = [[KSModifyPasswordView alloc] initWithFrame:self.view.bounds];
        _modifyPasswordView.user_phone = self.user_phone?:[KSLoginComponentItem sharedInstance].user_phone;
        WEAKSELF
        _modifyPasswordView.modifyPasswordAction = ^(BOOL resetSuccess){
            STRONGSELF
            [KSAuthenticationCenter logoutWithCompleteBolck:^{
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        };
    }
    return _modifyPasswordView;
}

@end
