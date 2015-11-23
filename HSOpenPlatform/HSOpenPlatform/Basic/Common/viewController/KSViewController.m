//
//  KSViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-17.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSViewController.h"
#import "KSModelStatusBasicInfo.h"

@interface KSViewController ()

@property(nonatomic,strong) NSDate*               pushInViewControllerTime;

@end

@implementation KSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self measureViewFrame];
    [self setupView];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

-(void)measureViewFrame{
    CGRect frame = self.view.frame;
    frame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds))) + [KSFoundationCommon getAdapterHeight];
    ;
    if (!CGRectEqualToRect(frame, self.view.frame)) {
        [self.view setFrame:frame];
    }
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isViewAppeared = YES;
    _pushInViewControllerTime = [NSDate date];
    EHLogInfo(@"\n ----> come in %@, at time %@",NSStringFromClass([self class]),_pushInViewControllerTime);
    [KSTouchEvent beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewAppeared = NO;
    NSDate* currentDate = [NSDate date];
    NSTimeInterval timerBucket = [currentDate timeIntervalSinceDate:_pushInViewControllerTime];
    EHLogInfo(@"\n ----> leave %@, at time %@ \n ----> user stay in vc for %fs" ,NSStringFromClass([self class]),currentDate, timerBucket);
    [KSTouchEvent endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.view = nil;
}

-(void)dealloc{
    EHLogInfo(@"-----> %@ has called dealloc", NSStringFromClass([self class]));
}

#pragma mark- TBModelStatusHandler

- (TBModelStatusHandler*)statusHandler{
    if (_statusHandler == nil) {
        KSModelStatusBasicInfo *info = [[KSModelStatusBasicInfo alloc] init];
        
        info.titleForErrorBlock=^(NSError*error){
            return @"服务器正忙，请稍微再试";
        };
        info.subTitleForErrorBlock=^(NSError*error){
            return error.userInfo[NSLocalizedDescriptionKey];
        };
        info.actionButtonTitleForErrorBlock=^(NSError*error){
            return @"立刻刷新";
        };
        
        WEAKSELF
        _statusHandler = [[TBModelStatusHandler alloc] initWithStatusInfo:info];
        _statusHandler.selectorForErrorBlock=^(NSError *error){
            STRONGSELF
            [strongSelf refreshDataRequest];
        };
    }
    return _statusHandler;
}

#pragma mark- override by subclass

-(void)refreshDataRequest{
    
}

#pragma mark- used by subclass

-(void)showLoadingView{
    [self.statusHandler showLoadingViewInView:self.view];
}

-(void)showLoadingViewAfterDelay:(NSTimeInterval)delay{
    [self.statusHandler showLoadingViewInView:self.view];
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:delay];
}

-(void)hideLoadingView{
    [self.statusHandler hideLoadingView];
}

-(void)showErrorView:(NSError*)error{
    [self.statusHandler showViewforError:error inView:self.view frame:self.view.bounds];
}

-(void)hideErrorView{
    [self.statusHandler removeStatusViewFromView:self.view];
}

-(void)showEmptyView{
    [self.statusHandler showEmptyViewInView:self.view frame:self.view.frame];
}

-(void)hideEmptyView{
    [self.statusHandler removeStatusViewFromView:self.view];
}

@end
