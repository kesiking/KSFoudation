//
//  HSBussinessAfterSaleLInkView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBussinessAfterSaleLInkView.h"
#import "HSProductInfoModel.h"

@interface HSBussinessAfterSaleLInkView()

@property (nonatomic, strong) UIButton               *businessAfterSaleLinkBtn;

@property (nonatomic, strong) UIImageView            *businessAfterSaleArrowView;

@end

@implementation HSBussinessAfterSaleLInkView

-(void)setupView{
    [super setupView];
    [self.businessAfterSaleLinkBtn setOpaque:YES];
    [self.businessAfterSaleArrowView setOpaque:YES];
    [self.endline setOpaque:YES];
    [self.topline setOpaque:YES];
}

-(void)dealloc{
    
}

-(void)reloadData{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - combo info related view
KSPropertyInitButtonView(businessAfterSaleLinkBtn,{
    [_businessAfterSaleLinkBtn setFrame:CGRectMake(0, 0, self.width, self.height)];
    [_businessAfterSaleLinkBtn setTitle:@"售后服务网点" forState:UIControlStateNormal];
    [_businessAfterSaleLinkBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:EHSiz2]];
    [_businessAfterSaleLinkBtn setTitleColor:EHCor5 forState:UIControlStateNormal];
    [_businessAfterSaleLinkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_businessAfterSaleLinkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, BussinessDetailBorderLeft , 0, 0)];
})

KSPropertyInitImageView(businessAfterSaleArrowView,{
    [_businessAfterSaleArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
    [_businessAfterSaleArrowView setImage:[UIImage imageNamed:@"icon_Arrow"]];
})

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - clicked action method
-(void)businessAfterSaleLinkBtnClicked:(id)sender{
    HSProductInfoModel* productModel = [HSProductInfoModel new];
    productModel.productId = self.deviceModel.productId?:self.bussinessDetailModel.productId;
    productModel.productLogo = self.deviceModel.productLogo?:self.bussinessDetailModel.productLogo;
    productModel.productName = self.deviceModel.productName?:self.bussinessDetailModel.productName;
    TBOpenURLFromTargetWithNativeParams(@"HSAfterSaleForAppViewController", self, nil, @{@"productModel":productModel});
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - system override method
-(void)layoutSubviews{
    [super layoutSubviews];
    [_businessAfterSaleLinkBtn setFrame:self.bounds];
    [_businessAfterSaleArrowView setFrame:CGRectMake(self.width - 9 - BussinessDetailBorderRight, (self.height - 14)/2, 9, 14)];
}

@end
