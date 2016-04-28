//
//  HSMyInfoAppCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/12.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMyInfoAppCollectionViewCell.h"
#import "HSApplicationModel.h"
#import "Masonry.h"
#import "HSDeviceModel.h"
//#import "HSDeviceInfoModel.h"


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
    if (![model isKindOfClass:[HSDeviceModel class]]) {
        return;
    }
    //_model = model;
    HSDeviceModel *deviceModel = (HSDeviceModel *)model;
    self.appNameLabel.text = deviceModel.productName;
    
    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithString:deviceModel.productLogo] placeholderImage:[UIImage imageNamed:deviceModel.placeholderImageStr]];
    self.deviceNoLabel.text = [NSString stringWithFormat:@"%lu个设备",(unsigned long)deviceModel.deviceData.count];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15*SCREEN_SCALE);
        make.left.equalTo(self.contentView.mas_left).with.offset(15*SCREEN_SCALE);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appIconImageView.mas_right).with.offset(15*SCREEN_SCALE);
        make.centerY.equalTo(self.appIconImageView.mas_centerY);
    }];
    [self.deviceNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appNameLabel.mas_right).with.offset(10*SCREEN_SCALE);
        make.centerY.equalTo(self.appIconImageView.mas_centerY);
    }];

     
//    [self.appIconImageView setFrame:CGRectMake((SCREEN_WIDTH/3-67*SCREEN_SCALE)/2, 15*SCREEN_SCALE, 67*SCREEN_SCALE, 67*SCREEN_SCALE)];
//    [self.appNameLabel setFrame:CGRectMake(0, 93*SCREEN_SCALE, self.contentView.width, 15*SCREEN_SCALE)];
//    [self.deviceNoLabel setFrame:CGRectMake((SCREEN_WIDTH/3 - 65*SCREEN_SCALE)/2, 114*SCREEN_SCALE, 65*SCREEN_SCALE, 22*SCREEN_SCALE)];
}


-(UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView  = [[UIImageView alloc]init];
        _appIconImageView.layer.cornerRadius = 20;
        _appIconImageView.layer.masksToBounds = YES;
    }
    return _appIconImageView;
}

-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.font = EHFont5;
        _appNameLabel.textColor = EHCor5;
        [_appNameLabel sizeToFit];
    }
    return _appNameLabel;
}

-(UILabel *)deviceNoLabel{
    if (!_deviceNoLabel) {
        _deviceNoLabel = [[UILabel alloc]init];
        _deviceNoLabel.textAlignment = NSTextAlignmentCenter;
        _deviceNoLabel.font = EHFont5;
        _deviceNoLabel.textColor = EHCor5;
//        _deviceNoLabel.textColor = EHCor4;
        _deviceNoLabel.layer.masksToBounds=YES;
        [_deviceNoLabel sizeToFit];
//        _deviceNoLabel.layer.cornerRadius = 3;
//        _deviceNoLabel.backgroundColor = RGB(0x23, 0x74, 0xfa);
        
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
