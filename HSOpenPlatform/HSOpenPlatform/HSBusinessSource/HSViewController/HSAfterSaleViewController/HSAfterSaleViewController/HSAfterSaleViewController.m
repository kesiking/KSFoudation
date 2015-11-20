//
//  HSAfterSaleViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleViewController.h"
#import "HSAfterSaleForAppViewController.h"
#import "HSHomeCustomerServiceCollectionView.h"
#import "HSAfterSaleCollectionViewCell.h"



@interface HSAfterSaleViewController ()

@property (nonatomic, strong) HSAfterSaleForAppViewController *afterSaleForAppVC;

@property (nonatomic, strong) HSHomeCustomerServiceCollectionView *serviceCollectionView;

@end

@implementation HSAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EH_bgcor1;
    self.title = @"售后服务网点";

    [self.view addSubview:self.afterSaleForAppVC.view];
    [self addChildViewController:self.afterSaleForAppVC];
    [self configTableHeaderView];
}

#pragma mark - Config TableHeaderView
- (void)configTableHeaderView {
    CGRect frame = self.serviceCollectionView.bounds;
    frame.size.height += caculateNumber(15);
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:frame];
    tableHeaderView.backgroundColor = self.view.backgroundColor;
    [tableHeaderView addSubview:self.serviceCollectionView];
    
    self.afterSaleForAppVC.afterSaleForAppView.tableHeaderView = tableHeaderView;
}

#pragma mark - Config AfterSaleForAppVC
- (HSAfterSaleForAppViewController *)afterSaleForAppVC {
    if (!_afterSaleForAppVC) {
        _afterSaleForAppVC = [[HSAfterSaleForAppViewController alloc]init];
        
        WEAKSELF
        self.afterSaleForAppVC.afterSaleForAppView.needRefreshBlock = ^(){
            STRONGSELF
            if (strongSelf.serviceCollectionView.dataArray.count == 0) {
                [strongSelf.serviceCollectionView refreshDataRequest];
                return NO;
            }
            else
                return YES;
        };
    }
    return _afterSaleForAppVC;
}

#pragma mark - Config AppListView
- (HSHomeCustomerServiceCollectionView *)serviceCollectionView {
    if (!_serviceCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _serviceCollectionView = [[HSHomeCustomerServiceCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/6.0) collectionViewLayout:flowLayout cellClass:[HSAfterSaleCollectionViewCell class]];
        _serviceCollectionView.cellHeight = SCREEN_WIDTH/6.0;
        _serviceCollectionView.cellWidth = SCREEN_WIDTH/6.0;
        //[_serviceCollectionView setItemIndex:1];
        
        WEAKSELF
        _serviceCollectionView.serviceDidFinishLoadBlock = ^(){
            STRONGSELF
            strongSelf.serviceCollectionView.itemIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            strongSelf.serviceCollectionView.itemIndexBlock?:strongSelf.serviceCollectionView.itemIndexBlock([NSIndexPath indexPathForRow:0 inSection:0]);
            };

//            !strongSelf.service
//            .itemIndexBlock?:strongSelf.itemIndexBlock(strongSelf.itemIndexPath);
        
        //app选中，刷新列表
        
        _serviceCollectionView.itemIndexBlock = ^(NSIndexPath *itemIndexPath) {
            STRONGSELF
            HSApplicationModel *appModel = (HSApplicationModel *)strongSelf.serviceCollectionView.dataArray[itemIndexPath.row];
            HSAfterSaleCollectionViewCell *cell = (HSAfterSaleCollectionViewCell *)[strongSelf.serviceCollectionView cellForItemAtIndexPath:itemIndexPath];
            cell.backgroundColor = RGB(0xee, 0xee, 0xee);
            [strongSelf.afterSaleForAppVC refreshDataWithAppModel:appModel];
        };
        
        _serviceCollectionView.serviceDidFailLoadBlock = ^(){
            STRONGSELF
            [strongSelf.afterSaleForAppVC.afterSaleForAppView reloadFail];
        };
    }
    return _serviceCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
