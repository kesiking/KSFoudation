//
//  EHHomeTabbarViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSHomeTabViewController.h"
#import "HSMessageNavBarRightView.h"
#import "HSHomeBannerView.h"
#import "HSHomeServiceView.h"
#import "HSHomeBusinessView.h"
#import "WeAppLoadingView.h"

#define kHSHomeHeaderViewHeight     (caculateNumber(31.0))

@interface HSHomeTabViewController()<UITableViewDataSource, UITableViewDelegate>
{
}

@property (nonatomic, strong) HSMessageNavBarRightView          *navBarRightView;

@property (nonatomic, strong) UITableView                       *tableView;

@property (nonatomic, strong) WeAppLoadingView                  *refreshPageLoadingView;

@property (nonatomic, strong) HSHomeBannerView                  *homeBannerView;

@property (nonatomic, strong) HSHomeServiceView                 *homeServiceView;

@property (nonatomic, strong) HSHomeBusinessView                *homeBusinessView;

@end

@implementation HSHomeTabViewController
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - init method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.view.backgroundColor = EH_bgcor1;
    [self.view addSubview:self.tableView];
    
    [self initBasicNavBarViews];
}


-(void)initBasicNavBarViews{
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navBarRightView];
    self.rightBarButtonItem = rightBarButtonItem;
}

-(HSMessageNavBarRightView *)navBarRightView{
    if (_navBarRightView == nil) {
        _navBarRightView = [HSMessageNavBarRightView sharedCenter];
        WEAKSELF
        _navBarRightView.buttonClickedBlock = ^(HSMessageNavBarRightView* navBarRightView){
            STRONGSELF
            [strongSelf navBarRightViewDidSelect:navBarRightView];
        };
    }
    return _navBarRightView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseTableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 右键bar 消息响应 messageBtnClicked
-(void)navBarRightViewDidSelect:(HSMessageNavBarRightView*)navBarRightView{
    [self messageBtnClicked:navBarRightView];
}

-(void)messageBtnClicked:(id)sender{
    // goto 消息列表页面
    BOOL isLogin = [KSAuthenticationCenter isLogin];
    if (isLogin) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        TBOpenURLFromTargetWithNativeParams(internalURL(@"HSMyMessageInfoViewController"), self, nil ,params);
    }else{
        [self alertCheckLoginWithCompleteBlock:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = EHCor1;
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:self.homeBannerView];
            break;
        case 1:
            [cell.contentView addSubview:self.homeServiceView];
            break;
        case 2:
            [cell.contentView addSubview:self.homeBusinessView];
            break;
        default:
            break;
    }    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return home_banner_height;
            break;
        case 1:
            return home_serviceView_height;
            break;
        case 2:
            return self.homeBusinessView.height;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return kHSHomeHeaderViewHeight;
            break;
        case 2:
            return kHSHomeHeaderViewHeight;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return caculateNumber(15);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = EH_cor1;
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = EHLinecor1.CGColor;
        layer.frame = CGRectMake(0, 0, tableView.width, 0.5);
        [view.layer addSublayer:layer];
        
        UIImageView *lineImv = [[UIImageView alloc]initWithFrame:CGRectMake(caculateNumber(10), caculateNumber((31-14)/2.0), caculateNumber(3), caculateNumber(14))];
        lineImv.image = [UIImage imageNamed:@"icon_Head_guide"];
        [view addSubview:lineImv];
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(caculateNumber(20), 0, CGRectGetWidth(tableView.frame), kHSHomeHeaderViewHeight)];
        titlelabel.font = EHFont2;
        titlelabel.textColor = EHCor6;
        
        if (section == 1) {
            titlelabel.text = @"服务";
        }
        else if (section == 2) {
            titlelabel.text = @"业务介绍";
        }
        
        [view addSubview:titlelabel];
        return view;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method refreshDataRequest 刷新数据
-(void)refreshDataRequest{
    [self.homeBannerView refreshDataRequest];
    [self.homeBusinessView refreshDataRequest];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableView method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self configPullToRefresh];
    }
    return _tableView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableView config

-(void)configPullToRefresh{
    //刷新逻辑
    if (_tableView && [_tableView isKindOfClass:[UITableView class]]) {
        WEAKSELF
        [_tableView addPullToRefreshWithActionHandler:^{
            STRONGSELF
            
            int64_t delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([strongSelf.tableView showsPullToRefresh]) {
                    //判断是否已经被取消刷新，避免出现crash
                    [strongSelf refreshDataRequest];
                    [strongSelf.tableView.pullToRefreshView stopAnimating];
                }
            });
        }];
        [self configPullToRefreshViewStatus:_tableView];
    }
    
}

-(void)configPullToRefreshViewStatus:(UIScrollView *)scrollView{
    [scrollView.pullToRefreshView setTitle:@"" forState:SVInfiniteScrollingStateAll];
    [scrollView.pullToRefreshView setCustomView:self.refreshPageLoadingView forState:SVInfiniteScrollingStateAll];
    [self.refreshPageLoadingView startAnimating];
}

-(void)releasePullToRefreshView{
    [_tableView setShowsPullToRefresh:NO];
    _tableView.delegate = nil;
    _tableView = nil;
}

-(void)releaseTableView{
    if ([NSThread isMainThread])
    {
        [self releasePullToRefreshView];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self releasePullToRefreshView];
        });
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark loadingView method

-(WeAppLoadingView *)refreshPageLoadingView{
    if (_refreshPageLoadingView == nil) {
        _refreshPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _refreshPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _refreshPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
    }
    return _refreshPageLoadingView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - bannerView method
-(HSHomeBannerView *)homeBannerView{
    if (_homeBannerView == nil) {
        _homeBannerView = [[HSHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, home_banner_height)];
    }
    return _homeBannerView;
}

- (HSHomeServiceView *)homeServiceView {
    if (!_homeServiceView) {
        _homeServiceView = [[HSHomeServiceView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, home_serviceView_height)];
    }
    return _homeServiceView;
}

- (HSHomeBusinessView *)homeBusinessView {
    if (!_homeBusinessView) {
        _homeBusinessView = [[HSHomeBusinessView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, home_businessListCell_height)];
        WEAKSELF
        _homeBusinessView.resetFrameBlock = ^(){
            STRONGSELF
            NSIndexSet * indexSet=[[NSIndexSet alloc]initWithIndex:2];//刷新第二个section
            [strongSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        };
    }
    return _homeBusinessView;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 登录相关操作

-(void)userDidLogin:(NSDictionary*)userInfo{
    [super userDidLogin:userInfo];
}

-(void)userDidLogout:(NSDictionary*)userInfo{
    [super userDidLogout:userInfo];
}

@end
