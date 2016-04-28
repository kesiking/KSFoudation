//
//  HSAfterSaleCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/11.
//  Copyright © 2015年 孟希羲. All rights reserved.
//


#import "HSAfterSaleCollectionViewCell.h"
#import "HSApplicationModel.h"
#import "HSProductInfoModel.h"

@interface HSAfterSaleCollectionViewCell ()

@property (strong,nonatomic ) UILabel     *appNameLabel;

@property (nonatomic, strong) CALayer     *bottomLine;

@property (strong,nonatomic ) UIImageView *appIconImageView;

@end

@implementation HSAfterSaleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.appIconImageView];
        [self.contentView addSubview:self.appNameLabel];
        [self.contentView.layer addSublayer:self.bottomLine];
    }
    return self;
}

-(void)setModel:(WeAppComponentBaseItem *)model{
    _model = model;
    if (![model isKindOfClass:[HSProductInfoModel class]]) {
        return;
    }
    
    HSProductInfoModel *productModel = (HSProductInfoModel *)model;
    self.appNameLabel.text = productModel.productName;
    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithString:productModel.productLogo] placeholderImage:[UIImage imageNamed:productModel.placeholderImageStr]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView setFrame:CGRectMake((SCREEN_WIDTH/6 - 30*SCREEN_SCALE)/2, 10*SCREEN_SCALE, 30*SCREEN_SCALE, 30*SCREEN_SCALE)];
    [self.appNameLabel setFrame:CGRectMake(0, 47*SCREEN_SCALE, SCREEN_WIDTH/6, 10*SCREEN_SCALE)];
    self.bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

#pragma mark - Select
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = HS_bgcor3;
        self.appNameLabel.textColor = HS_FontCor2;
        [self.bottomLine removeFromSuperlayer];

    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        self.appNameLabel.textColor = HS_FontCor4;
        [self.layer addSublayer:self.bottomLine];
    }
}

#pragma mark - Subviews
-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]init];
        self.appNameLabel.textAlignment = NSTextAlignmentCenter;
        self.appNameLabel.font = HS_font6;
        self.appNameLabel.textColor = HS_FontCor4;
    }
    return _appNameLabel;
}

-(UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView  = [[UIImageView alloc]init];
        
    }
    return _appIconImageView;
}

-(CALayer *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = HS_linecor1.CGColor;
    }
    return _bottomLine;
}

@end
