//
//  HSAfterSaleForAppViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAfterSaleForAppViewController.h"

@interface HSAfterSaleForAppViewController ()

@end

@implementation HSAfterSaleForAppViewController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams {
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        HSProductInfoModel *productModel = [nativeParams objectForKey:@"productModel"];
        NSLog(@"HSProductInfoModel productModel = %@",productModel);
        if (productModel) {
            [self refreshDataWithProductModel:productModel];
        }
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.view addSubview:self.afterSaleForAppView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务网点";

    [self.afterSaleForAppView beginRefreshing];
}

- (void)refreshDataWithProductModel:(HSProductInfoModel*)productModel {
    [self.afterSaleForAppView refreshDataWithProductModel:productModel];
}

- (HSAfterSaleForAppView *)afterSaleForAppView {
    if (!_afterSaleForAppView) {
        _afterSaleForAppView = [[HSAfterSaleForAppView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _afterSaleForAppView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
