//
//  KSMainViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSTabBasicViewController.h"
#import "EHAleatView.h"

#define babyHorizontalListViewHeight (self.view.height)

@interface KSTabBasicViewController ()

@property(nonatomic,assign) BOOL                 isLoginLoading;

@end

@implementation KSTabBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutNotification:) name:kUserLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginNotification:) name:kUserLoginSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIViewController *rdv_tabBarController = self.rdv_tabBarController;
    [rdv_tabBarController setTitle:self.title];
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.titleView = self.titleView;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needLogin  && IOS_VERSION < 8.0) {
        // 查看是否登陆，如果未登陆则跳出登陆
        [self checkLogin];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)measureViewFrame{
    [super measureViewFrame];
    CGRect frame = self.view.frame;
    frame.size.height -= 44;
    if (!CGRectEqualToRect(frame, self.view.frame)) {
        [self.view setFrame:frame];
    }
}

-(void)setNeedLogin:(BOOL)needLogin{
    _needLogin = needLogin;
}

-(UINavigationItem *)navigationItem{
    if (self.rdv_tabBarController.navigationItem) {
        return self.rdv_tabBarController.navigationItem;
    }
    return [super navigationItem];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 检查是否登陆

-(void)alertCheckLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    WEAKSELF
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        EHAleatView* aleatView = [[EHAleatView alloc] initWithTitle:nil message:LOGIN_ALERTVIEW_MESSAGE/*@"增加成员需要登录账号，是否登录已有账号？"*/ clickedButtonAtIndexBlock:^(EHAleatView * alertView, NSUInteger index){
            STRONGSELF
            if (index == 1) {
                [strongSelf doLoginWithCompleteBlock:completeBlock];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aleatView show];
    }else if (completeBlock) {
        completeBlock();
    }
}

-(void)doLoginWithCompleteBlock:(dispatch_block_t)completeBlock{
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        // 如果登陆成功就跳转到当前
        if (completeBlock) {
            completeBlock();
        }
    };
    [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:nil source:self];
}

-(BOOL)checkLogin{
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (!isLogin) {
        [self doLogin];
    }
    return isLogin;
}

-(void)doLogin{
    WEAKSELF
    void(^cancelActionBlock)(void) = ^(void){
        STRONGSELF
        strongSelf.isLoginLoading = NO;
        // 如果当前选中的tab就是我的登陆页面，取消登陆后跳转到上次选中的tab
        if (strongSelf == strongSelf.rdv_tabBarController.selectedViewController) {
            [strongSelf.rdv_tabBarController setSelectedIndex:EHTabBarViewControllerType_Home];
        }
    };
    
    void(^loginActionBlock)(BOOL loginSuccess) = ^(BOOL loginSuccess){
        STRONGSELF
        // 如果登陆成功就跳转到当前
        strongSelf.isLoginLoading = NO;
        [strongSelf.rdv_tabBarController setSelectedViewController:strongSelf];
//        [strongSelf.rdv_tabBarController setSelectedIndex:EHTabBarViewControllerType_Home];
    };
    if (!self.isLoginLoading) {
        self.isLoginLoading = YES;
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:loginActionBlock cancelActionBlock:cancelActionBlock source:self];
        [self performSelector:@selector(changLoginLoading) withObject:nil afterDelay:3.0];
    }
}

-(void)changLoginLoading{
    self.isLoginLoading = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 登陆相关 登录消息

-(void)userDidLoginNotification:(NSNotification*)notification{
    [self userDidLogin:notification.userInfo];
}

-(void)userDidLogoutNotification:(NSNotification*)notification{
    [self userDidLogout:notification.userInfo];
}

-(void)userDidLogin:(NSDictionary*)userInfo{
    
}

-(void)userDidLogout:(NSDictionary*)userInfo{
    
}

#pragma mark- KSTabBarViewControllerProtocol

-(BOOL)shouldSelectViewController:(UIViewController *)viewController{
    // chech login
    if (self.needLogin) {
        return [self checkLogin];
    }
    return YES;
}

// 点击选中
-(void)didSelectViewController:(UIViewController*)viewController{
    
}

// 重复点击选中
-(void)didSelectSameViewController:(UIViewController *)viewController{
    
}

-(CGRect)selectViewControllerRectForBounds:(CGRect)bounds{
    return bounds;
}

@end
