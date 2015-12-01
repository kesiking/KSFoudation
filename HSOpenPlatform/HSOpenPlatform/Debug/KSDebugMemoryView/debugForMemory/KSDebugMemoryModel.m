//
//  WeAppDebugMemoryModel.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugMemoryModel.h"

@implementation KSDebugMemoryModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

-(void)load{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)unload{
    [self cancelTimer];
    self.delegate = nil;
}

-(void)timerProc: (NSTimer*)t
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataDidChanged:)]) {
        [self.delegate dataDidChanged:self];
    }
}

-(void)cancelTimer{
    if (self.timer != nil) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

- (void)dealloc
{
    [self unload];
    self.delegate = nil;
}

@end
