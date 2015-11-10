//
//  UIScrollViewSpeed.m
//  Taobao2013
//
//  Created by 香象 on 21/4/13.
//  Copyright (c) 2013 Taobao.com. All rights reserved.
//

#import "WeAppUIScrollViewSpeed.h"

@implementation WeAppUIScrollViewSpeed
-(id)init{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

-(void)reset{
    _lastOffset=CGPointMake(0, 0);
    _lastOffsetCapture=0;
    _scrollSpeed=0;
}

-(void)calculateSpeedWithScrollView:(UIScrollView *)scrollView{
    
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval timeDiff = currentTime - self.lastOffsetCapture;
    if(timeDiff > 0.2) {
        CGFloat distance = currentOffset.y - self.lastOffset.y;
        //The multiply by 10, / 1000 isn't really necessary.......
        CGFloat scrollSpeedNotAbs = (distance * 10) / 2000; //in pixels per millisecond
        
        self.scrollSpeed = fabsf(scrollSpeedNotAbs);
        if (self.speedChanged) {
            self.speedChanged(self.scrollSpeed);
        }
        self.lastOffset = currentOffset;
        self.lastOffsetCapture = currentTime;
        //NSLog(@"the speed is %f",self.scrollSpeed);
    }
    
}



@end
