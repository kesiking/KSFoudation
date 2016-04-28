//
//  HSProductInfoViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/22.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductInfoViewController.h"
#import "HSProductInfoService.h"
#import "HSProductHeaderCell.h"
#import "HSProductIntroductionCell.h"
#import "HSProductCombosCell.h"
#import "HSProductCellHeightLayout.h"
#import "HSProductBannerView.h"

@interface HSProductInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) HSProductBannerView       *bannerView;
@property (nonatomic, strong) UIButton                  *buyBtn;

@property (strong, nonatomic) HSProductInfoService      *productInfoService;
@property (nonatomic, strong) HSProductInfoModel        *model;
@property (nonatomic, strong) HSProductCellHeightLayout *cellHeightLayout;
@property (nonatomic, assign) NSUInteger                selectedMenuIndex;

@end

@implementation HSProductInfoViewController

#pragma mark - Life Cycle
- (instancetype)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams {
    self = [super init];
    if (self) {
        self.model = [nativeParams objectForKey:@"productInfo"];
        self.title = self.model.productName;
        self.selectedMenuIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeightLayout = [HSProductCellHeightLayout layoutWithModel:self.model cellWidth:CGRectGetWidth(self.view.frame)];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.productInfoService loadProductInfoWithProductId:self.model.productId];
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }
}

#pragma mark - Events Response
- (void)buyBtnClick:(id)sender {
    if (self.model.platUrl) {
        TBOpenURLFromSourceAndParams(internalURL(@"KSWebViewController"), self, @{WEB_REQUEST_URL_ADDRESS_KEY:self.model.platUrl});
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            [cell.contentView addSubview:self.bannerView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case 1: {
            HSProductHeaderCell *cell = [[HSProductHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configWithName:self.model.productName title:self.model.productInfo iconUrl:self.model.productLogo price:self.model.productPrice];
            return cell;
        }
            break;
            
        case 2: {
            if (indexPath.row == 0) {
                HSProductIntroductionCell *cell = [[HSProductIntroductionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setTitle:@"产品介绍" Content:self.model.productExplain];
                return cell;
            }
            else {
                HSProductComboModel *menuModel = (HSProductComboModel *)self.model.combos[self.selectedMenuIndex];
                HSProductCombosCell *cell = [[HSProductCombosCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setTitle:@"套餐类型" Content:menuModel.comboContent CombosArray:self.model.combos SelectedIndex:self.selectedMenuIndex];
                __block NSIndexPath *indPath = indexPath;
                WEAKSELF
                cell.productComboSelectedBlock = ^(NSUInteger selectedIndex){
                    STRONGSELF
                    strongSelf.selectedMenuIndex = selectedIndex;
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                return cell;
            }
        }
            break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.buyBtn];
            return cell;
        }
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.cellHeightLayout.bannerViewHeight;
            break;
        case 1:
            return self.cellHeightLayout.headerCellHeight;
            break;
        case 2:
            if (indexPath.row == 0) {
                return self.cellHeightLayout.introductionCellHeight;
            }
            else {
                if (self.cellHeightLayout.combosCellHeight) {
                    return self.cellHeightLayout.combosCellHeight;
                }
                else {
                    return [self.cellHeightLayout.combosCellHeightArray[self.selectedMenuIndex] floatValue];
                }
            }
            break;
        case 3:
            return self.cellHeightLayout.buyCellHeight;
            break;
        default:
            return 44;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Service
- (HSProductInfoService *)productInfoService {
    if (!_productInfoService) {
        _productInfoService = [HSProductInfoService new];
        WEAKSELF
        _productInfoService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            strongSelf.model = (HSProductInfoModel *)(service.item);
            strongSelf.cellHeightLayout = [HSProductCellHeightLayout layoutWithModel:strongSelf.model cellWidth:CGRectGetWidth(strongSelf.view.frame)];
            strongSelf.bannerView.productUrlImages = strongSelf.model.productImages;

            [strongSelf.tableView reloadData];
        };
        _productInfoService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){
            [WeAppToast toast:@"获取失败"];
        };
    }
    return _productInfoService;
}
#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (HSProductBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[HSProductBannerView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.cellHeightLayout.bannerViewHeight)];
    }
    return _bannerView;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, self.tableView.width - 30*2, self.cellHeightLayout.buyCellHeight - 10*2)];
        _buyBtn.backgroundColor = HS_normal_greencor;
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = HS_font2;
        _buyBtn.layer.cornerRadius = 3;
        [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

@end
