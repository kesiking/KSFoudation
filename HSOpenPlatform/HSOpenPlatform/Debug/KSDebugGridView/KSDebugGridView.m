//
//  WeAppDebugGridView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugGridView.h"
#import "KSDebugToastView.h"
#import "KSDebugUserDefault.h"

@implementation KSDebugGridView

-(void)setupView{
    [super setupView];
    self.needCancelBackgroundAction = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.opaque = YES;
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    
    if (![KSDebugUserDefault getUserHadClicedGridBtn]) {
        [KSDebugToastView toast:@"再点击“栅格”可取消查看哦！^_^" toView:self.debugViewReference displaytime:5];
        [KSDebugUserDefault setUserHadClicedGridBtn:YES];
    }
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)drawRect:(CGRect)rect
{
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ( context )
    {
        CGContextSaveGState( context );
        CGContextClearRect( context, rect );
        
        [[[UIColor blackColor] colorWithAlphaComponent:0.1f] set];
        CGContextFillRect( context, rect );
        
        CGFloat step = 16.0f;
        int		group = 5;
        
        for ( int i = 0; i * step < rect.size.width; i += 1 )
        {
            if ( 0 == (i % group) )
            {
                CGContextSetLineWidth( context, 2 );
                CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.8f].CGColor );
            }
            else
            {
                CGContextSetLineWidth( context, 1 );
                CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.6f].CGColor );
            }
            
            CGContextMoveToPoint( context, i * step, 0.0f );
            CGContextAddLineToPoint( context, i * step, rect.size.height );
            CGContextStrokePath( context );
            
            if ( 0 == (i % group) )
            {
                [[UIColor whiteColor] set];
                
                NSString * text = [NSString stringWithFormat:@"%.0f", i * step];
                [text drawAtPoint:CGPointMake( i * step + 3.0f, 1.0f )
                         withFont:[UIFont boldSystemFontOfSize:10.0f]];
            }
        }
        
        for ( int j = 0; j * step < rect.size.height; j += 1 )
        {
            if ( 0 == (j % group) )
            {
                CGContextSetLineWidth( context, 2 );
                CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.8f].CGColor );
            }
            else
            {
                CGContextSetLineWidth( context, 1 );
                CGContextSetStrokeColorWithColor( context, [[UIColor cyanColor] colorWithAlphaComponent:0.6f].CGColor );
            }
            
            CGContextMoveToPoint( context, 0.0f, j * step );
            CGContextAddLineToPoint( context, rect.size.width, j * step );
            CGContextStrokePath( context );
            
            if ( 0 == (j % group) )
            {
                [[UIColor whiteColor] set];
                
                NSString * text = [NSString stringWithFormat:@"%.0f", j * step];
                [text drawAtPoint:CGPointMake( 3.0f, j * step + 1.0f )
                         withFont:[UIFont boldSystemFontOfSize:10.0f]];
            }
        }
        
        CGContextRestoreGState( context );
    }	
}

@end
