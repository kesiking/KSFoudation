//
//  HSHomeAccountInfoButton.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/23.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeAccountInfoButton.h"

@interface HSHomeAccountInfoButton ()

@end

@implementation HSHomeAccountInfoButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.imv];
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imvHeight = caculateNumber(26);
    self.imv.frame = CGRectMake(caculateNumber(15), (self.height - imvHeight) / 2.0, imvHeight, imvHeight);
    
    CGFloat labelX = self.imv.right + caculateNumber(10);
    self.nameLabel.frame = CGRectMake(labelX, caculateNumber(16), self.width - labelX, caculateNumber(11));
    
    self.infoLabel.frame = CGRectMake(labelX, self.nameLabel.bottom + caculateNumber(8), self.width - labelX, caculateNumber(11));
}

- (UIImageView *)imv {
    if (!_imv) {
        _imv = [[UIImageView alloc]init];
    }
    return _imv;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = EHCor3;
        _nameLabel.font = EHFont5;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = EHCor5;
        _infoLabel.font = [UIFont boldSystemFontOfSize:EHSiz5];
    }
    return _infoLabel;
}

@end
