//
//  HSServicLocationCalloutView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSServicLocationCalloutView.h"

static NSString *const kHS_BgAddress_ImageName        = @"bg_address01";
static NSString *const kHS_ChinaMobile_ImageName        = @"icon_ChinaMobile";
static NSString *const kHS_Navigation_ImageName        = @"icon_navigation";


@interface HSServicLocationCalloutView ()

@property (nonatomic, strong) UIImageView  *bgImgView;

@property (nonatomic, strong) UILabel      *nameLabel;

@property (nonatomic, strong) UILabel      *distanceLabel;

@property (nonatomic, strong) UIImageView  *chinaMobileImv;

@property (nonatomic, strong) UILabel      *addressLabel;

@property (nonatomic, strong) UIButton     *navigateButton;

@property (nonatomic, strong) UILabel      *navigateLabel;

@property (nonatomic, strong) UIImageView  *navigateImv;

@property (nonatomic, strong)CALayer       *lineLayer;

@end

@implementation HSServicLocationCalloutView

- (void)setupView {
    [super setupView];
    [self addSubview:self.bgImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.chinaMobileImv];
    [self addSubview:self.addressLabel];
    [self addSubview:self.navigateButton];
    [self.layer addSublayer:self.lineLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImgView.frame = self.bounds;
    self.nameLabel.frame = CGRectMake(caculateNumber(12+30+8), caculateNumber(14), caculateNumber(82.5), caculateNumber(13));
    self.distanceLabel.frame = CGRectMake(self.width - caculateNumber(5+50+12+50), caculateNumber(14), caculateNumber(50), caculateNumber(13));
    self.chinaMobileImv.frame = CGRectMake(caculateNumber(12), caculateNumber(5+10), caculateNumber(30), caculateNumber(30));
    self.addressLabel.frame = CGRectMake(caculateNumber(12+30+8), caculateNumber(14+13+6), self.width - caculateNumber(12+30+8+50+12), caculateNumber(13));
    self.navigateButton.frame = CGRectMake(self.width - caculateNumber(5+50), 5, caculateNumber(50), caculateNumber(50));
    self.navigateImv.frame = CGRectMake(self.navigateButton.width - caculateNumber(20+10), caculateNumber(12), caculateNumber(10), caculateNumber(10));
    self.navigateLabel.frame = CGRectMake(self.navigateButton.width - caculateNumber(50), caculateNumber(12+10+6), caculateNumber(50), caculateNumber(50-12-10-6-9));
    self.lineLayer.frame = CGRectMake(self.width - caculateNumber(5+50), caculateNumber(5+6), 0.5, caculateNumber(50-6-6));
}

#pragma mark - Events Response
- (void)navigateButtonClick:(id)sender {
    !self.navigateButtonClickBlock?:self.navigateButtonClickBlock();
}

#pragma mark - Setters
- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setDistance:(NSInteger)distance {
    self.distanceLabel.text = [self transformDistance:distance];
}

- (void)setAddress:(NSString *)address {
    self.addressLabel.text = address;
}

- (NSString *)transformDistance:(NSInteger)distance {
    if (distance/1000 == 0) {
        return [NSString stringWithFormat:@"%ld米",distance];
    }
    else {
        return [NSString stringWithFormat:@"%.1f千米",distance/1000.0];
    }
}

#pragma mark - SubViews
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:kHS_BgAddress_ImageName];
    }
    return _bgImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = EHFont3;
        _nameLabel.textColor = EHCor5;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.font = EHFont3;
        _distanceLabel.textColor = EHCor5;
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}

- (UIImageView *)chinaMobileImv {
    if (!_chinaMobileImv) {
        _chinaMobileImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kHS_ChinaMobile_ImageName]];
    }
    return _chinaMobileImv;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = EHFont3;
        _addressLabel.textColor = EHCor6;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (UIButton *)navigateButton {
    if (!_navigateButton) {
        _navigateButton = [[UIButton alloc]init];
        [_navigateButton addTarget:self action:@selector(navigateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_navigateButton addSubview:self.navigateImv];
        [_navigateButton addSubview:self.navigateLabel];
    }
    return _navigateButton;
}

- (UIImageView *)navigateImv {
    if (!_navigateImv) {
        _navigateImv = [[UIImageView alloc]init];
        _navigateImv.image = [UIImage imageNamed:kHS_Navigation_ImageName];
    }
    return _navigateImv;
}

- (UILabel *)navigateLabel {
    if (!_navigateLabel) {
        _navigateLabel = [[UILabel alloc]init];
        _navigateLabel.font = EHFont3;
        _navigateLabel.textColor = EHCor4;
        _navigateLabel.textAlignment = NSTextAlignmentCenter;
        _navigateLabel.text = @"导航";
    }
    return _navigateLabel;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = EHLinecor1.CGColor;
    }
    return _lineLayer;
}

@end
