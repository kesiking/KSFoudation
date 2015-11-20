//
//  HSBussinessComboInfoView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBussinessComboInfoView.h"

#define kHSTitleAndBtnBorderY (10)

@interface HSBussinessComboInfoView()

@property (nonatomic, strong) UILabel               *businessComboTitleLabel;

@property (nonatomic, strong) UIView                *businessComboTitleLabelBottomLine;

@property (nonatomic, strong) UIImageView           *businessComboImageView;

@property (nonatomic, strong) UIButton              *businessComboBtn;

@property (nonatomic, strong) UIView                *businessComboBtnBottomLine;

@property (nonatomic, strong) UILabel               *businessComboLabel;

@property (nonatomic, assign) BOOL                   comboHasShowed;

@end

@implementation HSBussinessComboInfoView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public override method
-(void)setupView{
    [super setupView];
    self.clipsToBounds = YES;
    self.comboHasShowed = NO;
    self.changeComboViewFrameWithAnimation = YES;
    [self.businessComboTitleLabel setOpaque:YES];
    [self.businessComboImageView setOpaque:YES];
    [self.businessComboBtn setOpaque:YES];
    [self.businessComboTitleLabelBottomLine setOpaque:YES];
    [self.businessComboBtnBottomLine setOpaque:YES];
    [self.endline setOpaque:YES];
    [self.topline setOpaque:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - reloadData override method
-(void)reloadData{
    [self.businessComboBtn setTitle:@"套餐基础包5元" forState:UIControlStateNormal];
    [self.businessComboLabel setText:@"基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。基础包5元/月包括视频录像回放、实时对讲。"];
    [self.businessComboLabel sizeToFit];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitLabelView(businessComboTitleLabel,{
    [_businessComboTitleLabel setFrame:CGRectMake(BussinessDetailBorderLeft, 0, BussinessDetailWidth, 44)];
    [_businessComboTitleLabel setNumberOfLines:1];
    [_businessComboTitleLabel setText:@"套餐"];
    [_businessComboTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_businessComboTitleLabel setFont:[UIFont boldSystemFontOfSize:EHSiz2]];
    [_businessComboTitleLabel setTextColor:EHCor5];
})

-(UIView *)businessComboTitleLabelBottomLine{
    if (_businessComboTitleLabelBottomLine == nil) {
        _businessComboTitleLabelBottomLine = [TBDetailUITools drawDivisionLine:0
                                                yPos:self.businessComboTitleLabel.bottom - 0.5
                                           lineWidth:self.width];
        [_businessComboTitleLabelBottomLine setBackgroundColor:EH_cor13];
        [self addSubview:_businessComboTitleLabelBottomLine];
    }
    return _businessComboTitleLabelBottomLine;
}

-(UIView *)businessComboBtnBottomLine{
    if (_businessComboBtnBottomLine == nil) {
        _businessComboBtnBottomLine = [TBDetailUITools drawDivisionLine:0
                                                                          yPos:self.businessComboBtn.bottom - 0.5
                                                                     lineWidth:self.width];
        [_businessComboBtnBottomLine setBackgroundColor:EH_cor13];
        [self addSubview:_businessComboBtnBottomLine];
    }
    return _businessComboBtnBottomLine;
}

KSPropertyInitImageView(businessComboImageView,{
    [_businessComboImageView setFrame:CGRectMake(BussinessDetailBorderLeft, self.businessComboTitleLabel.bottom + (44 - 25)/2, 25, 25)];
    [_businessComboImageView setImage:[UIImage imageNamed:@"icon_Booked"]];
})

KSPropertyInitButtonView(businessComboBtn,{
    [_businessComboBtn setFrame:CGRectMake(0, self.businessComboTitleLabel.bottom, self.width, 44)];
    [_businessComboBtn setTitle:@"套餐基础包" forState:UIControlStateNormal];
    [_businessComboBtn setTitleColor:EHCor5 forState:UIControlStateNormal];
    [_businessComboBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:EHSiz2]];
    [_businessComboBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_businessComboBtn setImage:[UIImage imageNamed:@"icon_details_down"] forState:UIControlStateNormal];
})

KSPropertyInitLabelView(businessComboLabel,{
    [_businessComboLabel setFrame:CGRectMake(BussinessDetailBorderLeft, self.businessComboBtn.bottom, BussinessDetailWidth, 20)];
    [_businessComboLabel setNumberOfLines:0];
    [_businessComboLabel setFont:[UIFont systemFontOfSize:EHSiz3]];
    [_businessComboLabel setTextColor:EHCor5];
    _businessComboLabel.alpha = 0;
})

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - clicked action method
-(void)businessComboBtnClicked:(id)sender{
    self.comboHasShowed = !self.comboHasShowed;
    if (self.businessViewDidSelectBlock) {
        self.businessViewDidSelectBlock(self);
    }
    [self changeBusinessComboBtnImage];
    [self changeBusinessComboViewFrame];
}

-(void)changeBusinessComboBtnImage{
    if (!self.comboHasShowed) {
        [self.businessComboBtn setImage:[UIImage imageNamed:@"icon_details_down"] forState:UIControlStateNormal];
    }else{
        [self.businessComboBtn setImage:[UIImage imageNamed:@"icon_details_up"] forState:UIControlStateNormal];
    }
}

-(void)changeBusinessComboViewFrame{
    CGSize comboSize = [self sizeThatFits:self.size];
    CGRect newFrame = (CGRect){self.frame.origin, comboSize};
    WEAKSELF
    void(^HSBusinessChangeFrameBlock)(CGRect newFrame) = ^(CGRect newFrame){
        STRONGSELF
        strongSelf.businessComboLabel.alpha = self.comboHasShowed ? 1 : 0;
        [strongSelf setFrame:newFrame];
    };
    if(self.changeComboViewFrameWithAnimation){
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            if(HSBusinessChangeFrameBlock){
                HSBusinessChangeFrameBlock(newFrame);
            }
        } completion:^(BOOL finished) {
            
        }];
    }else{
        if(HSBusinessChangeFrameBlock){
            HSBusinessChangeFrameBlock(newFrame);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system override method
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_businessComboTitleLabel.width != BussinessDetailWidth) {
        [_businessComboTitleLabel setFrame:CGRectMake(BussinessDetailBorderLeft, 0, BussinessDetailWidth, _businessComboTitleLabel.height)];
    }
    [_businessComboImageView setFrame:CGRectMake(BussinessDetailBorderLeft, _businessComboTitleLabel.bottom + (44 - 25)/2, 25, 25)];
    if (_businessComboBtn.width != self.width) {
        [_businessComboBtn setFrame:CGRectMake(0, _businessComboTitleLabel.bottom, self.width, _businessComboBtn.height)];
        [_businessComboBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_businessComboBtn.imageView.image.size.width + _businessComboImageView.right + 11, 0, 0)];
        [_businessComboBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _businessComboBtn.width - BussinessDetailBorderRight - _businessComboBtn.imageView.image.size.width, 0, BussinessDetailBorderLeft)];
    }
    if (_businessComboLabel.width != BussinessDetailWidth) {
        [_businessComboLabel setFrame:CGRectMake(BussinessDetailBorderLeft, _businessComboBtn.bottom + kHSTitleAndBtnBorderY, BussinessDetailWidth, _businessComboLabel.height)];
    }
    [_businessComboTitleLabelBottomLine setFrame:CGRectMake(_businessComboTitleLabelBottomLine.origin.x, _businessComboTitleLabel.bottom - 0.5, self.width, _businessComboTitleLabelBottomLine.height)];
    [_businessComboBtnBottomLine setFrame:CGRectMake(_businessComboBtnBottomLine.origin.x, _businessComboBtn.bottom - 0.5, self.width, _businessComboBtnBottomLine.height)];
}

-(CGSize)sizeThatFits:(CGSize)size{
    if (!self.comboHasShowed) {
        return CGSizeMake(size.width, self.businessComboBtn.bottom);
    }
    return CGSizeMake(size.width, self.businessComboBtn.bottom + kHSTitleAndBtnBorderY + self.businessComboLabel.height + 20);
}

@end
