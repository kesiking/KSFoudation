//
//  HSHomeServiceButton.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/26.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeServiceButton.h"

@implementation HSHomeServiceButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(20, caculateNumber(20), 50, 50);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return  CGRectMake(0, caculateNumber(20+10) + 50, self.width, 15);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(50+20+20, home_serviceButton_height);
}

- (void)setupView {
    [self setTitleColor:HS_FontCor2 forState:UIControlStateNormal];
    self.titleLabel.font = HS_font5;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
