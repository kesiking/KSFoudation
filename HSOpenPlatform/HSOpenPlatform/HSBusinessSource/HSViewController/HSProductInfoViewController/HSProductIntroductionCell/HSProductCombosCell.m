//
//  HSProductCombosCell.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductCombosCell.h"
#import "NSString+StringSize.h"

#define kXSpace 20
#define kBtnSpace 15
#define kBtnTag 100
#define kBtnNormalColor HS_FontCor4
#define kBtnSelectedColor HS_FontCor5

@interface HSProductCombosCell ()

@property (nonatomic, strong) UILabel    *titleLabel;
@property (nonatomic, strong) UILabel    *contentLabel;
@property (nonatomic, strong) NSArray    *combosArray;
@property (nonatomic, strong) UIButton   *selectedBtn;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation HSProductCombosCell

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
    CGFloat titleLabelHeight = [@"title" sizeWithFont:self.titleLabel.font Width:100].height;
    self.titleLabel.frame = CGRectMake(15, 20, 100, titleLabelHeight);
    CGFloat contentHeight = [self.contentLabel.text sizeWithFont:self.contentLabel.font Width:self.width - kXSpace*2].height;
    NSUInteger menuRowNumber = (self.combosArray.count + 2) / 3;
    self.contentLabel.frame = CGRectMake(15, 20 +titleLabelHeight +15 + (kProductMenuBtnHeight + kProductMenuBtnYSpace) * menuRowNumber, self.width - 15*2, contentHeight);
}

#pragma mark - Events Response
- (void)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self selectBtn:btn];
    [self.contentView removeAllSubviews];
    !self.productComboSelectedBlock?:self.productComboSelectedBlock(btn.tag - kBtnTag);
}

- (void)selectBtn:(UIButton *)btn {
    if (self.selectedBtn) {
        self.selectedBtn.selected = NO;
        self.selectedBtn.layer.borderColor = HS_linecor1.CGColor;
    }
    self.selectedBtn = btn;
    self.selectedBtn.selected = YES;
    self.selectedBtn.layer.borderColor = kBtnSelectedColor.CGColor;
}

- (void)setTitle:(NSString *)title Content:(NSString *)content CombosArray:(NSArray *)combosArray SelectedIndex:(NSUInteger)index{
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.selectedIndex = index;
    self.combosArray = combosArray;
}

- (void)setCombosArray:(NSArray *)combosArray {
    _combosArray = combosArray;
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < combosArray.count; i++) {
        HSProductComboModel *menuModel = combosArray[i];
        UIButton *btn = [self getBtnAtIndex:i];
        [btn setTitle:menuModel.comboType forState:UIControlStateNormal];
        if (i == self.selectedIndex) {
            [self selectBtn:btn];
        }
        [self.contentView addSubview:btn];
    }
}

#pragma mark - Getters
- (UIButton *)getBtnAtIndex:(NSUInteger)index {
    CGFloat titleLabelHeight = [@"title" sizeWithFont:self.titleLabel.font Width:100].height;
    CGSize btnSize = CGSizeMake((SCREEN_WIDTH-kXSpace*2-kBtnSpace*2)/3.0, kProductMenuBtnHeight);
    CGRect btnFrame = CGRectMake(kXSpace + (btnSize.width + kBtnSpace)*(index%3), 20 + titleLabelHeight + 15 + (kProductMenuBtnHeight + kProductMenuBtnYSpace)*(index/3), btnSize.width, btnSize.height);
    UIButton *btn = [[UIButton alloc]initWithFrame:btnFrame];
    [btn setTitleColor:kBtnNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:kBtnSelectedColor forState:UIControlStateSelected];
    btn.titleLabel.font = HS_font3;
    btn.tag = kBtnTag + index;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = HS_linecor1.CGColor;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HS_font5;
        _titleLabel.textColor = HS_FontCor2;
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
