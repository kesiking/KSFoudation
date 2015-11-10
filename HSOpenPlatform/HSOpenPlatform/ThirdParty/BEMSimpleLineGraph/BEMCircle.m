//
//  BEMCircle.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMCircle.h"
@implementation BEMCircle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, rect);
//    [self.Pointcolor set];
//    CGContextFillPath(ctx);
    
    //CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0);
    [self.Pointcolor set];
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.width/2, rect.size.width/3, 0, 2*M_PI, YES);
    CGContextDrawPath(ctx,kCGPathFillStroke);
}
@end