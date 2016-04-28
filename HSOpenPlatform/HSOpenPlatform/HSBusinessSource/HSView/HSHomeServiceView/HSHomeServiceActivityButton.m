//
//  HSHomeServiceActivityButton.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/24.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeServiceActivityButton.h"

@implementation HSHomeServiceActivityButton


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
    return CGRectMake((self.width - caculateNumber(327/2.0)) / 2.0, caculateNumber(30+15), caculateNumber(327/2.0), caculateNumber(153/2.0));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return  CGRectMake(0, caculateNumber(15), self.width, caculateNumber(15));
}

- (void)setupView {
    [self setTitleColor:EHCor5 forState:UIControlStateNormal];
    self.titleLabel.font = EHFont2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
