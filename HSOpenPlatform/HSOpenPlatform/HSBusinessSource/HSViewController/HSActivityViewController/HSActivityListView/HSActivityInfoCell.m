//
//  HSActivityInfoCell.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoCell.h"
#import "HSActivityInfoModel.h"
#import "HSActivityInfoCellModelInfoItem.h"
#import "HSActivityInfoDetailViewController.h"

@interface HSActivityInfoCell()

@property (nonatomic, strong) NSString*          activityImageUrl;

@property (nonatomic, assign) CGSize             activityInfoDescSize;

@end

@implementation HSActivityInfoCell

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method

+ (BOOL)isViewCellInstanceFromNib{
    return YES;
}

-(void)setupView{
    [super setupView];
    self.activityTitleLabel.textColor = EHCor5;
    self.activityInfoDescLabel.textColor = EHCor4;
    self.activityStartDateLabel.textColor = EHCor3;
    self.activityEndDateLabel.textColor = EHCor3;
    self.activityStartDateLeftLabel.hidden = YES;
    self.activityStartDateLabel.hidden = YES;
    self.activityEndDateLabel.hidden = YES;
    self.activityBottomLineImageView.backgroundColor = EH_cor17;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.activityInfoDescLabel setSize:self.activityInfoDescSize];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method

// setup activityImage
-(void)configCellImageWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSActivityInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    if (extroParams.imageHasLoaded) {
        [self reloadActivityImageViewWithImageUrl:componentItem.activityImageUrlForList];
    }else{
        self.activityImageView.image = HSDefaultPlaceHoldImage;
        self.activityImageUrl = nil;
    }
}

// setup activityLabel
-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSActivityInfoModel *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
    self.activityTitleLabel.text = [NSString stringWithFormat:@"%@",componentItem.activityTitle];
    self.activityInfoDescLabel.text = [NSString stringWithFormat:@"%@",componentItem.activityDetailText];
    
    if (![extroParams isKindOfClass:[HSActivityInfoCellModelInfoItem class]]) {
        self.activityStartDateLabel.text = [NSString stringWithFormat:@"%@",componentItem.activityStartTime];
        self.activityEndDateLabel.text = [NSString stringWithFormat:@"%@",componentItem.activityEndTime];
        return;
    }
    
    HSActivityInfoCellModelInfoItem* activityInfoCellModelInfoItem = (HSActivityInfoCellModelInfoItem*)extroParams;
    
    self.activityStartDateLabel.text = [NSString stringWithFormat:@"%@",activityInfoCellModelInfoItem.activityStartTimeStr];
    self.activityEndDateLabel.text = [NSString stringWithFormat:@"%@",activityInfoCellModelInfoItem.activityEndTimeStr];
    self.activityInfoDescSize = activityInfoCellModelInfoItem.activityInfoDescSize;
    [self.activityInfoDescLabel setSize:activityInfoCellModelInfoItem.activityInfoDescSize];
}

-(void)reloadActivityImageViewWithImageUrl:(NSString*)imageUrl{
    if (self.activityImageUrl != imageUrl) {
        [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:HSDefaultPlaceHoldImage];
    }else{
        EHLogInfo(@"----> don't need reload image again");
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
        HSActivityInfoDetailOpenURLFromTargetWithNativeParams(self, nil, params,activityInfoModel);
    }
}

@end
