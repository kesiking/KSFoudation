//
//  HSActivityInfoDetailView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/14.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoDetailView.h"

typedef NS_ENUM(NSInteger, HSActivityInfoDetailViewType) {
    HSActivityInfoDetailViewType_OnlyImage = 1,       // 仅有一张大图
    HSActivityInfoDetailViewType_ImageAndDesc,        // 一张图片及介绍
};

#define ActivityInfoDetailBorderX (25.0)

@interface HSActivityInfoDetailView()

@property (nonatomic, strong) UIImageView                           *activityDetailAllScreenImageView;

@property (nonatomic, strong) CSLinearLayoutView                    *container;
@property (nonatomic, strong) UIImageView                           *activityDetailImageView;
@property (nonatomic, strong) UILabel                               *activityDetailStartTimeLabel;
@property (nonatomic, strong) UILabel                               *activityDetailEndTimeLabel;
@property (nonatomic, strong) UILabel                               *activityDetailTitleLabel;
@property (nonatomic, strong) UILabel                               *activityDetailInfoDescLabel;
@property (nonatomic, strong) UIButton                              *activityDetailAttendButton;

@property (nonatomic, assign) HSActivityInfoDetailViewType           activityInfoDetailViewType;

@end

@implementation HSActivityInfoDetailView

-(void)setupView{
    [super setupView];
    [self addSubview:self.container];
}

-(void)setActivityInfoModel:(HSActivityInfoModel *)activityInfoModel{
    _activityInfoModel = activityInfoModel;
    if (activityInfoModel != nil) {
        [self reloadData];
    }
}

-(void)dealloc{
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)reloadData{
    self.activityInfoDetailViewType = (self.activityInfoModel.activityImageUrl != nil && self.activityInfoModel.activityImageUrl.length != 0) ? HSActivityInfoDetailViewType_OnlyImage : HSActivityInfoDetailViewType_ImageAndDesc;
    if (self.activityInfoDetailViewType == HSActivityInfoDetailViewType_ImageAndDesc) {
        [self reloadDataForImageAndDesc];
    }else if (self.activityInfoDetailViewType == HSActivityInfoDetailViewType_OnlyImage) {
        [self reloadDataForOnlyImage];
    }
}

-(void)reloadDataForOnlyImage{
    [self.activityDetailAllScreenImageView sd_setImageWithURL:[NSURL URLWithString:self.activityInfoModel.activityImageUrl] placeholderImage:HSDefaultPlaceHoldImage];
    
    [self.container removeAllItems];
    
    CGPoint containerOffset          = self.container.contentOffset;
    CSLinearLayoutItemPadding padding = CSLinearLayoutMakePadding(0, 0, 0, 0);
    
    CSLinearLayoutItem *activityDetailAllScreenImageViewItem = [[CSLinearLayoutItem alloc] initWithView:self.activityDetailAllScreenImageView];
    activityDetailAllScreenImageViewItem.padding = padding;
    [self.container addItem:activityDetailAllScreenImageViewItem];
    
    /*调整布局*/
    if (self.container.contentSize.height > self.container.height) {
        [self.container setContentOffset:containerOffset];
    }
}

-(void)reloadDataForImageAndDesc{
    [self.activityDetailImageView sd_setImageWithURL:[NSURL URLWithString:self.activityInfoModel.activityImageUrlForAdv] placeholderImage:HSDefaultPlaceHoldImage];
    [self.activityDetailTitleLabel setText:self.activityInfoModel.activityTitle];
    [self.activityDetailTitleLabel sizeToFit];
    [self.activityDetailInfoDescLabel setText:self.activityInfoModel.activityDetailText];
    [self.activityDetailInfoDescLabel sizeToFit];
    
    // 修改活动VC的title
    if (self.activityInfoModel.activityTitle) {
        self.activityViewController.title = self.activityInfoModel.activityTitle;
    }
    /*
     * 暂时不加活动按钮
     if (self.activityInfoModel.activityCanAttend) {
        [self.activityDetailAttendButton setBackgroundColor:EHCor6];
        [self.activityDetailAttendButton setTitleColor:EHCor1 forState:UIControlStateNormal];
     }else{
        [self.activityDetailAttendButton setBackgroundColor:EHCor24];
        [self.activityDetailAttendButton setTitleColor:EHCor25 forState:UIControlStateDisabled];
        self.activityDetailAttendButton.enabled = NO;
     }
     */
    
    
    [self.container removeAllItems];
    
    CGPoint containerOffset          = self.container.contentOffset;
    CSLinearLayoutItemPadding padding = CSLinearLayoutMakePadding(0, ActivityInfoDetailBorderX, 10, ActivityInfoDetailBorderX);
    
    CSLinearLayoutItem *activityDetailImageViewItem = [[CSLinearLayoutItem alloc] initWithView:self.activityDetailImageView];
    activityDetailImageViewItem.padding = CSLinearLayoutMakePadding(15, ActivityInfoDetailBorderX, 20, ActivityInfoDetailBorderX);
    [self.container addItem:activityDetailImageViewItem];
    
    CSLinearLayoutItem *activityDetailTitleLabelItem = [[CSLinearLayoutItem alloc] initWithView:self.activityDetailTitleLabel];
    activityDetailTitleLabelItem.padding = padding;
    [self.container addItem:activityDetailTitleLabelItem];
    
    CSLinearLayoutItem *activityDetaillInfoDescLabelItem = [[CSLinearLayoutItem alloc] initWithView:self.activityDetailInfoDescLabel];
    activityDetaillInfoDescLabelItem.padding = padding;
    [self.container addItem:activityDetaillInfoDescLabelItem];
    
    /*调整布局*/
    if (self.container.contentSize.height > self.container.height) {
        [self.container setContentOffset:containerOffset];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 懒加载 
KSPropertyInitImageView(activityDetailAllScreenImageView,{
    [_activityDetailAllScreenImageView setFrame:self.bounds];
})
KSPropertyInitImageView(activityDetailImageView,{
    [_activityDetailImageView setFrame:CGRectMake(0, 0, self.width - ActivityInfoDetailBorderX * 2, 130)];
})
KSPropertyInitLabelView(activityDetailStartTimeLabel)
KSPropertyInitLabelView(activityDetailEndTimeLabel)
KSPropertyInitLabelView(activityDetailTitleLabel,{
    _activityDetailTitleLabel.font = [UIFont systemFontOfSize:EHSiz2];
    [_activityDetailTitleLabel setTextColor:EHCor5];
    [_activityDetailTitleLabel setFrame:CGRectMake(0, 0, self.width - ActivityInfoDetailBorderX * 2, 15)];
})
KSPropertyInitLabelView(activityDetailInfoDescLabel,{
    [_activityDetailInfoDescLabel setFrame:CGRectMake(0, 0, self.width - ActivityInfoDetailBorderX * 2, 20)];
    [_activityDetailInfoDescLabel setTextColor:EHCor5];
    _activityDetailInfoDescLabel.font = [UIFont systemFontOfSize:EHSiz2];
})
KSPropertyInitButtonView(activityDetailAttendButton,{
    [_activityDetailAttendButton setFrame:CGRectMake(55, self.height - 44, self.width - 55 * 2, 44)];
    [_activityDetailAttendButton setTitle:@"参加活动" forState:UIControlStateNormal];
    [_activityDetailAttendButton setBackgroundColor:EH_cor9];
})

-(void)activityDetailAttendButtonClicked:(id)sender{
    [WeAppToast toast:@"去参加页面"];
}

#pragma mark - container
KSPropertyInitCustomView(container,CSLinearLayoutView,{
    float containerHeight = self.height;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, containerHeight);
    _container = [[CSLinearLayoutView alloc] initWithFrame:frame];
    _container.alwaysBounceVertical = YES;
    _container.backgroundColor  = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_ComponentBg1];
})

@end
