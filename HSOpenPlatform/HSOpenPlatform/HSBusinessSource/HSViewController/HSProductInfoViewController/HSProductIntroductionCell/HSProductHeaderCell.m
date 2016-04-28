//
//  HSProductHeaderCell.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductHeaderCell.h"
#import "NSString+StringSize.h"

@interface HSProductHeaderCell ()

@property (nonatomic, strong) UIImageView *iconImv;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NSDictionary *iconNameDictionary;

@end

@implementation HSProductHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImv];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImv.frame = CGRectMake(15, 15, 40, 40);
    
    CGFloat nameLabelWidth   = self.width - self.iconImv.right - 10 - 15 - 60;
    CGFloat nameLabelHeight  = [self.nameLabel.text sizeWithFont:self.nameLabel.font Width:nameLabelWidth].height;
    CGFloat titleLabelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font Width:nameLabelWidth].height;
    CGFloat nameLabelY       = (self.iconImv.height - nameLabelHeight - titleLabelHeight - 5)/2.0 + self.iconImv.top;
    CGFloat titleLabelY      = nameLabelY + nameLabelHeight + 5;
    
    self.nameLabel.frame = CGRectMake(self.iconImv.right + 10, nameLabelY, nameLabelWidth, nameLabelHeight);
    self.titleLabel.frame = CGRectMake(self.iconImv.right + 10, titleLabelY, nameLabelWidth, titleLabelHeight);
    self.priceLabel.frame = CGRectMake(self.width - 15 - 60, 25, 60, 20);
}

- (void)configWithName:(NSString *)name title:(NSString *)title iconUrl:(NSString *)iconUrl price:(NSString *)price {
    UIImage *placeholderImage;
    if ([self.iconNameDictionary objectForKey:name]) {
        placeholderImage = [UIImage imageNamed:[self.iconNameDictionary objectForKey:name]];
    }
    [self.iconImv sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:placeholderImage];
    self.nameLabel.text = name;
    self.titleLabel.text = title;
    
    if (!price) {
        self.priceLabel.hidden = YES;
    }
    else {
        self.priceLabel.hidden = NO;
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName : HS_font2, NSForegroundColorAttributeName: HS_FontCor6}];
        [priceStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" 元" attributes:@{NSFontAttributeName : HS_font5, NSForegroundColorAttributeName: HS_FontCor2}]];
        self.priceLabel.attributedText = priceStr;
    }
}

#pragma mark - UI
- (UIImageView *)iconImv {
    if (!_iconImv) {
        _iconImv = [[UIImageView alloc]init];
    }
    return _iconImv;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = HS_FontCor2;
        _nameLabel.font = HS_font2;
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HS_FontCor3;
        _titleLabel.font = HS_font5;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (NSDictionary *)iconNameDictionary {
    if (!_iconNameDictionary) {
        _iconNameDictionary = @{@"和路由":@"icon_和路由_80",
                                @"和目":@"icon_和目_80",
                                @"路尚":@"icon_路尚_80",
                                @"咪咕":@"icon_咪咕_80",
                                @"魔百盒":@"icon_魔百合_80",
                                @"找他":@"icon_找他_80px",
                                @"甘肃移动-掌上营业":@"icon_甘肃移动-掌上营业厅_80",
                                };
    }
    return _iconNameDictionary;
}

@end
