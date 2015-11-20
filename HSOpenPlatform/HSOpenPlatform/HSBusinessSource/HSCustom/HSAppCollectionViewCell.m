//
//  HSAppCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/17.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAppCollectionViewCell.h"
#import "HSApplicationModel.h"

@interface HSAppCollectionViewCell ()

@property (strong,nonatomic) UIImageView *appIconImageView;

@property (strong,nonatomic) UILabel *appNameLabel;

@property (nonatomic, strong) CALayer     *rightLine;

@property (nonatomic, strong) CALayer     *bottomLine;

@end

@implementation HSAppCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.appIconImageView];
        [self.contentView addSubview:self.appNameLabel];
        [self.layer addSublayer:self.rightLine];
        [self.contentView.layer addSublayer:self.bottomLine];
        
    }
    return self;
}

-(void)setModel:(WeAppComponentBaseItem *)model{
    [super setModel:model];
    if (![model isKindOfClass:[HSApplicationModel class]]) {
        return;
    }
    //_model = model;
    HSApplicationModel *appModel = (HSApplicationModel *)model;
    self.appNameLabel.text = appModel.appName;
    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithString:appModel.appIconUrl] placeholderImage:[UIImage imageNamed:appModel.placeholderImageStr]];
    //self.layer.borderWidth = 1;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView setFrame:CGRectMake(29.5*SCREEN_SCALE, 27*SCREEN_SCALE, 67*SCREEN_SCALE, 67*SCREEN_SCALE)];
    [self.appNameLabel setFrame:CGRectMake(0, 109*SCREEN_SCALE, self.contentView.width, 15*SCREEN_SCALE)];
    self.rightLine.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]init];
        self.appNameLabel.textAlignment = NSTextAlignmentCenter;
        self.appNameLabel.font = EHFont2;
        self.appNameLabel.textColor = EHCor5;
    }
    return _appNameLabel;
}

-(UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView  = [[UIImageView alloc]init];
        
    }
    return _appIconImageView;
}

-(CALayer *)rightLine{
    if (!_rightLine) {
        _rightLine = [CALayer layer];
        _rightLine.backgroundColor = EHLinecor1.CGColor;
    }
    return _rightLine;
}

-(CALayer *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = EHLinecor1.CGColor;
    }
    return _bottomLine;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
