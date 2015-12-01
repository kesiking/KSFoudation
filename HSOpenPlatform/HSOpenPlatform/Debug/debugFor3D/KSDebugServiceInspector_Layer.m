//
//  WeAppDebugServiceInspector_Layer.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-9.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugServiceInspector_Layer.h"

@implementation KSDebugServiceInspector_Layer

@synthesize depth = _depth;
@synthesize rect = _rect;
@synthesize view = _view;
@synthesize label = _label;

- (void)load
{    
    self.label = [[UILabel alloc] init];
    self.label.hidden = NO;
    self.label.textColor = [UIColor yellowColor];
    self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.label.font = [UIFont boldSystemFontOfSize:12.0f];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.label];
}

- (void)unload
{
    [self.label removeFromSuperview];
    self.label = nil;
}

- (void)setFrame:(CGRect)f
{
    [super setFrame:f];
    
    CGRect labelFrame;
    labelFrame.size.width = fminf( 200.0f, f.size.width );
    labelFrame.size.height = fminf( 16.0f, f.size.height );
    labelFrame.origin.x = 0;
    labelFrame.origin.y = 0;
    
    self.label.frame = labelFrame;
}

@end
