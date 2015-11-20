//
//  HSAfterSaleListView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//  AfterSale布局

#import "HSBaseTableView.h"
#import "HSApplicationModel.h"
#import "HSHomeServicLocationCell.h"
#import "HSNationalAfterSaleCell.h"

@interface HSAfterSaleListView : HSBaseTableView

@property (nonatomic, strong) HSNationalAfterSaleModel *nationalAfterSaleModel;

@property (nonatomic, strong) HSApplicationModel *appModel;

@end
