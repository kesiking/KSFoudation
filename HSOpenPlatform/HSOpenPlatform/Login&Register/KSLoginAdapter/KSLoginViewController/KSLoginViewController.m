//
//  KSLoginViewController.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginViewController.h"
#import "KSLoginView.h"
#import "KSLoginMaroc.h"

@interface KSLoginViewController ()

@property (nonatomic,copy) loginActionBlock  loginActionBlock;

@property (nonatomic,copy) cancelActionBlock cancelActionBlock;

@property (nonatomic,strong) KSLoginView       *loginView;

@property (nonatomic,assign) BOOL               needNavigationBar;

@property (nonatomic,assign) BOOL               quitLoginVC;


@end

@implementation KSLoginViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [self init];
    if (self) {
        self.needNavigationBar = [[query objectForKey:@"needNavigationBar"] boolValue];
        self.loginActionBlock = [nativeParams objectForKey:kLoginSuccessBlock];
        self.cancelActionBlock = [nativeParams objectForKey:kLoginCancelBlock];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNavigationBar];

    [self.view addSubview:self.loginView];
}

-(void)configNavigationBar{
    
    self.title = @"登录";
    
    if (self.needNavigationBar) {
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.loginView.loginViewCtl.btn_register];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
        
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.loginView.loginViewCtl.btn_cancel];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }else{
        CGRect frame = self.view.frame;
        frame.size.height += (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds))) + [KSFoundationCommon getAdapterHeight];
        ;
        if (!CGRectEqualToRect(frame, self.view.frame)) {
            [self.view setFrame:frame];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginView reloadData];
    if (!self.needNavigationBar){
        [self.navigationController setNavigationBarHidden:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.needNavigationBar && !self.quitLoginVC) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(KSLoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[KSLoginView alloc] initWithFrame:self.view.bounds];
        WEAKSELF
        _loginView.loginActionBlock = ^(BOOL success){
            STRONGSELF
            strongSelf.quitLoginVC = YES;
            @try {
                TBBackFromTarget(strongSelf);
                if (strongSelf.loginActionBlock) {
                    strongSelf.loginActionBlock(success);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"----> login crash reason by error : %@",exception.reason);
            }
        };
        _loginView.cancelActionBlock = ^(){
            STRONGSELF
            strongSelf.quitLoginVC = YES;
            @try {
                TBBackFromTarget(strongSelf);
                if (strongSelf.cancelActionBlock) {
                    strongSelf.cancelActionBlock();
                }
            }
            @catch (NSException *exception) {
                NSLog(@"----> login crash reason by error : %@",exception.reason);
            }
        };
    }
    return _loginView;
}

@end
