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
#import "HSMyInfoAppCollectionViewCell.h"


@interface HSMyInfoTabViewController()<UITableViewDataSource, UITableViewDelegate>

@property HSPageViewControllerDemo *pageViewDemo;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) HSMyInfoHeaderView *headerView;

@property (nonatomic, strong) HSHomeAccountInfoView  *homeAccountInfoView;

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
    [self.view addSubview:self.tableView];
    [self initMyInfoSettingItemList];
}

- (void)initMyInfoSettingItemList
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MyInfoSettingItemList" ofType:@"plist"];
    _myInfoSettingConfigList = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = EHCor1;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict;
    if (indexPath.section == 0) {
        //[cell.contentView addSubview:self.headerImageView];
        [cell.contentView addSubview:self.headerView];
        [cell.contentView addSubview:self.homeAccountInfoView];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    else if(indexPath.section == 1){
        
        NSInteger collectionViewTag = 20010;
        if (![cell.contentView viewWithTag:collectionViewTag]) {
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            HSHomeCustomerServiceCollectionView *collectionView = [[HSHomeCustomerServiceCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) collectionViewLayout:flowLayout cellClass:[HSMyInfoAppCollectionViewCell class]];
            collectionView.cellWidth = SCREEN_WIDTH/3;
            collectionView.cellHeight = 150;
            [collectionView refreshDataRequest];
            [cell.contentView addSubview:collectionView];
            cell.accessoryType = UITableViewCellAccessoryNone;
            collectionView.tag = collectionViewTag;
            //[collectionView setItemIndex:-1];
            //collectionView.itemIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
            WEAKSELF
            __weak __typeof(collectionView) weakCollectionView = collectionView;
            collectionView.itemIndexBlock = ^(NSIndexPath *itemIndexPath){
                if (itemIndexPath.row >= 0) {
                    HSApplicationModel *appModel = (HSApplicationModel *)weakCollectionView.dataArray[itemIndexPath.row];
                    NSMutableDictionary* params = [NSMutableDictionary dictionary];
                    if (appModel) {
                        [params setObject:appModel forKeyedSubscript:@"appModel"];
                    }
                    if (appModel.appId) {
                        [params setObject:appModel.appId forKeyedSubscript:@"appId"];
                    }
                    TBOpenURLFromSourceAndParams((@"HSBusinessDetailViewController"), weakSelf, params);
                }
            };
        }
    }

    else if(indexPath.section == 2){
        dict = _myInfoSettingConfigList[indexPath.row];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        dict = _myInfoSettingConfigList[1+indexPath.row];
        

    }
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.textColor = EHCor5;
    cell.textLabel.font = EHFont2;
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        
    }
    else if(indexPath.section == 2){
        TBOpenURLFromTarget(@"HSMyMessageInfoViewController", self);
        
    }
    else{
        // 分享 关于 设置
        if (indexPath.row == 0) {
            // 分享
            [EHSocialShareHandle presentWithTypeArray:@[EHShareToWechatSession,EHShareToWechatTimeline,EHShareToSms,EHShareToQRCode] Title:[NSString stringWithFormat:@"%@ %@",kHS_APP_RECOMMENT_TEXT,kHS_WEBSITE_URL] Image:[UIImage imageNamed:kEH_LOGO_IMAGE_NAME] presentedController:self];
        }else if (indexPath.row == 1){
            TBOpenURLFromTarget(internalURL(@"HSAboutViewController"), self);
        }else{
//            TBOpenURLFromTarget(internalURL(@"HSSettingViewController"), self);
            TBOpenURLFromTarget(internalURL(@"EHMyInfoViewController"), self);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150+home_accountInfoView_height;
    }
    else if(indexPath.section ==1){
        return 300;
    }
    else
    {
        return 49;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 15;
            break;
        case 2:
            return 15;
            break;
        case 3:
            return 15;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


//-(UIImageView *)headerImageView{
//    if (!_headerImageView) {
//        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
//        [_headerImageView setImage:[UIImage imageNamed:@"bg_ PhoneNumber"]];
//    }
//    return _headerImageView;
//}

-(HSMyInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HSMyInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _headerView.backgroundImage = [UIImage imageNamed:@"bg_ PhoneNumber"];
        _headerView.userPhoneNumber = [KSAuthenticationCenter userPhone];
        _headerView.userPackage = [KSLoginComponentItem sharedInstance].userPackage;
//        _headerView.accountStarLevel = [KSLoginComponentItem sharedInstance].userStarLevel;
    }
    return _headerView;
}
- (HSHomeAccountInfoView *)homeAccountInfoView {
    if (!_homeAccountInfoView) {
        _homeAccountInfoView = [[HSHomeAccountInfoView alloc]initWithFrame:CGRectMake(0, 150, self.tableView.width, home_accountInfoView_height)];
    }
    return _homeAccountInfoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //[self configPullToRefresh];
    }
    return _tableView;
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

@end
