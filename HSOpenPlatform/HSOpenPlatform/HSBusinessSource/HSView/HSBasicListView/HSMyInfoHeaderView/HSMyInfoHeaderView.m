//
//  HSMyInfoHeaderView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMyInfoHeaderView.h"
#import "Masonry.h"


#define kSubViewTag   100
//#define kBtnSpace 8
//#define kBtnWidth 24
//#define kBtnHeight 23

@interface HSMyInfoHeaderView()

@property (strong,nonatomic) UILabel *userPhoneLabel;
@property (strong,nonatomic) UILabel *userPackageLabel;
@property (strong,nonatomic) UILabel *backgroundLabel;
//@property (strong,nonatomic) UIButton *starBtn;
@property (strong, nonatomic) UIImageView *backgroundImgView;

@end

@implementation HSMyInfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundImgView = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:self.backgroundImgView];
//        for (NSInteger i = 1; i < 6; i++){
//            UIButton *starBtn = [[UIButton alloc]initWithFrame:CGRectZero];
//            starBtn.tag = kSubViewTag +i;
//            NSInteger btnTag = starBtn.tag;
//            for (btnTag = kSubViewTag +1; btnTag < [self.accountStarLevel integerValue]+kSubViewTag; btnTag++) {
//                starBtn.selected = YES;
//            }
//            [starBtn setBackgroundImage:[UIImage imageNamed:@"icon_NormalStar"] forState:UIControlStateNormal];
//            [starBtn setBackgroundImage:[UIImage imageNamed:@"icon_LightStar"] forState:UIControlStateSelected];
//            [self addSubview:starBtn];
//            
//        }
        [self addSubview:self.backgroundLabel];
        [self addSubview:self.userPhoneLabel];
        [self addSubview:self.userPackageLabel];
        
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150*SCREEN_SCALE, 75*SCREEN_SCALE));
    }];
    
    [self.userPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.backgroundLabel);
        make.size.mas_equalTo(CGSizeMake(150*SCREEN_SCALE, 13*SCREEN_SCALE));
    }];
    
    
    
    
//    [self.backgroundLabel setFrame:CGRectMake((SCREEN_WIDTH - 150*SCREEN_SCALE)/2, 10*SCREEN_SCALE, 150*SCREEN_SCALE, 75*SCREEN_SCALE)];
//    [self.userPhoneLabel setFrame:CGRectMake((SCREEN_WIDTH - 150*SCREEN_SCALE)/2, 30*SCREEN_SCALE, 150*SCREEN_SCALE, 13*SCREEN_SCALE)];
//    [self.userPackageLabel setFrame:CGRectMake((SCREEN_WIDTH - 150*SCREEN_SCALE)/2, 52*SCREEN_SCALE, SCREEN_WIDTH, 10*SCREEN_SCALE)];
    
//    CGFloat btnX;
//    CGFloat btnY = 65;
//    for (NSInteger i = 1; i < 6; i++) {
//        btnX = 112*SCREEN_SCALE + (kBtnSpace + kBtnWidth)*SCREEN_SCALE * (i - 1);
//        UIButton *btn = (UIButton *)[self viewWithTag:(kSubViewTag + i)];
//        btn.frame = CGRectMake(btnX, btnY, kBtnWidth, kBtnHeight);
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = btnWidth / 2.0;
//    }

}

#pragma mark - setter and getter

-(void)setUserPhoneNumber:(NSString *)userPhoneNumber{
    _userPhoneNumber = userPhoneNumber;
    self.userPhoneLabel.text = userPhoneNumber;
}

-(void)setUserPackage:(NSString *)userPackage{
    _userPackage = userPackage;
    self.userPackageLabel.text = userPackage;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.backgroundImgView.image = backgroundImage;
}

-(UILabel *)userPhoneLabel{
    if (!_userPhoneLabel) {
        _userPhoneLabel  = [[UILabel alloc]init];
        _userPhoneLabel.textAlignment = NSTextAlignmentCenter;
        _userPhoneLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _userPhoneLabel.textColor = HS_FontCor1;
        
    }
    return _userPhoneLabel;
}

-(UILabel *) userPackageLabel{
    if (!_userPackageLabel) {
        _userPackageLabel = [[UILabel alloc]init];
        _userPackageLabel.textAlignment = NSTextAlignmentCenter;
        _userPackageLabel.font = HS_font5;
        _userPackageLabel.textColor = HS_FontCor1;
    }
    return _userPackageLabel;
}

-(UILabel *)backgroundLabel{
    if (!_backgroundLabel) {
        _backgroundLabel = [[UILabel alloc]init];
        _backgroundLabel.layer.cornerRadius = 3;
        _backgroundLabel.layer.masksToBounds = YES;
        //_backgroundLabel.backgroundColor = RGB(0x86, 0xd4, 0xba);
        _backgroundLabel.backgroundColor = [RGB(0x86, 0xd4, 0xba) colorWithAlphaComponent:0.5];
    
    }
    return _backgroundLabel;
}

//-(UIButton *)starBtn{
//    if (!_starBtn) {
//        _starBtn = [[UIButton alloc]init];
//    }
//    return _starBtn;
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
