//
//  EHLoadingToast.h
//  eHome
//
//  Created by xtq on 15/7/7.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHLoadingToast : NSObject

+ (void)toast;

+ (void)finishToast:(NSString *)text;

+ (void)hide;


+ (void)toastWithText:(NSString *)text;

+ (void)toastWithText:(NSString *)text InView:(UIView *)view;

+ (void)hide:(BOOL)animated;

+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end



@interface EHCircleView : UIView

@property(nonatomic,strong)UIColor *circleColor;

- (void)show;

@end