//
//  EHSwitch.m
//  eHome
//
//  Created by xtq on 15/9/22.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHSwitch.h"

@interface EHSwitch ()

@property (nonatomic, strong)UIImageView *backgroundView;

@property (nonatomic, strong)UIImageView *thumbView;

@end

@implementation EHSwitch
{
    CGFloat _space;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = MAX(height * 1.2, CGRectGetWidth(self.frame));
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    CGFloat thumbViewWidth = CGRectGetHeight(self.frame) - _space * 2;
    if (self.on) {
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) - thumbViewWidth - _space, _space, thumbViewWidth, thumbViewWidth);
    }
    else {
        self.thumbView.frame = CGRectMake(_space, _space, thumbViewWidth, thumbViewWidth);
    }
    self.thumbView.layer.cornerRadius = thumbViewWidth / 2.0;
    self.thumbView.layer.masksToBounds = YES;
    
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - Events Response
- (void)tap:(UITapGestureRecognizer *)tap {
    [self setOn:!self.on animated:YES];
    !self.switchChangedBlock?:self.switchChangedBlock(self.on);
}


#pragma mark - Private Methods

- (void)setUp {
    _space = 4;
    self.on = YES;
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.thumbView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    
    if (on) {
        [self showOnAnimated:animated];
    }
    else {
        [self showOffAnimated:animated];
    }
}

- (void)showOnAnimated:(BOOL)animated {
    CGFloat thumbViewWidth = CGRectGetWidth(self.thumbView.frame);
    CGRect onFrame = CGRectMake(CGRectGetWidth(self.frame) - thumbViewWidth - _space, _space, thumbViewWidth, thumbViewWidth);
    UIColor *onColor = [UIColor colorWithRed:28/255.0 green:89/255.0 blue:248/255.0 alpha:1];
        
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.thumbView.frame = onFrame;
            self.thumbView.backgroundColor = onColor;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.thumbView.frame = onFrame;
        self.thumbView.backgroundColor = onColor;
    }
}

- (void)showOffAnimated:(BOOL)animated {
    CGFloat thumbViewWidth = CGRectGetWidth(self.thumbView.frame);
    CGRect offFrame = CGRectMake(_space, _space, thumbViewWidth, thumbViewWidth);
    UIColor *offColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.thumbView.frame = offFrame;
            self.thumbView.backgroundColor = offColor;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.thumbView.frame = offFrame;
        self.thumbView.backgroundColor = offColor;
    }
}

#pragma mark - Getters And Setters
- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (UIImageView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc]init];
        _thumbView.backgroundColor = [UIColor colorWithRed:28/255.0 green:89/255.0 blue:248/255.0 alpha:1];
    }
    return _thumbView;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_switch_set_track"]];
    }
    return _backgroundView;
}

@end
