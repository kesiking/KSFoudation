//
//  KSDebugFPSLabel.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugFPSLabel.h"
#import "KSDebugMaroc.h"

#define kSize CGSizeMake(120, 50)

@implementation KSDebugFPSLabel{
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;

}

-(instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    //self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    [self setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.4)];
    self.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
    self.textColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    [self setFont:[UIFont systemFontOfSize:15]];
    self.text = @"Loading";
     _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    self.text = [NSString stringWithFormat:@"帧率：%d FPS",(int)round(fps)];
//    self.text = [NSString stringWithFormat:@"帧率：%d ",(int)round(fps)];

    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
