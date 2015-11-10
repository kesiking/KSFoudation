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

- (void)setupView {
    [self setTitleColor:EHCor5 forState:UIControlStateNormal];
    self.titleLabel.font = EHFont5;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.contentEdgeInsets = UIEdgeInsetsMake(caculateNumber(10), caculateNumber(12), 0, 0);
}

@end
