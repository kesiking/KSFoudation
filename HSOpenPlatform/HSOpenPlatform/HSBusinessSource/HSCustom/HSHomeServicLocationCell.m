//
//  HSHomeServicLocationCell.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeServicLocationCell.h"

static NSString *const kHSPositionImageName     = @"icon_Businesshall_Position";
static NSString *const kHSPhoneImageName        = @"icon_Businesshall_Phone";
static NSString *const kHSArrorImageName        = @"icon_Arrow";


@interface HSHomeServicLocationCell ()

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *addressLabel;

@property (nonatomic, strong)UILabel *phoneLabel;

@property (nonatomic, strong)UILabel *distanceLabel;

@property (nonatomic, strong)UIImageView *positionImv;

@property (nonatomic, strong)UIImageView *phoneImv;

@property (nonatomic, strong)UIImageView *arrorImv;

@property (nonatomic, strong)CALayer *lineLayer;

@property (nonatomic, strong)CALayer *bottomBgLayer;

@property (nonatomic, strong)CALayer *bottomVLineLayer;

@end

@implementation HSHomeServicLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.layer addSublayer:self.bottomBgLayer];
        [self.contentView.layer addSublayer:self.bottomVLineLayer];
        [self.contentView.layer addSublayer:self.lineLayer];

        [self.contentView addSubview:self.positionImv];
        [self.contentView addSubview:self.phoneImv];
        [self.contentView addSubview:self.arrorImv];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.distanceLabel];
    }
    return self;
}

- (void)setModel:(HSMapPoiModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    self.phoneLabel.text = model.tel;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离：%@",[self transformDistance:model.distance]];
}

- (NSString *)transformDistance:(NSInteger)distance {
    if (distance == 0) {
        return @"";
    }
    else if (distance/1000 == 0) {
        return [NSString stringWithFormat:@"%ld米",distance];
    }
    else {
        return [NSString stringWithFormat:@"%.1f千米",distance/1000.0];
    }
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomBgLayer.frame = CGRectMake(0, self.height - caculateNumber(44), self.width, caculateNumber(44));
    self.bottomVLineLayer.frame = CGRectMake(self.width/2.0, self.height - caculateNumber(44), 0.5, caculateNumber(44));
    self.lineLayer.frame = CGRectMake(0, self.height - caculateNumber(44), self.width, 0.5);

    self.positionImv.frame = CGRectMake(caculateNumber(15), caculateNumber(15), caculateNumber(14), caculateNumber(14));
    self.phoneImv.frame = CGRectMake(caculateNumber(15), self.height - caculateNumber(14 + 15), caculateNumber(14), caculateNumber(14));
    self.arrorImv.frame = CGRectMake(self.width - caculateNumber(15 + 9), (self.height-caculateNumber(44+14))/2.0, caculateNumber(9), caculateNumber(14));
    
    self.nameLabel.frame = CGRectMake(self.positionImv.right + caculateNumber(10), caculateNumber(15), self.width - self.positionImv.width - self.arrorImv.width - caculateNumber(15+10+15), caculateNumber(15));
    self.addressLabel.frame = CGRectMake(caculateNumber(15), self.nameLabel.bottom + caculateNumber(10), self.width - caculateNumber(15+15) - self.arrorImv.width, caculateNumber(12));
    self.phoneLabel.frame = CGRectMake(self.phoneImv.right + caculateNumber(10), self.phoneImv.top, caculateNumber(270) - self.phoneImv.right - caculateNumber(10), caculateNumber(14));
    self.distanceLabel.frame = CGRectMake(self.width/2.0+caculateNumber(85), self.phoneImv.top, self.width/2.0 - caculateNumber(85), caculateNumber(14));
}

#pragma mark - Subviews
- (UIImageView *)positionImv {
    if (!_positionImv) {
        _positionImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kHSPositionImageName]];
    }
    return _positionImv;
}

- (UIImageView *)phoneImv {
    if (!_phoneImv) {
        _phoneImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kHSPhoneImageName]];
    }
    return _phoneImv;
}

- (UIImageView *)arrorImv {
    if (!_arrorImv) {
        _arrorImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kHSArrorImageName]];
    }
    return _arrorImv;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.textColor = HS_FontCor2;
        _nameLabel.font = HS_font3;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressLabel.textColor = HS_FontCor4;
        _addressLabel.font = HS_font4;
    }
    return _addressLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _phoneLabel.textColor = HS_FontCor3;
        _phoneLabel.font = HS_font4;
    }
    return _phoneLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _distanceLabel.textColor = HS_FontCor3;
        _distanceLabel.font = HS_font4;
    }
    return _distanceLabel;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = HS_linecor1.CGColor;
    }
    return _lineLayer;
}

- (CALayer *)bottomBgLayer {
    if (!_bottomBgLayer) {
        _bottomBgLayer = [CALayer layer];
        _bottomBgLayer.backgroundColor = HS_bgcor2.CGColor;
    }
    return _bottomBgLayer;
}

- (CALayer *)bottomVLineLayer {
    if (!_bottomVLineLayer) {
        _bottomVLineLayer = [CALayer layer];
        _bottomVLineLayer.backgroundColor = HS_linecor1.CGColor;
    }
    return _bottomVLineLayer;
}

@end
