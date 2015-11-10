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

@end

@implementation HSHomeServicLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.positionImv];
        [self.contentView addSubview:self.phoneImv];
        [self.contentView addSubview:self.arrorImv];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView.layer addSublayer:self.lineLayer];
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
    if (distance/1000 == 0) {
        return [NSString stringWithFormat:@"%ld米",distance];
    }
    else {
        return [NSString stringWithFormat:@"%.1f千米",distance/1000.0];
    }
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.positionImv.frame = CGRectMake(caculateNumber(25), caculateNumber(14), caculateNumber(14), caculateNumber(14));
    self.phoneImv.frame = CGRectMake(caculateNumber(25), caculateNumber(60 + 15), caculateNumber(14), caculateNumber(14));
    self.arrorImv.frame = CGRectMake(self.width - caculateNumber(12 + 9), caculateNumber(47/2.0), caculateNumber(9), caculateNumber(14));
    self.lineLayer.frame = CGRectMake(caculateNumber(25), caculateNumber(60), self.width - caculateNumber(25), 0.5);
    
    self.nameLabel.frame = CGRectMake(self.positionImv.right + caculateNumber(10), caculateNumber(14), self.width - self.positionImv.width - self.arrorImv.width - caculateNumber(10 + 12), caculateNumber(14));
    self.addressLabel.frame = CGRectMake(caculateNumber(25), self.positionImv.bottom + caculateNumber(8), self.width - caculateNumber(25) - caculateNumber(12) - self.arrorImv.width, caculateNumber(12));
    self.phoneLabel.frame = CGRectMake(self.phoneImv.right + caculateNumber(10), caculateNumber(60 + 16), caculateNumber(270) - self.phoneImv.right - caculateNumber(10), caculateNumber(12));
    self.distanceLabel.frame = CGRectMake(caculateNumber(270), caculateNumber(60 + 16), self.width - caculateNumber(270), caculateNumber(12));
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
        _nameLabel.textColor = EHCor5;
        _nameLabel.font = EHFont2;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _addressLabel.textColor = EHCor4;
        _addressLabel.font = EHFont5;
    }
    return _addressLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _phoneLabel.textColor = EHCor5;
        _phoneLabel.font = EHFont5;
    }
    return _phoneLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _distanceLabel.textColor = EHCor5;
        _distanceLabel.font = EHFont5;
    }
    return _distanceLabel;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = EHLinecor1.CGColor;
    }
    return _lineLayer;
}

@end
