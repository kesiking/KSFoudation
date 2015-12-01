//
//  WeAppDebugCPUView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugCPUView.h"
#import "KSServiceDebug_CPUModel.h"

@interface KSDebugCPUView()

@property (nonatomic,strong) KSServiceDebug_CPUModel* cpuModel;

@end

@implementation KSDebugCPUView

-(void)load{
    [super load];
    self.plotsView.alpha = 0.9f;
    self.plotsView.lineColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    self.plotsView.capacity = MAX_CPU_HISTORY;
    _cpuModel = [KSServiceDebug_CPUModel new];
    _cpuModel.delegate = self;
    [self setLableTitle:@"CPU"];
}

-(void)unload{
    [super unload];
    self.plotsView = nil;
    [self.cpuModel cancelTimer];
    _cpuModel.delegate = nil;
    self.cpuModel = nil;
}

-(void)dataDidChanged:(KSDebugMemoryModel *)debugModel{
    float percent = self.cpuModel.usage;
    if ( percent >= 0.9f )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6f];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:999999];
        
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6f];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:1];
        
        self.backgroundColor = KSDebugRGB_A(0x00, 0x00, 0x00, 0.6);
        
        [UIView commitAnimations];
    }
    
    [self.plotsView setPlots:self.cpuModel.chartDatas];
    [self.plotsView setLowerBound:self.cpuModel.lowerBound];
    [self.plotsView setUpperBound:self.cpuModel.upperBound];
    [self.plotsView setNeedsDisplay];
    
    [self setLableInfo:[NSString stringWithFormat:@"usage: %.1f%%", percent * 100]];
}

@end
