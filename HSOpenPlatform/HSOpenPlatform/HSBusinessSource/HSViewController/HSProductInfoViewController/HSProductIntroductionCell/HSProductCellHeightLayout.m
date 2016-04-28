//
//  HSProductCellHeightLayout.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductCellHeightLayout.h"
#import "NSString+StringSize.h"
#import "HSProductCombosCell.h"

@implementation HSProductCellHeightLayout

+ (HSProductCellHeightLayout *)layoutWithModel:(HSProductInfoModel *)model cellWidth:(CGFloat)width {
    HSProductCellHeightLayout *layout = [[HSProductCellHeightLayout alloc]init];
    //滚动视图高度
    layout.bannerViewHeight = (caculateNumber(151.0));
    
    //产品logo、名称、简介cell高度
    layout.headerCellHeight = 70;
    
    //产品介绍cell高度
    if (model.productExplain) {
        layout.introductionCellHeight = 15+[@"text" sizeWithFont:HS_font5 Width:100].height+15+20+[model.productExplain sizeWithFont:HS_font5 Width:width-30].height;
    }
    else {
        layout.introductionCellHeight = 15+[@"text" sizeWithFont:HS_font5 Width:100].height+20;
    }
    
    //套餐cell高度
    CGFloat menuTitleLabelHeight = [@"title" sizeWithFont:HS_font5 Width:100].height;
    layout.combosCellHeightArray = [[NSMutableArray alloc]init];
    if ((model.combos == nil)||(model.combos.count == 0)) {
        layout.combosCellHeight = 20+menuTitleLabelHeight+20;
    }
    else {
        for (NSInteger i = 0; i < model.combos.count; i++) {
            HSProductComboModel *menuModel = model.combos[i];
            CGFloat menusCellHeight = 20+menuTitleLabelHeight+15+(kProductMenuBtnHeight + kProductMenuBtnYSpace)*((model.combos.count + 2)/3)+20+[menuModel.comboContent sizeWithFont:HS_font5 Width:width-30].height;
            [layout.combosCellHeightArray addObject:@(menusCellHeight)];
        }
    }
    
    //购买按钮cell高度
    layout.buyCellHeight = 60;
    return layout;
}

@end
