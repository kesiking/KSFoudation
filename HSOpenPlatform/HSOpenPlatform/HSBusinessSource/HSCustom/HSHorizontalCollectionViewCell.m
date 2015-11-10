//
//  HSHorizontalCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHorizontalCollectionViewCell.h"

@interface HSHorizontalCollectionViewCell ()

@property (strong,nonatomic) UIImageView *appIconImageView;

@property (strong,nonatomic) UILabel *appNameLabel;

@end

@implementation HSHorizontalCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.appIconImageView = [[UIImageView alloc]init];
        //self.appIconImageView.image =
        [self.contentView addSubview:self.appIconImageView];
        
        self.appNameLabel = [[UILabel alloc]init];
        self.appNameLabel.textAlignment = NSTextAlignmentCenter;
        self.appNameLabel.font = EHFont2;
        self.appNameLabel.textColor = EHCor5;
        [self.contentView addSubview:self.appNameLabel];
        
        UIView *lineViewHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        [lineViewHorizontal setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewHorizontal];
        
        UIView *lineViewVertical = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width, 0, 0.5, frame.size.height)];
        [lineViewVertical setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewVertical];
        
    }
    return self;
}

-(void)setAppModel:(HSApplicationModel *)appModel{
    _appModel = appModel;
    self.appNameLabel.text = appModel.appName;
    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithString:appModel.appIconUrl] placeholderImage:[UIImage imageNamed:appModel.placeholderImageStr]];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView setFrame:CGRectMake(15*SCREEN_SCALE, 10*SCREEN_SCALE, 30*SCREEN_SCALE, 30*SCREEN_SCALE)];
    [self.appNameLabel setFrame:CGRectMake(0, 50*SCREEN_SCALE, self.contentView.width, 10*SCREEN_SCALE)];
}

-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]init];
    }
    return _appNameLabel;
}

-(UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView  = [[UIImageView alloc]init];
    }
    return _appIconImageView;
}

@end
