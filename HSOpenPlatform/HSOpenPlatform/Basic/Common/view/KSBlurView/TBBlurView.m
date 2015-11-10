//
//  TBBlurView.m
//  Taobao2013
//
//  Created by Xigua on 13-11-13.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "TBBlurView.h"
#import <QuartzCore/QuartzCore.h>

@interface TBBlurView (){
    
}

@property (nonatomic, strong) UIToolbar             *toolbar;
@property (nonatomic, strong) UIImageView           *backgroundImageView;

@end

@implementation TBBlurView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    if (IOS_VERSION > 6.1) {
        if (![self toolbar]) {
            [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
            [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
        }
    }else{
        [self insertSubview:self.backgroundImageView atIndex:0];
    }
}

-(UIImageView*)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:[self bounds]];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _backgroundImageView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:0.95];
    }
    return _backgroundImageView;
}

- (void) setBlurTintColor:(UIColor *)blurTintColor {
    if (_toolbar.hidden) {
        _toolbar.hidden = NO;
    }
    if (IOS_VERSION > 6.1) {
        [self.toolbar setBarTintColor:blurTintColor];
    }else{
        self.backgroundImageView.backgroundColor = blurTintColor;
    }
}

- (void)setBlurStyle:(TBBlurViewStyle )blurStyle{
    switch (blurStyle) {
        case TBBlurViewStyleDefault:
            _toolbar.barStyle = UIBarStyleDefault;
            break;
        case TBBlurViewStyleDark:
            _toolbar.barStyle = UIBarStyleBlackTranslucent;
            break;
        default:
            _toolbar.barStyle = UIBarStyleDefault;
            break;
    }
}


- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if (_toolbar) {
        _toolbar.hidden = YES;
    }
    if (_backgroundImageView) {
        _backgroundImageView.hidden = YES;
    }
    super.backgroundColor = backgroundColor;
}

-(void) setBackgroundImage:(UIImage *)backgroundImage{
    if (backgroundImage) {
        self.backgroundImageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView.image = backgroundImage;
    }else{
        self.backgroundImageView.image = nil;
        self.backgroundImageView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:0.9];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.toolbar) {
        [self.toolbar setFrame:[self bounds]];
    }
    
}

- (void)containerAnimationWillStart:(NSNotification*)notification {
    if (IOS_VERSION > 6.1) {
        if (_toolbar) {
            self.toolbar.translucent = NO;
        }
    }
}

- (void)containerAnimationDidFinish:(NSNotification*)notification {
    if (IOS_VERSION > 6.1) {
        if (_toolbar) {
            self.toolbar.translucent = YES;
        }
    }
}

@end
