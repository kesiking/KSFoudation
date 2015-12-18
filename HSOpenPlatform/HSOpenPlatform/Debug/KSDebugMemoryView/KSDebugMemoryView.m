//
//  WeAppDebugMemoryView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugMemoryView.h"
#import "KSDebugOperationView.h"
#import "KSDebugScrollView.h"
#import "KSDebugToastView.h"
#import "KSDebugUserDefault.h"

@interface KSDebugMemoryView()

@property(nonatomic, strong)  KSDebugScrollView*  debugScrollView;

@end

@implementation KSDebugMemoryView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"内存信息",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)setupView{
    [super setupView];
    self.needCancelBackgroundAction = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

-(void)startDebug{
    [super startDebug];
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    [self.debugScrollView setHidden:NO];
    [self.closeButton setFrame:CGRectMake(self.frame.size.width - 110, CGRectGetMaxY(self.frame) - 50, 100, 40)];
    self.closeButton.hidden = YES;
    
    if (![KSDebugUserDefault getUserHadClicedMemoryBtn]) {
        [KSDebugToastView toast:@"再点击“内存信息”可取消查看哦！^_^" toView:self.debugViewReference displaytime:5];
        [KSDebugUserDefault setUserHadClicedMemoryBtn:YES];
    }
}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];
}

-(KSDebugScrollView *)debugScrollView{
    if (_debugScrollView == nil) {
        _debugScrollView = [[KSDebugScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_debugScrollView];
    }
    return _debugScrollView;
}

-(void)closeButtonDidSelect{
    
}

@end
