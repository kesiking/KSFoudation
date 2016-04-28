//
//  HSAfterSaleViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleViewController.h"
#import "HSAfterSaleForAppViewController.h"
#import "HSAfterSaleCollectionViewCell.h"
#import "HSAfterSaleProductCollectionView.h"

@interface HSAfterSaleViewController ()

@property (nonatomic, strong) HSAfterSaleForAppViewController *afterSaleForAppVC;

@property (nonatomic, strong) HSAfterSaleProductCollectionView *productCollectionView;

@end

@implementation HSAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HS_bgcor3;
    self.title = @"售后服务网点";

    [self.view addSubview:self.afterSaleForAppVC.view];
    [self addChildViewController:self.afterSaleForAppVC];
    [self configTableHeaderView];
}

#pragma mark - Config TableHeaderView
- (void)configTableHeaderView {
    CGRect frame = self.productCollectionView.bounds;
    frame.size.height += caculateNumber(15);
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:frame];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    [tableHeaderView addSubview:self.productCollectionView];
    
    self.afterSaleForAppVC.afterSaleForAppView.tableHeaderView = tableHeaderView;
}

#pragma mark - Config AfterSaleForAppVC
- (HSAfterSaleForAppViewController *)afterSaleForAppVC {
    if (!_afterSaleForAppVC) {
        _afterSaleForAppVC = [[HSAfterSaleForAppViewController alloc]init];
        
        WEAKSELF
        self.afterSaleForAppVC.afterSaleForAppView.needRefreshBlock = ^(){
            STRONGSELF
            if (strongSelf.productCollectionView.dataArray.count == 0) {
                [strongSelf.productCollectionView refreshDataRequest];
                return NO;
            }
            else
                return YES;
        };
    }
    return _afterSaleForAppVC;
}

#pragma mark - Config AppListView
- (HSAfterSaleProductCollectionView *)productCollectionView {
    if (!_productCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _productCollectionView = [[HSAfterSaleProductCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66*SCREEN_SCALE) collectionViewLayout:flowLayout cellClass:[HSAfterSaleCollectionViewCell class]];
        _productCollectionView.cellHeight = 66*SCREEN_SCALE;
        _productCollectionView.cellWidth = SCREEN_WIDTH/6.0;

        WEAKSELF
        _productCollectionView.serviceDidFinishLoadBlock = ^(){
            STRONGSELF
            if (strongSelf.productCollectionView.dataArray.count == 0) {
                [strongSelf.afterSaleForAppVC.afterSaleForAppView reloadData];
            }
            else {
                strongSelf.productCollectionView.itemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        };
        
        //app选中，刷新列表
        _productCollectionView.itemIndexBlock = ^(NSIndexPath *itemIndexPath) {
            STRONGSELF
            HSProductInfoModel *productModel = (HSProductInfoModel *)strongSelf.productCollectionView.dataArray[itemIndexPath.row];
            HSAfterSaleCollectionViewCell *cell = (HSAfterSaleCollectionViewCell *)[strongSelf.productCollectionView cellForItemAtIndexPath:itemIndexPath];
            cell.selected = YES;
            [strongSelf.afterSaleForAppVC refreshDataWithProductModel:productModel];
        };
        _productCollectionView.itemDeselectBlock = ^(NSIndexPath *itemIndexPath) {
            STRONGSELF
            HSAfterSaleCollectionViewCell *cell = (HSAfterSaleCollectionViewCell *)[strongSelf.productCollectionView cellForItemAtIndexPath:itemIndexPath];
            cell.selected = NO;
        };
        
        _productCollectionView.serviceDidFailLoadBlock = ^(){
            STRONGSELF
            [strongSelf.afterSaleForAppVC.afterSaleForAppView reloadFail];
        };
    }
    return _productCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
