//
//  HSHomeBusinessListCell.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeBusinessListCell.h"
#import "NSString+StringSize.h"

@interface HSHomeBusinessListCell ()

@property (nonatomic, strong) UIImageView *productImageView;

@property (nonatomic, strong) UILabel     *productNameLabel;

@property (nonatomic, strong) UILabel     *productInfoLabel;

@property (nonatomic, strong) UILabel     *productPriceLabel;

@end

@implementation HSHomeBusinessListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.productImageView];
        [self.contentView addSubview:self.productNameLabel];
        [self.contentView addSubview:self.productInfoLabel];
        [self.contentView addSubview:self.productPriceLabel];

        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = EHLinecor1.CGColor;
    }
    return self;
}

- (void)setModel:(HSProductInfoModel *)model {
    _model = model;
    
    self.productNameLabel.text = model.productName;
    self.productInfoLabel.text = model.productInfo;

    NSURL *imageUrl;
    if (model.productImage) {
        imageUrl = [NSURL URLWithString:model.productImage];
    }
    UIImage *placeholderImage;
    if (model.placeholderImageStr) {
        placeholderImage = [UIImage imageNamed:model.placeholderImageStr];
    }
    [self.productImageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage options:SDWebImageLowPriority];
    
    [self configFrame];
}

- (void)configFrame {
    CGFloat spaceX = caculateNumber(15);
    CGFloat spaceY = caculateNumber(30);
    CGFloat labelSpaceY = caculateNumber(7);
    CGFloat nameHeight = [@"name" sizeWithFont:self.productNameLabel.font Width:MAXFLOAT].height;
    CGFloat infoHeight = [@"info" sizeWithFont:self.productInfoLabel.font Width:MAXFLOAT].height;
    CGFloat priceHeight = [@"price" sizeWithFont:self.productPriceLabel.font Width:MAXFLOAT].height;

    CGRect productNameLabelFrame,productInfoLabelFrame,productPriceLabelFrame;
    if ([self isAppNameOnLeft:((HSProductInfoModel *)self.model).productName]) {
        productNameLabelFrame = CGRectMake(spaceX, spaceY, self.width/2.0 - spaceX, nameHeight);
        _productNameLabel.frame = productNameLabelFrame;
        _productNameLabel.textAlignment = NSTextAlignmentLeft;
        
        productInfoLabelFrame = CGRectMake(_productNameLabel.left, _productNameLabel.bottom + labelSpaceY, _productNameLabel.width + caculateNumber(50), infoHeight);
        _productInfoLabel.frame = productInfoLabelFrame;
        _productInfoLabel.textAlignment = NSTextAlignmentLeft;
        
        productPriceLabelFrame = CGRectMake(_productInfoLabel.left, _productInfoLabel.bottom + caculateNumber(15), _productNameLabel.width, priceHeight);
        _productPriceLabel.frame = productPriceLabelFrame;
        _productPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        productNameLabelFrame = CGRectMake(self.width / 2.0, spaceY, self.width/2.0 - spaceX, nameHeight);
        _productNameLabel.frame = productNameLabelFrame;
        _productNameLabel.textAlignment = NSTextAlignmentRight;
        
        productInfoLabelFrame = CGRectMake(_productNameLabel.left - caculateNumber(50), _productNameLabel.bottom + labelSpaceY, _productNameLabel.width + caculateNumber(50), infoHeight);
        _productInfoLabel.frame = productInfoLabelFrame;
        _productInfoLabel.textAlignment = NSTextAlignmentRight;
        
        productPriceLabelFrame = CGRectMake(_productNameLabel.left, _productInfoLabel.bottom + caculateNumber(15), _productNameLabel.width, priceHeight);
        _productPriceLabel.frame = productPriceLabelFrame;
        _productPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    
    self.productImageView.frame = self.bounds;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc]init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc]init];
        _productNameLabel.font = HS_font2;
        _productNameLabel.textColor = HS_FontCor2;
        _productNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _productNameLabel;
}

- (UILabel *)productInfoLabel {
    if (!_productInfoLabel) {
        _productInfoLabel = [[UILabel alloc]init];
        _productInfoLabel.font = HS_font5;
        _productInfoLabel.textColor = HS_FontCor3;
        _productInfoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _productInfoLabel;
}

- (UILabel *)productPriceLabel {
    if (!_productPriceLabel) {
        _productPriceLabel = [[UILabel alloc]init];
        _productPriceLabel.font = HS_font1;
        _productPriceLabel.textColor = HS_FontCor5;
        _productPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _productPriceLabel;
}

- (BOOL)isAppNameOnLeft:(NSString *)appName {
    NSArray *appNameLeftArray = @[@"和路由",@"咪咕"];
    return [appNameLeftArray containsObject:appName]?YES:NO;
}

@end
