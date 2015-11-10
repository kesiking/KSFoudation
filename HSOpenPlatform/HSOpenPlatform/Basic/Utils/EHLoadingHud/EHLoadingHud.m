//
//  EHLoadingHud.m
//  6.29-tets-tqhud
//
//  Created by xtq on 15/6/29.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHLoadingHud.h"

@interface EHLoadingHud()<MBProgressHUDDelegate>

@end

@implementation EHLoadingHud
{
    MBProgressHUD *_mbHud;
    TQLoadingView *_tqLoadingView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _tqLoadingView = [[TQLoadingView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.hideDelayTime = 1; //默认隐藏延迟时间1s
    }
    return self;
}

- (void)showWithStatus:(NSString *)status InView:(UIView *)superView{

    [_tqLoadingView show];
    
    _mbHud = [[MBProgressHUD alloc] initWithView:superView];
    [superView addSubview:_mbHud];
    _mbHud.customView = _tqLoadingView;
    _mbHud.mode = MBProgressHUDModeCustomView;
    _mbHud.delegate = self;
    _mbHud.labelText = status;
    
    [_mbHud show:YES];
}

- (void)showSuccessWithStatus:(NSString *)status Finish:(FinishBlock)finish{
    _mbHud.labelText = status;
    [_tqLoadingView success:^{
        [_mbHud hide:YES afterDelay:self.hideDelayTime];
        !finish?:finish();
    }];
}

- (void)showErrorWithStatus:(NSString *)status Finish:(FinishBlock)finish{
    _mbHud.labelText = status;
    [_tqLoadingView error:^{
        [_mbHud hide:YES afterDelay:self.hideDelayTime];
        !finish?:finish();
    }];
}

- (void)hide:(BOOL)animated{
    [_tqLoadingView hide];
    [_mbHud hide:YES];
}

- (void)setLineCount:(CGFloat)lineCount{
    _tqLoadingView.lineCount = lineCount;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _tqLoadingView.lineWidth = lineWidth;
}

- (void)setSubCount:(CGFloat)subCount{
    _tqLoadingView.subCount = subCount;
}

- (void)setLineColor:(UIColor *)lineColor{
    _tqLoadingView.lineColor = lineColor;
}

- (void)setDuration:(CGFloat)duration{
    _tqLoadingView.duration = duration;
}

//hud完全隐藏后的回调
- (void)hudWasHidden:(MBProgressHUD *)hud{
    //[_tqLoadingView setNeedsDisplay];
    !self.hideFinishBlock?:self.hideFinishBlock();
}

@end
