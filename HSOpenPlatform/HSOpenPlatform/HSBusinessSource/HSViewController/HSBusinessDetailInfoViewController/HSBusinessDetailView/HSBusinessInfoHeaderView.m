//
//  HSBusinessInfoHeaderView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessInfoHeaderView.h"

@interface HSBusinessInfoHeaderView()

@property (nonatomic, strong) UIImageView           *businessInfoImageView;

@property (nonatomic, strong) UIImageView           *businessInfoArrowView;

@property (nonatomic, strong) UILabel               *businessInfoTitleLabel;

@property (nonatomic, strong) UILabel               *businessInfoDetailLabel;

@end

@implementation HSBusinessInfoHeaderView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public override method
-(void)setupView{
    [super setupView];
    self.clipsToBounds = YES;
    [self.businessInfoImageView setOpaque:YES];
    [self.businessInfoArrowView setOpaque:YES];
    [self.businessInfoTitleLabel setOpaque:YES];
    [self.businessInfoDetailLabel setOpaque:YES];
    [self.endline setOpaque:YES];
    [self.topline setOpaque:YES];
    UITapGestureRecognizer *headViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapGestureRecgnizer:)];
    [self addGestureRecognizer:headViewTap];
}

-(void)reloadData{
    [self.businessInfoImageView sd_setImageWithURL:[self.bussinessDetailModel valueForKey:@"imageUrl"]?:self.appModel.appIconUrl placeholderImage:HSDefaultPlaceHoldImage];
    [self.businessInfoTitleLabel setText:[self.bussinessDetailModel valueForKey:@"businessName"]?:self.appModel.appName];
    [self.businessInfoDetailLabel setText:@"mobile123456"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitLabelView(businessInfoTitleLabel,{
    [_businessInfoTitleLabel setFrame:CGRectMake(self.businessInfoImageView.right + BussinessDetailBorderLeft, 24, BussinessDetailWidth - self.businessInfoImageView.right - BussinessDetailBorderLeft , 16)];
    [_businessInfoTitleLabel setFont:[UIFont systemFontOfSize:EHSiz1]];
    [_businessInfoTitleLabel setTextColor:EHCor5];
    [_businessInfoTitleLabel setNumberOfLines:1];
    [_businessInfoTitleLabel setTextAlignment:NSTextAlignmentLeft];
})

KSPropertyInitImageView(businessInfoImageView,{
    [_businessInfoImageView setFrame:CGRectMake(BussinessDetailBorderLeft + 1, (self.height - 68)/2, 68, 68)];
})

KSPropertyInitImageView(businessInfoArrowView,{
    [_businessInfoArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
    [_businessInfoArrowView setImage:[UIImage imageNamed:@"icon_Arrow"]];
})

KSPropertyInitLabelView(businessInfoDetailLabel,{
    [_businessInfoDetailLabel setFrame:CGRectMake(self.businessInfoTitleLabel.left, self.businessInfoTitleLabel.bottom, self.businessInfoTitleLabel.width, 9)];
    [_businessInfoDetailLabel setNumberOfLines:1];
    [_businessInfoDetailLabel setTextColor:EHCor3];
    [_businessInfoDetailLabel setFont:EHFont5];
})

- (void)headViewTapGestureRecgnizer:(UITapGestureRecognizer *)tap{
    TBOpenURLFromTargetWithNativeParams([self.bussinessDetailModel valueForKey:@"url"]?:@"http://www.baidu.com", self, nil, nil);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system override method
-(void)layoutSubviews{
    [super layoutSubviews];
    [_businessInfoImageView setFrame:CGRectMake(BussinessDetailBorderLeft + 1, (self.height - 68)/2, 68, 68)];
    [_businessInfoArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
    [_businessInfoTitleLabel setFrame:CGRectMake(self.businessInfoImageView.right + BussinessDetailBorderLeft, 24, BussinessDetailWidth - _businessInfoImageView.right - BussinessDetailBorderLeft , 20)];
    [_businessInfoDetailLabel setFrame:CGRectMake(self.businessInfoTitleLabel.left, _businessInfoTitleLabel.bottom, _businessInfoTitleLabel.width, 20)];
}

@end
