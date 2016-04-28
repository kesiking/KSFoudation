//
//  HSProductIntroductionCell.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductIntroductionCell.h"
#import "NSString+StringSize.h"

@interface HSProductIntroductionCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation HSProductIntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleLabelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font Width:100].height;
    self.titleLabel.frame = CGRectMake(15, 15, 100, titleLabelHeight);
    CGFloat contentHeight = [self.contentLabel.text sizeWithFont:self.contentLabel.font Width:self.width - 30].height;
    self.contentLabel.frame = CGRectMake(15, 30 + titleLabelHeight, self.width - 30, contentHeight);
}

- (void)setTitle:(NSString *)title Content:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HS_FontCor2;
        _titleLabel.font = HS_font5;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HS_FontCor4;
        _contentLabel.font = HS_font5;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
