//
//  HSHomeBusinessListCell.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeBusinessListCell.h"

@interface HSHomeBusinessListCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel     *nameLabel;

@property (nonatomic, strong) CALayer     *rightLine;

@property (nonatomic, strong) CALayer     *bottomLine;

@end

@implementation HSHomeBusinessListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView.layer addSublayer:self.rightLine];
        [self.contentView.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (void)setupCollectionItem:(HSApplicationModel *)item {
    self.nameLabel.text = item.appName;
    
    NSURL *imageUrl = [NSURL URLWithString:item.appIconUrl];
    UIImage *placeholderImage = [UIImage imageNamed:item.placeholderImageStr];
    [self.iconImageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageWidth = caculateNumber(67);
    self.iconImageView.frame = CGRectMake((self.width - imageWidth)/2.0, caculateNumber(15), imageWidth, imageWidth);
    self.nameLabel.frame = CGRectMake(0, caculateNumber(15+13)+imageWidth, self.width, caculateNumber(14));
    self.rightLine.frame = CGRectMake(self.width, 0, 0.5, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = EHFont2;
        _nameLabel.textColor = EHCor5;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (CALayer *)rightLine {
    if (!_rightLine) {
        _rightLine = [CALayer layer];
        _rightLine.backgroundColor = EHLinecor1.CGColor;
    }
    return _rightLine;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = EHLinecor1.CGColor;
    }
    return _bottomLine;
}

- (void)addSeparatorLines {
    CGRect frame1 = CGRectMake(caculateNumber(215), 0, 0.5, self.height);
    CGRect frame2 = CGRectMake(caculateNumber(215), self.height/2.0, self.width - caculateNumber(215), 0.5);
    
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    [muArr addObject:[NSValue valueWithCGRect:frame1]];
    [muArr addObject:[NSValue valueWithCGRect:frame2]];
    
    for (NSInteger i = 0; i<2; i++) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = EHLinecor1.CGColor;
        layer.frame = [muArr[i] CGRectValue];
        [self.layer addSublayer:layer];
    }
}

@end
