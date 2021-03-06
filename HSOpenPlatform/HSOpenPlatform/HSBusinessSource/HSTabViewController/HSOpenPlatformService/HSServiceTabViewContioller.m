//
//  HSServiceTabViewContiollerViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/9/29.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSServiceTabViewContioller.h"
#import "HSFamilyAppListService.h"
#import "HSFamilyAppInfoService.h"
#import "HSApplicationIntroModel.h"
#import "HSApplicationModel.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSAppCollectionViewCell.h"
#import "WeAppLoadingView.h"
#import "MJRefresh.h"





@interface HSServiceTabViewContioller ()


@property (strong, nonatomic) HSApplicationIntroModel *appIntro;
//@property (strong, nonatomic) HSAppCollectionView *collectionTableView;
//@property (strong, nonatomic) HSAppListCollectionView *collectionView;
@property (strong, nonatomic) HSHomeCustomerServiceCollectionView *collectionView;

@property (strong, nonatomic) HSFamilyAppInfoService *familyAppInfoService;

@property (nonatomic, strong) WeAppLoadingView                  *refreshPageLoadingView;
@property (nonatomic, strong) NSString       *loadFailTitle;       //空数据的提示文案

@property (assign, nonatomic) BOOL isAppInstalled;
@property (strong, nonatomic) NSArray *nameStringArr;



@end

@implementation HSServiceTabViewContioller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"应用";
    //[self configGetFamilyAppList];
    [self configGetFamilyAppIntro];
    
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.refreshPageLoadingView];

//    self.nameStringArr = @[@"icon_lushang",@"icon_heluyou",@"icon_hemu",@"icon_zhaota",@"icon_mobaihe",@"icon_migu",@"icon_gansu"];
    self.emptyDataTitle     = @"暂无数据";
    self.loadFailTitle      = @"下拉刷新";
    [self setRefreshHeaderOnCollectionView:self.collectionView];
    [self.collectionView.header beginRefreshing];
    [self setLoadMoreFooterOnCollectionView:self.collectionView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - Common Methods

- (void)refreshData {
    [self.collectionView refreshDataRequest];
}

- (void)reloadFail {
    if (self.collectionView.header.isRefreshing) {
        [self.collectionView.header endRefreshing];
        if (self.collectionView.dataArray.count == 0) {
            //为空数据时加载失败添加提示
            [(MJRefreshAutoNormalFooter *)self.collectionView.footer setTitle:self.loadFailTitle forState:MJRefreshStateNoMoreData];
        }
    }
}

//- (void)configGetFamilyAppList
//{
//    _familyAppListService = [HSFamilyAppListService new];
//    
//    WEAKSELF
//    _familyAppListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
//        EHLogInfo(@"getfamilyAppList完成！");
//        STRONGSELF
//        EHLogInfo(@"%@",service.dataList);
//        strongSelf.collectionView.dataArray = service.dataList;
//        for (NSInteger i=0; i<strongSelf.collectionView.dataArray.count; i++) {
//            HSApplicationModel *item = service.dataList[i];
//            item.placeholderImageStr = strongSelf.nameStringArr[i];
//        }
//        [strongSelf.collectionView reloadData];
//        [strongSelf.collectionView.header endRefreshing];
//        if (service.dataList.count == 0) {
//            [(MJRefreshAutoNormalFooter *)strongSelf.collectionView.footer setTitle:strongSelf.emptyDataTitle forState:MJRefreshStateNoMoreData];
//        }
//        else{
//            [(MJRefreshAutoNormalFooter *)strongSelf.collectionView.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
//        }
//        
//    };
//    _familyAppListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
//        STRONGSELF
//        //[strongSelf hideLoadingView];
//        [strongSelf reloadFail];
//        [WeAppToast toast:@"获取数据失败"];
//    };
//    
//    [_familyAppListService loadFamilyAppListData];
//    
//}

- (void)configGetFamilyAppIntro
{
    _familyAppInfoService = [HSFamilyAppInfoService new];
    
    WEAKSELF
    _familyAppInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
        EHLogInfo(@"getFamilyAppIntro完成！");
        STRONGSELF
        EHLogInfo(@"%@",service.dataList);
        strongSelf.appIntro = (HSApplicationIntroModel *)service.item;
//        NSLog(@"strongSelf.appIntro.appDetailIos = %@",strongSelf.appIntro.appDetailIos.appIOSURLScheme);
        NSURL *appURLScheme = [NSURL URLWithString:strongSelf.appIntro.appURLScheme];
        BOOL isAppInstalled = [[UIApplication sharedApplication] canOpenURL:appURLScheme];
        if (isAppInstalled) {
            [[UIApplication sharedApplication] openURL:appURLScheme];
        }
        else{
            if (strongSelf.appIntro.platUrl) {
                TBOpenURLFromSourceAndParams(internalURL(@"HSFamilyAppIntroParentViewController"), strongSelf,@{WEB_REQUEST_URL_ADDRESS_KEY:strongSelf.appIntro.platUrl,@"appIntro":strongSelf.appIntro,@"appName":strongSelf.appIntro.appName,});
            }
            else{
                TBOpenURLFromSourceAndParams(@"HSFamilyAppIntroCustomViewController", strongSelf, @{@"appIntro":strongSelf.appIntro,});
            }
            
            
        }
    };
    _familyAppInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
        STRONGSELF
        [strongSelf hideLoadingView];
        //[WeAppToast toast:@"获取FamilyAppInfo失败"];
    };
}



#pragma mark - setter and getter

-(HSHomeCustomerServiceCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[HSHomeCustomerServiceCollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout cellClass:[HSAppCollectionViewCell class]];
        _collectionView.cellWidth = SCREEN_WIDTH/4;
        _collectionView.cellHeight = 111;
        
        CALayer *topLine = [CALayer layer];
        [topLine setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = EHLinecor1.CGColor;
        [_collectionView.layer addSublayer:topLine];
        
        [_collectionView refreshDataRequest];

        WEAKSELF
        _collectionView.itemIndexBlock = ^(NSIndexPath *appIndexPath){
            STRONGSELF
            HSApplicationModel *appModel = strongSelf.collectionView.dataArray[appIndexPath.row];
            if (appModel.appId) {
                [strongSelf configGetFamilyAppIntro];
                [strongSelf.familyAppInfoService loadFamilyAppInfoWithAppId:appModel.appId];
            }
            
        };
        _collectionView.serviceDidFinishLoadBlock = ^(){
            STRONGSELF
            //[strongSelf.collectionView reloadData];
//            [strongSelf.collectionView refreshDataRequest];
            [strongSelf.collectionView.header endRefreshing];
            if (strongSelf.collectionView.dataArray.count == 0) {
                [(MJRefreshAutoNormalFooter *)strongSelf.collectionView.footer setTitle:strongSelf.emptyDataTitle forState:MJRefreshStateNoMoreData];
            }
            else{
                [(MJRefreshAutoNormalFooter *)strongSelf.collectionView.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            }
        };
        _collectionView.serviceDidFailLoadBlock = ^(){
            STRONGSELF
            [strongSelf reloadFail];
            [WeAppToast toast:@"获取数据失败"];
            
        };
        //return _collectionView;
    }
    return _collectionView;
}

-(WeAppLoadingView *)refreshPageLoadingView{
    if (_refreshPageLoadingView == nil) {
        _refreshPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _refreshPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _refreshPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
    }
    return _refreshPageLoadingView;
}

- (void)setRefreshHeaderOnCollectionView:(HSHomeCustomerServiceCollectionView *)collectionView {
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    // 设置文字
    //    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
    //    [header setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    //    [header setTitle:@"正在加载数据中 ..." forState:MJRefreshStateRefreshing];
    //    header.lastUpdatedTimeLabel.hidden = YES;
    self.refreshPageLoadingView.center = CGPointMake(collectionView.width/2.0, self.refreshPageLoadingView.height / 2.0 + 5);
    [header addSubview:self.refreshPageLoadingView];
    
    collectionView.header = header;
}

- (void)setLoadMoreFooterOnCollectionView:(HSHomeCustomerServiceCollectionView *)collectionView {
    collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil];
    [(MJRefreshAutoNormalFooter *)self.collectionView.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    //不再触发动画过程，显示加载完毕的效果，只显示文本
    [self.collectionView.footer noticeNoMoreData];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
