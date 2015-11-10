//
//  TBBlurView.h
//  Taobao2013
//
//  Created by Xigua on 13-11-13.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TBBlurViewStyleDefault = 0,
    TBBlurViewStyleDark,
}TBBlurViewStyle;

@interface TBBlurView : UIView

@property (nonatomic, strong) UIColor *blurTintColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) TBBlurViewStyle blurStyle;


@end
