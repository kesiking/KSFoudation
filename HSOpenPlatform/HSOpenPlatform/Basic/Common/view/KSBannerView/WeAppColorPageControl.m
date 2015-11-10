//
//  TBColorPageControl.m
//  taobao4iphone
//
//  Created by Xu Jiwei on 11-4-22.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "WeAppColorPageControl.h"

// 圆点的直径
#define kPageBallWidth      8.0
// 圆点之间的间隔
#define kPageBallGap        6.0


@implementation WeAppColorPageControl

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.normalPageColor = [UIColor colorWithWhite:185/255.0 alpha:1.0];
        self.currentPageColor = [UIColor colorWithWhite:133/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        _width = kPageBallWidth;
        _height = kPageBallWidth;
        _gap = kPageBallGap;
    }
    
    return self;
}


#pragma mark -
#pragma mark Properties

- (void)setCurrentPage:(NSInteger)page {
    _currentPage = page;
    [self setNeedsDisplay];
}


- (void)setNumberOfPages:(NSInteger)count {
    _numberOfPages = count;
    [self setNeedsDisplay];
}


- (void)setHidesForSinglePage:(BOOL)hides {
    _hidesForSinglePage = hides;
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint point = [touch locationInView:self];
        CGSize size = self.bounds.size;
        float x = ceil((size.width - (_width * _numberOfPages) - (_gap * (_numberOfPages-1))) / 2.0);
        float currentPageX = x + _currentPage * (_width + _gap);
        int offset = 0;
        if (point.x > currentPageX + _width) {
            offset = 1;
        } else if (point.x < currentPageX) {
            offset = -1;
        }
        
        if (offset != 0 && (_currentPage + offset >= 0 && _currentPage + offset < _numberOfPages)) {
            _currentPage += offset;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


#pragma mark -
#pragma mark View

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!_hidesForSinglePage || _numberOfPages > 1) {
        CGSize size = rect.size;
        float x = ceil((size.width - (_width * _numberOfPages) - (_gap * (_numberOfPages-1))) / 2.0);
        float y = ceil((size.height - _height) / 2.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (int i = 0; i < _numberOfPages; ++i) {
            CGContextSaveGState(context);
            
            UIColor *ballColor = (i == _currentPage) ? _currentPageColor : _normalPageColor;
            [ballColor setFill];
            
            if (_type == WeAppRoundPageControl) {
                CGContextFillEllipseInRect(context, CGRectMake(x, y, _width, _height));
                if (_isSolid) {
                    CGContextFillEllipseInRect(context, CGRectMake(x, y, _width, _height));
                    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
                    CGContextSetLineWidth(context, self.borderWidth > 0 ? self.borderWidth : 0.5);
                    CGContextAddEllipseInRect(context, CGRectMake(x, (self.frame.size.height - self.height) / 2.0f, self.width, self.height));
                    CGContextStrokePath(context);
                }
            } else {
                CGContextFillRect(context, CGRectMake(x, y, _width, _height));
            }

            
            CGContextRestoreGState(context);
            
            x += _width + _gap;
        }
    }
}


#pragma mark -

- (void)dealloc {
    self.normalPageColor = nil;
    self.currentPageColor = nil;
}

@end
