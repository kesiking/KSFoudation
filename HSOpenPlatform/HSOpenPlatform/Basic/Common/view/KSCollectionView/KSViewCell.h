//
//  KSViewCell.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-24.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDataSource.h"

@class KSScrollViewServiceController;

@protocol KSViewCellProtocol <NSObject>

@required

- (void)configCellWithFrame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams;

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams;

- (void)didSelectItemWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams;

@optional

- (void)configDeleteCellAtIndexPath:(NSIndexPath*)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(id)extroParams;

@end

@interface KSViewCell : KSView

@property (nonatomic,weak)   KSScrollViewServiceController* scrollViewCtl;

@property (nonatomic,strong) NSIndexPath                   *indexPath;
// 上下文，用于scrollViewController传递给viewCell之间数据的沟通桥梁
@property (nonatomic, strong) id                            scrollViewControllerContext;

+ (id)createView;

+ (BOOL)isViewCellInstanceFromNib;

// 检查cell是否合法
- (BOOL)checkCellLegalWithWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem;

// 用于初始化或重用cell时
- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams;

// 用于滑动停止时更新数据，用于性能优化
- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams;

// 用于选中cell时使用
- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams;

// 用于批量删除操作时使用，可改变选中的需要删除cell的样式
- (void)configDeleteCellWithCellView:(id<KSViewCellProtocol>)cell atIndexPath:(NSIndexPath*)indexPath componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams;

@end
