//
//  HSProductCellHeightLayout.h
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSProductInfoModel.h"

@interface HSProductCellHeightLayout : NSObject

@property (nonatomic, assign) CGFloat bannerViewHeight;                 //滚动视图高度
@property (nonatomic, assign) CGFloat headerCellHeight;                 //产品logo、名称、简介cell高度
@property (nonatomic, assign) CGFloat introductionCellHeight;           //产品介绍cell高度
@property (nonatomic, assign) CGFloat combosCellHeight;                 //当无套餐时提供默认高度
@property (nonatomic, strong) NSMutableArray *combosCellHeightArray;    //当有套餐时提供各个套餐的高度数组
@property (nonatomic, assign) CGFloat buyCellHeight;

+ (HSProductCellHeightLayout *)layoutWithModel:(HSProductInfoModel *)model cellWidth:(CGFloat)width;

@end
