//
//  KSViewCellNode.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_AsyncDisplayKit

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import "KSScrollViewServiceController.h"
#import "KSDataSource.h"
#import "KSViewCell.h"

@interface KSViewCellNode : ASDisplayNode

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,weak)   KSScrollViewServiceController* scrollViewCtl;

@property (nonatomic,strong) NSIndexPath                   *indexPath;

- (void)setupView;

- (BOOL)shouldViewCellNodeRasterizeDescendants;

// 函数模板,针对ASNetworkImageNode滑动中可能会出现图片没有下载下来等引起的没能展示出来，所以需要根据networkImageNode与imageUrl配合判断是否需要清楚networkImageNode的URL
-(void)resetIfImageUrlEqualToNetworkImageNodeWithASNetworkImageNode:(ASNetworkImageNode*)networkImageNode imageUrl:(NSString*)imageUrl;

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

#endif
