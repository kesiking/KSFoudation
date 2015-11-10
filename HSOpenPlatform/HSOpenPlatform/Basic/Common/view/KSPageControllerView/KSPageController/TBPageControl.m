//
//  TBPageControl.m
//  TBWeApp
//
//  Created by 逸行 on 14-3-21.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import "TBPageControl.h"

@implementation TBPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setCurrentPage:1];
    return self;
}

-(id) init
{
    self = [super init];
    [self setCurrentPage:1];
    self.preDisplayedPage = -1;
    return self;
}



-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if([dot isKindOfClass:[UIImageView class]])
        {
            dot.frame = CGRectMake(dot.frame.origin.x,dot.frame.origin.y,6,6);
            if (i == self.currentPage) dot.image = [UIImage imageNamed:@"icon_Main_slidercircle_focus"];
            else dot.image = [UIImage imageNamed:@"icon_Main_slidercircle.png"];
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

@end
