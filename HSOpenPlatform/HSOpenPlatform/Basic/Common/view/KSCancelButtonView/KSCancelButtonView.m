//
//  KSCancelButtonView.m
//  eHome
//
//  Created by 孟希羲 on 15/8/28.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSCancelButtonView.h"

@implementation KSCancelButtonView

-(void)setupView{
    [super setupView];
    [self initCacelButton];
}

-(void)initCacelButton{
    _cancelButton = [[UIButton alloc] initWithFrame:self.bounds];
    [_cancelButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
}

-(void)cancelButtonClicked:(id)sender{
    [self cancelEvent];
}

-(void)cancelEvent{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
