//
//  XHVoiceRecordHUD.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-13.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHVoiceRecordHUD.h"

@interface XHVoiceRecordHUD ()

@property (strong, nonatomic) UILabel *centerLabel;
//@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic)UIProgressView *timerProcessView;
@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIImageView *microPhoneImageView;
@property (nonatomic, weak) UIImageView *cancelRecordImageView;
@property (nonatomic, weak) UIImageView *recordingHUDImageView;

/**
 *  逐渐消失自身
 *
 *  @param compled 消失完成的回调block
 */
- (void)dismissCompled:(void(^)(BOOL fnished))compled;

/**
 *  配置是否正在录音，需要隐藏和显示某些特殊的控件
 *
 *  @param recording 是否录音中
 */
- (void)configRecoding:(BOOL)recording;

/**
 *  根据语音输入的大小来配置需要显示的HUD图片
 *
 *  @param peakPower 输入音频的声音大小
 */
- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower;

/**
 *  配置默认参数
 */
- (void)setup;

@end

@implementation XHVoiceRecordHUD

- (void)startRecordingHUDAtView:(UIView *)view {
    CGPoint center = CGPointMake(CGRectGetWidth(view.frame) / 2.0, CGRectGetHeight(view.frame) / 2.0);
    self.center = center;
    [view addSubview:self];
    [self configRecoding:YES];
    [self timer];
}

- (void)pauseRecord {
    [self configRecoding:YES];
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.remindLabel.text = NSLocalizedStringFromTable(@"SlideToCancel", @"MessageDisplayKitString", nil);
}

- (void)resaueRecord {
    [self configRecoding:NO];
    self.remindLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.630];
    self.remindLabel.text = NSLocalizedStringFromTable(@"ReleaseToCancel", @"MessageDisplayKitString", nil);
}

- (void)stopRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled];
}

- (void)cancelRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled];
}

- (void)dismissCompled:(void(^)(BOOL fnished))compled {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        compled(finished);
    }];
}

- (void)configRecoding:(BOOL)recording {
    self.microPhoneImageView.hidden = !recording;
    self.recordingHUDImageView.hidden = !recording;
    self.cancelRecordImageView.hidden = recording;
}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
    NSString *imageName = @"icon_voice05_";
    if (peakPower >= 0 && peakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (peakPower > 0.1 && peakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (peakPower > 0.3 && peakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.4 && peakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.5 && peakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.7 && peakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.8 && peakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (peakPower > 0.9 && peakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"6"];
    }
    self.recordingHUDImageView.image = [UIImage imageNamed:imageName];
}

- (void)setPeakPower:(CGFloat)peakPower {
    _peakPower = peakPower;
    [self configRecordingHUDImageWithPeakPower:peakPower];
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, self.width, 30)];
        _centerLabel.backgroundColor = [UIColor clearColor];
        _centerLabel.text = @"10.0";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:12.0f];
        _centerLabel.textColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
        
    }
    return _centerLabel;
}

//- (UILabel *)titleLabel{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
//        _titleLabel.text = @"录音时间";
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        _titleLabel.textColor = [UIColor whiteColor];
//    }
//    return _titleLabel;
//}
- (UIProgressView *)timerProcessView
{
    if (!_timerProcessView) {
        _timerProcessView = [[UIProgressView alloc] initWithFrame:CGRectMake(32, 27, 136, 3)];
        _timerProcessView.trackTintColor = [UIColor blackColor];
        _timerProcessView.progressTintColor = [UIColor colorWithRed:0x7b/255.0 green:0xac/255.0 blue:0xfc/255.0 alpha:1.0];
        _timerProcessView.progress = 1.0;
    }
    return _timerProcessView;
}
- (void)setup {
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    [self addSubview:self.centerLabel];
    [self addSubview:self.timerProcessView];
//    [self addSubview:self.titleLabel];
    
    if (!_remindLabel) {
        UILabel *remindLabel= [[UILabel alloc] initWithFrame:CGRectMake(37.0, 120.0, 126.0, 21.0)];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:13];
        remindLabel.layer.masksToBounds = YES;
        remindLabel.layer.cornerRadius = 4;
        remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.text = NSLocalizedStringFromTable(@"SlideToCancel", @"MessageDisplayKitString", nil);
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLabel];
        _remindLabel = remindLabel;
    }
    
    if (!_microPhoneImageView) {
        UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48.0, 48.0, 30.0, 55.0)];
        microPhoneImageView.image = [UIImage imageNamed:@"icon_voice04"];
        microPhoneImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:microPhoneImageView];
        _microPhoneImageView = microPhoneImageView;
    }
    
    if (!_recordingHUDImageView) {
        UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(102.0, 55, 50.0, 40.0)];
        recordHUDImageView.image = [UIImage imageNamed:@"icon_voice05_1"];
        recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:recordHUDImageView];
        _recordingHUDImageView = recordHUDImageView;
    }
    
    if (!_cancelRecordImageView) {
        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 33, 70.0, 79.0)];
        cancelRecordImageView.image = [UIImage imageNamed:@"icon_cancel send"];
        cancelRecordImageView.hidden = YES;
        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:cancelRecordImageView];
        _cancelRecordImageView = cancelRecordImageView;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

#pragma mark - Getters

- (NSTimer *)timer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
    return _timer;
}

- (void)timerAction{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    float second = [self.centerLabel.text floatValue];
    if (second <= 3.0f) {
        self.centerLabel.textColor = [UIColor redColor];
    }else{
        self.centerLabel.textColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
    }
    self.centerLabel.text = [NSString stringWithFormat:@"%.1f",second-0.1];
    [UIView commitAnimations];
    self.timerProcessView.progress -=0.1f/10.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
