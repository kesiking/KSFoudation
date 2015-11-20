//
//  HSMyInfoAppCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMyInfoAppCollectionViewCell.h"
#import "HSApplicationModel.h"

@interface HSMyInfoAppCollectionViewCell ()

@property (strong,nonatomic) UIImageView *appIconImageView;

@property (strong,nonatomic) UILabel *appNameLabel;

@property (strong,nonatomic) UILabel *deviceNoLabel;

@end

@implementation HSMyInfoAppCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self.contentView addSubview:self.appIconImageView];
        [self.contentView addSubview:self.appNameLabel];
        [self.contentView addSubview:self.deviceNoLabel];
        
        UIView *lineViewHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        [lineViewHorizontal setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewHorizontal];
        
        UIView *lineViewVertical = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width, 0, 0.5, frame.size.height)];
        [lineViewVertical setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewVertical];
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
    self.deviceNoLabel.text = @"5";
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView setFrame:CGRectMake((SCREEN_WIDTH/3-67*SCREEN_SCALE)/2, 15*SCREEN_SCALE, 67*SCREEN_SCALE, 67*SCREEN_SCALE)];
    [self.appNameLabel setFrame:CGRectMake(0, 93*SCREEN_SCALE, self.contentView.width, 15*SCREEN_SCALE)];
    [self.deviceNoLabel setFrame:CGRectMake((SCREEN_WIDTH/3 - 65*SCREEN_SCALE)/2, 114*SCREEN_SCALE, 65*SCREEN_SCALE, 22*SCREEN_SCALE)];
}


-(UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView  = [[UIImageView alloc]init];
    }
    return _appIconImageView;
}

-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.font = EHFont2;
        _appNameLabel.textColor = EHCor5;
    }
    return _appNameLabel;
}

-(UILabel *)deviceNoLabel{
    if (!_deviceNoLabel) {
        _deviceNoLabel = [[UILabel alloc]init];
        _deviceNoLabel.textAlignment = NSTextAlignmentCenter;
        _deviceNoLabel.font = EHFont2;
        _deviceNoLabel.textColor = EHCor5;
        _deviceNoLabel.layer.masksToBounds=YES;
        _deviceNoLabel.layer.cornerRadius = 3;
        _deviceNoLabel.backgroundColor = RGB(0x23, 0x74, 0xfa);
        
    }
    return _deviceNoLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
