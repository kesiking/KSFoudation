//
//  HSServicLocationCalloutView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSServicLocationCalloutView.h"

static NSString *const kHS_BgAddress_ImageName        = @"bg-弹出框";
static NSString *const kHS_ChinaMobile_ImageName      = @"icon_ChinaMobile";
static NSString *const kHS_Navigation_ImageName       = @"icon_导航";


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
    self.nameLabel.frame = CGRectMake(3+10+30+7, 2+10, 82.5+10, 13);
    self.distanceLabel.frame = CGRectMake(self.width - (3+50+10+50), 2+10, 50, 13);
    self.chinaMobileImv.frame = CGRectMake(13, 2+10, 30, 30);
    self.addressLabel.frame = CGRectMake(12+30+8, 2+10+13+7, self.width - (13+30+7+50+10+3), 13);
    self.navigateButton.frame = CGRectMake(self.width - (3+50), 2, 50, 50);
    self.navigateImv.frame = CGRectMake((self.navigateButton.width - 15)/2.0, 10, 15, 15);
    self.navigateLabel.frame = CGRectMake(self.navigateButton.width - 50, 10+15+2, 50, 50-(10+15+2)-10);
    self.lineLayer.frame = CGRectMake(self.width - (3+50), 2+9, 0.5, 31);
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
        _nameLabel.font = HS_font3;
        _nameLabel.textColor = HS_FontCor2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.font = HS_font3;
        _distanceLabel.textColor = HS_FontCor2;
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
        _addressLabel.font = HS_font5;
        _addressLabel.textColor = HS_FontCor4;
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
        _navigateLabel.font = HS_font3;
        _navigateLabel.textColor = HS_FontCor2;
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
