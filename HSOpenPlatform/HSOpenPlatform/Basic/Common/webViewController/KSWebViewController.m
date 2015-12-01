//
//  KSWebViewController.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/9/19.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSWebViewController.h"
#import "KSModelStatusBasicInfo.h"

@interface KSWebViewController()

@property(nonatomic,strong) NSDate*               pushInViewControllerTime;

@end

@implementation KSWebViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    NSString* url = [nativeParams objectForKey:WEB_REQUEST_URL_ADDRESS_KEY];
    self = [self initWithAddress:url];
    if (self) {
        ;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UINavigationController* navigationController = self.navigationController;
    if([navigationController.navigationBar respondsToSelector:@selector(barTintColor)]){
        navigationController.navigationBar.barTintColor = UINAVIGATIONBAR_COLOR;
    }
    if([navigationController.navigationBar respondsToSelector:@selector(tintColor)]){
        navigationController.navigationBar.tintColor  =  UINAVIGATIONBAR_TITLE_COLOR;
    }
    
    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [[UIImage alloc]init];

    // 修改navbar title颜色
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               UINAVIGATIONBAR_TITLE_COLOR, NSForegroundColorAttributeName,
                                               [UIFont boldSystemFontOfSize:UINAVIGATIONBAR_TITLE_SIZE], NSFontAttributeName,nil];
    
    [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    [self measureViewFrame];
    [self setupView];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewAppeared = NO;
    NSDate* currentDate = [NSDate date];
    NSTimeInterval timerBucket = [currentDate timeIntervalSinceDate:_pushInViewControllerTime];
    EHLogInfo(@"\n ----> leave %@, at time %@ \n user stay in vc for %fs" ,NSStringFromClass([self class]),currentDate, timerBucket);
    [KSTouchEvent endLogPageView:NSStringFromClass([self class])];
}

- (BOOL)needToolbarItems{
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(IMYWebView *)webView {
    [super webViewDidStartLoad:webView];
    [self webViewControllerDidStartLoad:webView];
}


- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    [super webViewDidFinishLoad:webView];
    [self webViewControllerDidFinishLoad:webView];
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
    [super webView:webView didFailLoadWithError:error];
    [self webViewController:webView didFailLoadWithError:error];
}

- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return [self webViewController:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSWebViewController override method
- (BOOL)webViewController:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewControllerDidStartLoad:(IMYWebView *)webView{
    [self showLoadingView];
}

- (void)webViewControllerDidFinishLoad:(IMYWebView *)webView{
    [self hideLoadingView];
}

- (void)webViewController:(IMYWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingView];
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
