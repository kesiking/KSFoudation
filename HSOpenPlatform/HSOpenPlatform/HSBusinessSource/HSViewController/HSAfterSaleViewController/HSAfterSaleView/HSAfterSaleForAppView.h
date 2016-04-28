//
//  HSAfterSaleForAppView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//  AfterSale配置Service

#import "HSAfterSaleListView.h"
#import "HSApplicationModel.h"
#import "HSProductInfoModel.h"
typedef BOOL(^NeedRefreshBlock)(void);

@interface HSAfterSaleForAppView : HSAfterSaleListView

@property (nonatomic, strong) NeedRefreshBlock needRefreshBlock;    //可进行外部是否刷新判断回调

- (void)refreshDataWithProductModel:(HSProductInfoModel*)productModel;

@end
