//
//  HSAfterSaleViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleViewController.h"
#import "HSAfterSaleView.h"

@interface HSAfterSaleViewController ()

@property (nonatomic, strong) HSAfterSaleView *afterSaleView;

@end

@implementation HSAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EH_bgcor1;
    [self.view addSubview:self.afterSaleView];
    
    [self.afterSaleView beginRefreshing];
}

- (HSAfterSaleView *)afterSaleView {
    if (!_afterSaleView) {
        _afterSaleView = [[HSAfterSaleView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _afterSaleView.needRefreshHeader = YES;
        _afterSaleView.needLoadMoreFooter = YES;
    }
    return _afterSaleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
