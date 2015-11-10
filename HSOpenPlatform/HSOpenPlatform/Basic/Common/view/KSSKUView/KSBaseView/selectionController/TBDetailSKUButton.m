                                       //
//  TBDetailUIButton.m
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailSKUButton.h"

@interface TBDetailSKUButton ()
{
    BOOL hasAddStateTarget;
    BOOL setNormalBackground;
    UIColor *backgroundColor;
    UIColor *borderColor;
}

@property (nonatomic, strong) NSMutableDictionary *backgroundDic;
@property (nonatomic, strong) NSMutableDictionary *borderDic;
@end

@implementation TBDetailSKUButton
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - System Methods
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hasAddStateTarget = NO;
        self.buttonDidSeleced = NO;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self updateButtonStyle];
}

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateButtonStyle];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateButtonStyle];
}

-(void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    if (self.enabled == YES && self.highlighted == NO) {
        backgroundColor = color;
    }
}

-(void)dealloc
{
    if (_backgroundDic) {
        [_backgroundDic removeAllObjects];
        _backgroundDic = nil;
    }
    
    if (_borderDic) {
        [_borderDic removeAllObjects];
        _borderDic = nil;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public
-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    if (color == nil) {
        color = [UIColor clearColor];
    }
    
    switch (state) {
        case UIControlStateNormal:
            backgroundColor = [[UIColor alloc] initWithCGColor:color.CGColor];
            [self setBackgroundColor:backgroundColor];
        case UIControlStateDisabled:
        case UIControlStateHighlighted:
        case UIControlStateSelected:
            self.backgroundDic[[[NSNumber alloc] initWithUnsignedInt:state]]    = color;
        default:
            break;
    }
}

-(void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    if (color == nil) {
        color = [UIColor clearColor];
    }
    switch (state) {
        case UIControlStateNormal:
            borderColor = [[UIColor alloc] initWithCGColor:color.CGColor];
            [self.layer setBorderColor:borderColor.CGColor];
        case UIControlStateDisabled:
        case UIControlStateHighlighted:
        case UIControlStateSelected:
            self.borderDic[[[NSNumber alloc] initWithUnsignedInt:state]] = color;
            break;
        default:
            break;
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
-(void)updateBackgroundColor:(UIControlState)state
{
    UIColor *bgColor = self.backgroundDic[[[NSNumber alloc] initWithUnsignedInt:state]];
    if (bgColor != nil) {
        [self setBackgroundColor:bgColor];
    } else {
        [self setBackgroundColor:backgroundColor];
    }
}

-(void)updateBorderColor:(UIControlState)state
{
    UIColor *color = self.borderDic[[[NSNumber alloc] initWithUnsignedInt:state]];
    if (color != nil) {
        [self.layer setBorderColor:color.CGColor];
    } else {
        [self.layer setBorderColor:borderColor.CGColor];
    }
}

/**
 *  获取当前的状态
 *  【注】状态优先级如下：失效-高亮-选择-正常
 *  @return 当前优先级最高的状态
 */
-(UIControlState)getCurrentState
{
    if (!self.enabled) {
        if (self.selected) { //此时iOS系统判断为normal状态
            return UIControlStateNormal;
        } else {
            return UIControlStateDisabled;
        }
    } else if (self.highlighted) {
        return UIControlStateHighlighted;
    } else if (self.selected) {
        return UIControlStateSelected;
    } else {
        return UIControlStateNormal;
    }
}

-(void)updateButtonStyle
{
    [self updateBackgroundColor:[self getCurrentState]];
    [self updateBorderColor:[self getCurrentState]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Accessor
-(NSMutableDictionary *)backgroundDic
{
    if (!_backgroundDic) {
        _backgroundDic = [[NSMutableDictionary alloc] init];
    }
    return _backgroundDic;
}

-(NSMutableDictionary *)borderDic
{
    if (!_borderDic) {
        _borderDic = [[NSMutableDictionary alloc] init];
    }
    return _borderDic;
}

@end
