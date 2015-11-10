//
//  HSBusinessHallListViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessHallListViewController.h"
#import "HSMapViewManager.h"
#import "HSBusinessHallListView.h"

@interface HSBusinessHallListViewController ()

@property (nonatomic, strong)HSBusinessHallListView *businessHallListView;

@end

@implementation HSBusinessHallListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EH_bgcor1;

    [self.view addSubview:self.businessHallListView];
    [self.businessHallListView beginRefreshing];
}

#pragma mark - Common Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (HSBusinessHallListView *)businessHallListView {
    if (!_businessHallListView) {
        _businessHallListView = [[HSBusinessHallListView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _businessHallListView.rowHeight = kHSBusinessHallListCellHeight;
        _businessHallListView.cellClass = [HSHomeServicLocationCell class];
        _businessHallListView.cellFillStyle = UICellFillStyleInSections;
        _businessHallListView.needRefreshHeader = YES;
        _businessHallListView.needLoadMoreFooter = YES;
    }
    return _businessHallListView;
}

@end
