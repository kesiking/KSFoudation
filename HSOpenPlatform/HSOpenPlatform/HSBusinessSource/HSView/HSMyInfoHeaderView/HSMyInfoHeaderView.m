//
//  HSMyInfoHeaderView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMyInfoHeaderView.h"


#define kSubViewTag   100
#define kBtnSpace 8
#define kBtnWidth 24
#define kBtnHeight 23

@interface HSMyInfoHeaderView()

@property (strong,nonatomic) UILabel *userPhoneLabel;
@property (strong,nonatomic) UIButton *starBtn;
@property (strong, nonatomic) UIImageView *backgroundImgView;

@end

@implementation HSMyInfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundImgView = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:self.backgroundImgView];
        for (NSInteger i = 1; i < 6; i++){
            UIButton *starBtn = [[UIButton alloc]initWithFrame:CGRectZero];
            starBtn.tag = kSubViewTag +i;
            NSInteger btnTag = starBtn.tag;
            for (btnTag = kSubViewTag +1; btnTag < [self.accountStarLevel integerValue]+kSubViewTag; btnTag++) {
                starBtn.selected = YES;
            }
            [starBtn setBackgroundImage:[UIImage imageNamed:@"icon_NormalStar"] forState:UIControlStateNormal];
            [starBtn setBackgroundImage:[UIImage imageNamed:@"icon_LightStar"] forState:UIControlStateSelected];
            [self addSubview:starBtn];
            
        }
        [self addSubview:self.userPhoneLabel];
        
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.userPhoneLabel setFrame:CGRectMake(0, 35, SCREEN_WIDTH, 13)];
    
    CGFloat btnX;
    CGFloat btnY = 65;
    for (NSInteger i = 1; i < 6; i++) {
        btnX = 112*SCREEN_SCALE + (kBtnSpace + kBtnWidth)*SCREEN_SCALE * (i - 1);
        UIButton *btn = (UIButton *)[self viewWithTag:(kSubViewTag + i)];
        btn.frame = CGRectMake(btnX, btnY, kBtnWidth, kBtnHeight);
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = btnWidth / 2.0;
    }

}

#pragma mark - setter and getter

-(void)setUserPhoneNumber:(NSString *)userPhoneNumber{
    _userPhoneNumber = userPhoneNumber;
    self.userPhoneLabel.text = userPhoneNumber;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.backgroundImgView.image = backgroundImage;
}

-(UILabel *)userPhoneLabel{
    if (!_userPhoneLabel) {
        _userPhoneLabel  = [[UILabel alloc]init];
        _userPhoneLabel.textAlignment = NSTextAlignmentCenter;
        _userPhoneLabel.font = EHFont1;
        _userPhoneLabel.textColor = EHCor1;
        
    }
    return _userPhoneLabel;
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
