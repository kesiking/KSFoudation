//
//  WeAppDebugScrollView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugScrollView.h"
#import "KSDebugCPUView.h"
#import "KSDebugMemory.h"

@interface KSDebugScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView            *scrollView;

@property (nonatomic, strong) KSDebugCPUView       *cpuView;

@property (nonatomic, strong) KSDebugMemory        *memoryView;

@end

@implementation KSDebugScrollView

-(id)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.cpuView];
    [self.scrollView addSubview:self.memoryView];
}

-(void)dealloc
{
    self.scrollView.delegate = nil;
    self.scrollView = nil;
}

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = NO;
    }
    return _scrollView;
}

-(KSDebugCPUView *)cpuView{
    if (_cpuView == nil) {
        _cpuView = [[KSDebugCPUView alloc] initWithFrame:CGRectMake(0, 20, self.scrollView.frame.size.width/2 - 55, 100)];
        [_cpuView setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.6)];
    }
    return _cpuView;
}

-(KSDebugMemory *)memoryView{
    if (_memoryView == nil) {
        _memoryView = [[KSDebugMemory alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cpuView.frame) + 1, CGRectGetMinY(self.cpuView.frame), CGRectGetWidth(self.scrollView.frame) - CGRectGetHeight(self.cpuView.frame) - 5, CGRectGetHeight(self.cpuView.frame))];
        [_memoryView setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.6)];
    }
    return _memoryView;
}


@end
