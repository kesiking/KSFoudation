//
//  HSActivityInfoCellNode.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoCellNode.h"
#import "HSActivityInfoModel.h"
#import "HSActivityInfoCellModelInfoItem.h"
#import "HSActivityInfoDetailViewController.h"

@implementation HSActivityInfoCellNode

-(void)setupView{
    [super setupView];
    
    self.layerBacked = YES;
    
    self.activityTitleLabel = [ASTextNode new];
    self.activityTitleLabel.layerBacked = YES;
    [self addSubnode:self.activityTitleLabel];

    self.activityInfoDescLabel = [ASTextNode new];
    self.activityInfoDescLabel.layerBacked = YES;
    [self addSubnode:self.activityInfoDescLabel];
    
    self.activityImageView = [ASNetworkImageNode new];
    self.activityImageView.layerBacked = YES;
    [self.activityImageView setDefaultImage:HSDefaultPlaceHoldImage];
    [self addSubnode:self.activityImageView];
}

-(void)layout{
    [self.activityImageView setFrame:(CGRect){CGPointMake(25, 25),CGSizeMake(self.frame.size.width - 25 * 2, 130)}];
    [self.activityTitleLabel setFrame:(CGRect){CGPointMake(CGRectGetMinX(self.activityImageView.frame), CGRectGetMaxY(self.activityImageView.frame) + 5),self.activityTitleLabel.calculatedSize}];
    [self.activityInfoDescLabel setFrame:(CGRect){CGPointMake(CGRectGetMinX(self.activityImageView.frame), CGRectGetMaxY(self.activityTitleLabel.frame) + 5),self.activityInfoDescLabel.calculatedSize}];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    // size the text node
    CGSize maxTitleTextSize = CGSizeMake(constrainedSize.width - 25 * 2, 20);
    CGSize titleTextSize = [self.activityTitleLabel measure:maxTitleTextSize];
    
    CGSize maxInfoDescTextSize = CGSizeMake(constrainedSize.width - 25 * 2, INT16_MAX);
    CGSize infoDescTextSize = [self.activityInfoDescLabel measure:maxInfoDescTextSize];
    
    // size the cellView
    CGSize viewCellSize = [super calculateSizeThatFits:constrainedSize];
    // make sure everything fits
    if (viewCellSize.height != 0 && viewCellSize.width != 0) {
        return viewCellSize;
    }
    // caculate with every component
    return CGSizeMake(self.frame.size.width, 25 + 130 + 5 + titleTextSize.height + 5 + infoDescTextSize.height + 5);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override public method
- (BOOL)shouldViewCellNodeRasterizeDescendants{
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method

// setup activityImage
-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSActivityInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [self reloadActivityImageViewWithImageUrl:componentItem.activityImageUrlForList];
}

// setup activityLabel
-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSActivityInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    self.activityTitleLabel.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",componentItem.activityTitle] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f], NSForegroundColorAttributeName:EHCor5}];
    self.activityInfoDescLabel.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",componentItem.activityDetailText] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName:EHCor4}];
}

-(void)reloadActivityImageViewWithImageUrl:(NSString*)imageUrl{
    if (imageUrl) {
        [self resetIfImageUrlEqualToNetworkImageNodeWithASNetworkImageNode:self.activityImageView imageUrl:imageUrl];
        [self.activityImageView setURL:[NSURL URLWithString:imageUrl] resetToDefault:YES];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSViewCellProtocol method

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    if (![componentItem isKindOfClass:[HSActivityInfoModel class]]) {
        return;
    }
    HSActivityInfoModel* activityInfoModel = (HSActivityInfoModel*)componentItem;
    [self configCellLabelWithCellView:cell Frame:rect componentItem:activityInfoModel extroParams:extroParams];
    [self configCellImageWithCellView:cell Frame:rect componentItem:activityInfoModel extroParams:extroParams];
}

- (void)refreshCellImagesWithComponentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (![componentItem isKindOfClass:[HSActivityInfoModel class]]) {
        return;
    }
    HSActivityInfoModel* activityInfoModel = (HSActivityInfoModel*)componentItem;
    [self reloadActivityImageViewWithImageUrl:activityInfoModel.activityImageUrlForList];
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (componentItem && [componentItem isKindOfClass:[HSActivityInfoModel class]]) {
        HSActivityInfoModel* activityInfoModel = (HSActivityInfoModel*)componentItem;
        NSDictionary* params = @{@"activityInfoModel":activityInfoModel};
        HSActivityInfoDetailOpenURLFromTargetWithNativeParams(self.view, nil, params,activityInfoModel);
    }
}

@end
