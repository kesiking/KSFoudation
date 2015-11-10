//
//  KSRegisterValidateCodeViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/13.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSRegisterValidateCodeViewController.h"
#import "KSRegisterValidateCodeCheckView.h"
#import "KSLoginMaroc.h"

@interface KSRegisterValidateCodeViewController ()

@property (nonatomic,copy) registerActionBlock  registerActionBlock;

@property (nonatomic,copy) cancelActionBlock    cancelActionBlock;

@property (nonatomic, strong) NSString                        *user_phone;

@property (nonatomic, strong) NSString                        *user_password;

@property (nonatomic,strong ) KSRegisterValidateCodeCheckView *registerView;

@end

@implementation KSRegisterValidateCodeViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.registerActionBlock = [nativeParams objectForKey:@"registerActionBlock"];
        self.cancelActionBlock = [nativeParams objectForKey:@"cancelActionBlock"];
        self.user_phone = [nativeParams objectForKey:@"user_phone"];
        self.user_password = [nativeParams objectForKey:@"user_password"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"注册";
    [self.view setBackgroundColor:KSLOGINBackgroundColor];
    
    [self.view addSubview:self.registerView];
    
}

-(KSRegisterValidateCodeCheckView *)registerView{
    if (_registerView == nil) {
        _registerView = [[KSRegisterValidateCodeCheckView alloc] initWithFrame:self.view.bounds];
        _registerView.user_phone = self.user_phone;
        _registerView.user_password = self.user_password;
        WEAKSELF
        _registerView.registerActionBlock = ^(BOOL success){
            STRONGSELF
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            if (strongSelf.registerActionBlock) {
                strongSelf.registerActionBlock(success);
            }
        };
        _registerView.cancelActionBlock = ^(){
            STRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
            if (strongSelf.cancelActionBlock) {
                strongSelf.cancelActionBlock();
            }
        };
    }
    return _registerView;
}

@end
