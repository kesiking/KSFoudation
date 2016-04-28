//
//  HSAfterSaleForAppViewController.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSViewController.h"
#import "HSAfterSaleForAppView.h"
#import "HSProductInfoModel.h"

@interface HSAfterSaleForAppViewController : KSViewController

@property (nonatomic, strong)HSAfterSaleForAppView *afterSaleForAppView;

- (void)refreshDataWithProductModel:(HSProductInfoModel*)productModel;

@end
