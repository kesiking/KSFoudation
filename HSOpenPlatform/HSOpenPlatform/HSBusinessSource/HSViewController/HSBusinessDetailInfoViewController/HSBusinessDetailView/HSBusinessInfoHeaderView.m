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

-(void)dealloc{
    
}

-(void)reloadData{
    [self.businessInfoImageView sd_setImageWithURL:[NSURL URLWithString:self.bussinessDetailModel.productLogo] placeholderImage:HSDefaultPlaceHoldImage];
    [self.businessInfoTitleLabel setText:self.deviceModel.productName?:self.bussinessDetailModel.productName];
    [self.businessInfoDetailLabel setText:self.bussinessDetailModel.deviceModel];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitLabelView(businessInfoTitleLabel,{
    [_businessInfoTitleLabel setFrame:CGRectMake(self.businessInfoImageView.right + BussinessDetailBorderLeft, 24, BussinessDetailWidth - self.businessInfoImageView.right - BussinessDetailBorderLeft , 16)];
    [_businessInfoTitleLabel setFont:[UIFont systemFontOfSize:HS_fontsiz1]];
    [_businessInfoTitleLabel setTextColor:HS_FontCor2];
    [_businessInfoTitleLabel setNumberOfLines:1];
    [_businessInfoTitleLabel setTextAlignment:NSTextAlignmentLeft];
})

KSPropertyInitImageView(businessInfoImageView,{
    [_businessInfoImageView setFrame:CGRectMake(BussinessDetailBorderLeft + 5, (self.height - 60)/2, 60, 60)];
})

KSPropertyInitImageView(businessInfoArrowView,{
    [_businessInfoArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
    [_businessInfoArrowView setImage:[UIImage imageNamed:@"icon_Arrow"]];
})

KSPropertyInitLabelView(businessInfoDetailLabel,{
    [_businessInfoDetailLabel setFrame:CGRectMake(self.businessInfoTitleLabel.left, self.businessInfoTitleLabel.bottom, self.businessInfoTitleLabel.width, 9)];
    [_businessInfoDetailLabel setNumberOfLines:1];
    [_businessInfoDetailLabel setTextColor:HS_FontCor4];
    [_businessInfoDetailLabel setFont:HS_font5];
})

- (void)headViewTapGestureRecgnizer:(UITapGestureRecognizer *)tap{
    TBOpenURLFromTargetWithNativeParams(self.deviceModel.platUrl, self, nil, nil);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system override method
-(void)layoutSubviews{
    [super layoutSubviews];
    [_businessInfoImageView setFrame:CGRectMake(BussinessDetailBorderLeft + 5, (self.height - 60)/2, 60, 60)];
    [_businessInfoArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
    [_businessInfoTitleLabel setFrame:CGRectMake(self.businessInfoImageView.right + BussinessDetailBorderLeft, 24, BussinessDetailWidth - _businessInfoImageView.right - BussinessDetailBorderLeft , 20)];
    [_businessInfoDetailLabel setFrame:CGRectMake(self.businessInfoTitleLabel.left, _businessInfoTitleLabel.bottom, _businessInfoTitleLabel.width, 20)];
}

@end
