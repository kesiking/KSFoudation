//
//  EHImageClipView.m
//  8.13-test-layerClip
//
//  Created by xtq on 15/8/14.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHImageClipView.h"

@implementation EHImageClipView
{
    CGRect _clipRect;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dimingColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        CGFloat length = MIN(frame.size.width, frame.size.height);
        CGFloat x = (frame.size.width - length) / 2.0;
        CGFloat y = (frame.size.height - length) / 2.0;
        self.userInteractionEnabled =   NO;
        _clipRect = CGRectMake(x, y, length, length);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.dimingColor setFill];
    UIRectFill(rect);
    
    [[[UIColor whiteColor] colorWithAlphaComponent:0.7] setStroke];
    UIRectFrame(_clipRect);
    
    CGRect r = _clipRect;
    r.origin.x += 0.5;
    r.origin.y += 0.5;
    r.size.width -= 1;
    r.size.height -= 1;
    
    [[UIColor clearColor]setFill];
    UIRectFillUsingBlendMode(r, kCGBlendModeClear);
    UIRectFill(r);
    
}

- (UIImage *)imageClipped {
    UIImage *image = [self imageFromView:self.superview atFrame:_clipRect];
    return image;
}

- (UIImage *)imageFromView: (UIView *) theView atFrame:(CGRect)rect{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef cgImage = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage *imgeee = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    UIGraphicsEndImageContext();
    return  imgeee;
}

@end
