//
//  EHMyInfoTabbarViewController.m
//  eHome
//
//  Created by 孟希羲 on 15/6/4.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSMyInfoTabViewController.h"
#import "HSPageViewControllerDemo.h"
#import "HSHomeAccountInfoView.h"
#import "HSMyInfoHeaderView.h"
#import "HSMessageNavBarRightView.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSDeviceCollectionView.h"
#import "MJRefresh.h"
#import "WeAppLoadingView.h"
#import "HSMyInfoAppCollectionViewCell.h"
#import "HSDeviceModel.h"


@interface HSMyInfoTabViewController()<UITableViewDataSource, UITableViewDelegate>

@property HSPageViewControllerDemo *pageViewDemo;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) HSMyInfoHeaderView *headerView;

@property (nonatomic, strong) HSHomeAccountInfoView  *homeAccountInfoView;

@property (nonatomic, strong) HSDeviceCollectionView *deviceCollectionView;

@property (nonatomic, assign) CGFloat collectionViewheight;

@property (nonatomic, strong) NSString *loadFailTitle;

@property (nonatomic, strong) WeAppLoadingView *refreshPageLoadingView;


//@property (nonatomic, strong) HSMessageNavBarRightView          *navBarRightView;


@end

@implementation HSMyInfoTabViewController
{
    NSArray *_myInfoSettingConfigList;

}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.needLogin = YES;
    self.title = @"我的";
//    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicke:)];
//    self.rightBarButtonItem = rightBarButtonItem;
//    [self initBasicNavBarViews];
    
    [self initMyInfoSettingItemList];
    [self deviceCollectionView];
    [self.view addSubview:self.tableView];
//    [self.tableView reloadData];
    self.emptyDataTitle     = @"暂无数据";
    self.loadFailTitle      = @"下拉刷新";
    [self setRefreshHeaderOnTableView:self.tableView];
    [self.tableView.header beginRefreshing];
    [self setLoadMoreFooterOnTableView:self.tableView];

}

- (void)refreshData {
    [self.deviceCollectionView refreshDataRequest];
}

- (void)reloadFail {
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
        if (self.deviceCollectionView.dataArray.count == 0) {
            //为空数据时加载失败添加提示
            [(MJRefreshAutoNormalFooter *)self.tableView.footer setTitle:self.loadFailTitle forState:MJRefreshStateNoMoreData];
        }
    }
}


- (void)initMyInfoSettingItemList
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MyInfoSettingItemList" ofType:@"plist"];
    _myInfoSettingConfigList = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.headerView.userPhoneNumber = [KSAuthenticationCenter userPhone];
//    self.headerView.userPackage = [KSLoginComponentItem sharedInstance].userPackage;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - clickedSetting
-(void)rightBarButtonClicke:(id)sender{
    TBOpenURLFromTargetWithNativeParams(internalURL(@"EHMyInfoViewController"), self, nil,nil);
//    TBOpenURLFromTargetWithNativeParams(internalURL(@"HSAboutViewController"), self, nil,nil);
//    [EHSocialShareHandle presentWithTypeArray:@[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToSms,EHShareToQRCode] Title:[NSString stringWithFormat:@"%@ %@",kHS_APP_RECOMMENT_TEXT,kHS_WEBSITE_URL] Image:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME] presentedController:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
    /*!
     注释我的消息逻辑，第一期不支持我的消息功能
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 3;
            break;
//        case 3:
//            return 3;
//            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = EHCor1;
    cell.textLabel.font = EHFont2;
    cell.textLabel.textColor = EHCor5;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    NSDictionary *dict;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.headerView];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            NSInteger collectionViewTag = 20010;
            if (![cell.contentView viewWithTag:collectionViewTag]) {


                [cell.contentView addSubview:self.deviceCollectionView];
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.deviceCollectionView.tag = collectionViewTag;
                //[collectionView setItemIndex:-1];
                //collectionView.itemIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
            }
        }
    }

    else if(indexPath.section == 1){
        /*!
         注释我的消息逻辑，第一期不支持我的消息功能
         */
        
        /*
        UIImageView *redDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80*SCREEN_SCALE, 18*SCREEN_SCALE, 8*SCREEN_SCALE, 8*SCREEN_SCALE)];
        redDotImageView.image = [UIImage imageNamed:@"icon_Reddot"];
        [cell.contentView addSubview:redDotImageView];
        cell.textLabel.text = @"我的消息";
         */
        
    }
    else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"分享APP";
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"关于我们";
        }
        else{
            cell.textLabel.text = @"设置";
        }
        //dict = _myInfoSettingConfigList[indexPath.row];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    else{
//        //dict = _myInfoSettingConfigList[1+indexPath.row];
//        
//
//    }
//    cell.textLabel.text = [dict objectForKey:@"name"];
//    cell.textLabel.textColor = EHCor5;
//    cell.textLabel.font = EHFont2;
//    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        /*!
         注释我的消息逻辑，第一期不支持我的消息功能
         */
        /*
        TBOpenURLFromTarget(@"HSMyMessageInfoViewController", self);
         */
    }
    else{

        // 分享 关于 设置
        if (indexPath.row == 0) {
            // 分享
            [EHSocialShareHandle presentWithTypeArray:@[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToSms,EHShareToQRCode] Title:[NSString stringWithFormat:@"%@ %@",kHS_APP_RECOMMENT_TEXT,kHS_WEBSITE_URL] Image:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME] presentedController:self];
        }else if (indexPath.row == 1){
            TBOpenURLFromTarget(internalURL(@"HSAboutViewController"), self);
        }else{
            TBOpenURLFromTarget(internalURL(@"EHMyInfoViewController"), self);
        }

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 151.5;

        }
        else{
            return self.collectionViewheight;
        }
    }
    else if (indexPath.section == 1){
        return 0;
    }
    else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.001;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 15;
            break;
//        case 3:
//            return 15;
//            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 15;
    }
    else{
        return 0.1;

    }
}


-(HSMyInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HSMyInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 151.5)];
        _headerView.backgroundImage = [UIImage imageNamed:@"banner-我"];
//        _headerView.accountStarLevel = [KSLoginComponentItem sharedInstance].userStarLevel;
    }
    return _headerView;
}
//- (HSHomeAccountInfoView *)homeAccountInfoView {
//    if (!_homeAccountInfoView) {
//        _homeAccountInfoView = [[HSHomeAccountInfoView alloc]initWithFrame:CGRectMake(0, 150, self.tableView.width, home_accountInfoView_height)];
//    }
//    return _homeAccountInfoView;
//}

-(HSDeviceCollectionView *)deviceCollectionView{
    if (!_deviceCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _deviceCollectionView = [[HSDeviceCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210*SCREEN_SCALE) collectionViewLayout:flowLayout cellClass:[HSMyInfoAppCollectionViewCell class]];
        _deviceCollectionView.cellWidth = SCREEN_WIDTH/2;
        _deviceCollectionView.cellHeight = 70*SCREEN_SCALE;
        WEAKSELF
//        __weak __typeof(collectionView) weakCollectionView = collectionView;
        _deviceCollectionView.serviceDidFinishLoadBlock = ^{
            STRONGSELF
            strongSelf.collectionViewheight = ((strongSelf.deviceCollectionView.dataArray.count + 1)/2)*70*SCREEN_SCALE;
            strongSelf.deviceCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, strongSelf.collectionViewheight);
            NSIndexPath *indexPathRefresh = [NSIndexPath indexPathForRow:1 inSection:0];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPathRefresh] withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf.tableView.header endRefreshing];
            if (strongSelf.deviceCollectionView.dataArray.count == 0) {
                [(MJRefreshAutoNormalFooter *)strongSelf.deviceCollectionView.footer setTitle:strongSelf.emptyDataTitle forState:MJRefreshStateNoMoreData];
            }
            else{
                [(MJRefreshAutoNormalFooter *)strongSelf.deviceCollectionView.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            }

            
        };
        _deviceCollectionView.serviceDidFailLoadBlock = ^{
            STRONGSELF
            [strongSelf reloadFail];
            [WeAppToast toast:@"获取数据失败"];
        };
        _deviceCollectionView.itemIndexBlock = ^(NSIndexPath *itemIndexPath){
            STRONGSELF
            if (itemIndexPath.row >= 0) {
                HSDeviceModel *deviceModel = (HSDeviceModel *)strongSelf.deviceCollectionView.dataArray[itemIndexPath.row];
                NSMutableDictionary* params = [NSMutableDictionary dictionary];
                if (deviceModel) {
                    [params setObject:deviceModel forKey:@"deviceModel"];
                }
                if (deviceModel.productId) {
                    [params setObject:deviceModel.productId forKey:@"productId"];
                }
                TBOpenURLFromSourceAndParams((@"HSBusinessDetailViewController"), weakSelf, params);
            }
        };
        
        [_deviceCollectionView refreshDataRequest];
    }
    return _deviceCollectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height - 5) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = RGB(0x2c, 0xcb, 0x6f).CGColor;
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
        [_tableView.layer addSublayer:layer];
        //[self configPullToRefresh];
    }
    return _tableView;
}
-(WeAppLoadingView *)refreshPageLoadingView{
    if (_refreshPageLoadingView == nil) {
        _refreshPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _refreshPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _refreshPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
        _refreshPageLoadingView.backgroundColor = RGB(0x2c, 0xcb, 0x6f);
    }
    return _refreshPageLoadingView;
}

- (void)setRefreshHeaderOnTableView:(UITableView *)tableView {
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    header.backgroundColor = RGB(0x2c, 0xcb, 0x6f);
    // 设置文字
    //    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    //    [header setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    //    [header setTitle:@"正在加载数据中 ..." forState:MJRefreshStateRefreshing];
    //    header.lastUpdatedTimeLabel.hidden = YES;
    CGRect frame = header.frame;
    frame.size.height += 100;
    header.frame = frame;
    self.refreshPageLoadingView.center = CGPointMake(tableView.width/2.0, self.refreshPageLoadingView.height / 2.0 + 105);
    [header addSubview:self.refreshPageLoadingView];
    
    tableView.header = header;
}

- (void)setLoadMoreFooterOnTableView:(UITableView *)tableView {
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil];
    [(MJRefreshAutoNormalFooter *)self.tableView.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    //不再触发动画过程，显示加载完毕的效果，只显示文本
    [self.tableView.footer noticeNoMoreData];
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UMSocialUIDelegate
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        EHLogInfo(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [WeAppToast toast:@"分享成功！"];
    }
    else {
        [WeAppToast toast:@"分享失败！"];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- KSTabBarViewControllerProtocol

-(BOOL)shouldSelectViewController:(UIViewController*)viewController{
    return [self checkLogin];
}

- (CGRect)selectViewControllerRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 49);
}

-(void)userDidLogin:(NSDictionary*)userInfo{
    _headerView.userPhoneNumber = [KSAuthenticationCenter userPhone];
//    _headerView.userPackage = [KSLoginComponentItem sharedInstance].userPackage;
    // 重新登录后HSDeviceCollectionView对应的数据会有变化，因此需要刷新self.tableView
    [self.deviceCollectionView refreshDataRequest];
//    [self.tableView reloadData];
}

-(void)userDidLogout:(NSDictionary *)userInfo{
    _headerView.userPhoneNumber = nil;
    _headerView.userPackage = nil;
}

@end
