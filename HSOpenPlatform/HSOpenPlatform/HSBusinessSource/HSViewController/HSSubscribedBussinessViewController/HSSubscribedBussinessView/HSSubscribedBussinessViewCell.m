//
//  HSSubscribedBussinessViewCell.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSSubscribedBussinessViewCell.h"
#import "HSSubscribeBussinessCellModelInfoItem.h"
#import "HSSubscribedBussinessBasicModel.h"

@interface HSSubscribedBussinessViewCell()

@property (nonatomic, assign) CGSize             subscribedBussinessInfoDescSize;

@end

@implementation HSSubscribedBussinessViewCell

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - override method

+(BOOL)isViewCellInstanceFromNib{
    return YES;
}

-(void)setupView{
    [super setupView];
    self.subscribedBussinessInfoLabel.textColor = EH_cor3;
    self.subscribedBussinessStartTimeLabel.textColor = EH_cor5;
    self.subscribedBussinessEndTimeLabel.textColor = EH_cor5;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.subscribedBussinessInfoLabel setSize:self.subscribedBussinessInfoDescSize];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private method

// setup activityLabel
-(void)configCellLabelWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(HSSubscribedBussinessBasicModel*)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
    self.subscribedBussinessInfoLabel.text = [NSString stringWithFormat:@"%@",componentItem.subscribedBussinessDetailText];
    
    if (![extroParams isKindOfClass:[HSSubscribeBussinessCellModelInfoItem class]]) {
        return;
    }
    
    HSSubscribeBussinessCellModelInfoItem* subscribedBussinessInfoCellModelInfoItem = (HSSubscribeBussinessCellModelInfoItem*)extroParams;
    if (subscribedBussinessInfoCellModelInfoItem.subscribedBussinessStartTime) {
        self.subscribedBussinessStartTimeLabel.text = [NSString stringWithFormat:@"%@",subscribedBussinessInfoCellModelInfoItem.subscribedBussinessStartTime];
        self.subscribedBussinessStartTimeLabel.hidden = NO;
        self.subscribedBussinessStartTimeLeftLabel.hidden = NO;
    }else{
        self.subscribedBussinessStartTimeLabel.hidden = YES;
        self.subscribedBussinessStartTimeLeftLabel.hidden = YES;
    }
    if (subscribedBussinessInfoCellModelInfoItem.subscribedBussinessEndTime) {
        self.subscribedBussinessEndTimeLabel.text = [NSString stringWithFormat:@"%@",subscribedBussinessInfoCellModelInfoItem.subscribedBussinessEndTime];
        self.subscribedBussinessEndTimeLabel.hidden = NO;
        self.subscribedBussinessEndTimeLeftLabel.hidden = NO;
    }else{
        self.subscribedBussinessEndTimeLabel.hidden = YES;
        self.subscribedBussinessEndTimeLeftLabel.hidden = YES;
    }
    self.subscribedBussinessInfoDescSize = subscribedBussinessInfoCellModelInfoItem.subscribedBussinessInfoDescSize;
    [self.subscribedBussinessInfoLabel setSize:self.subscribedBussinessInfoDescSize];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KSViewCellProtocol method

- (void)configCellWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    [super configCellWithCellView:cell Frame:rect componentItem:componentItem extroParams:extroParams];
    if (![componentItem isKindOfClass:[HSSubscribedBussinessBasicModel class]]) {
        return;
    }
    HSSubscribedBussinessBasicModel* subscribedBussinessInfoModel = (HSSubscribedBussinessBasicModel*)componentItem;
    [self configCellLabelWithCellView:cell Frame:rect componentItem:subscribedBussinessInfoModel extroParams:extroParams];
}

- (void)didSelectCellWithCellView:(id<KSViewCellProtocol>)cell componentItem:(WeAppComponentBaseItem *)componentItem extroParams:(KSCellModelInfoItem*)extroParams{
    
}

@end
