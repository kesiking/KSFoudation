//
//  WeAppDebugMemory.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugMemory.h"
#import "KSServiceDebug_MemoryModel.h"

#define K	(1024)
#define M	(K * 1024)
#define G	(M * 1024)

@interface KSDebugMemory()

@property (nonatomic,strong) KSServiceDebug_MemoryModel* memoryModel;

@end

@implementation KSDebugMemory

-(void)load{
    [super load];
    self.plotsView.alpha = 0.9f;
    self.plotsView.lineColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    self.plotsView.capacity = MAX_MEMORY_HISTORY;
    _memoryModel = [KSServiceDebug_MemoryModel new];
    _memoryModel.delegate = self;
    [self setLableTitle:@"Memory"];
}

-(void)unload{
    [super unload];
    self.plotsView = nil;
    [self.memoryModel cancelTimer];
    _memoryModel.delegate = nil;
    self.memoryModel = nil;
}

-(void)dataDidChanged:(KSDebugMemoryModel *)debugModel{
    BOOL showWarning = NO;
    
    float percent = self.memoryModel.usage;
    if ( percent >= 0.5f )
    {
        showWarning = YES;
    }
    
    if ( showWarning )
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
    
    [self.plotsView setPlots:self.memoryModel.chartDatas];
    [self.plotsView setLowerBound:self.memoryModel.lowerBound];
    [self.plotsView setUpperBound:self.memoryModel.upperBound];
    [self.plotsView setNeedsDisplay];
    
    NSUInteger used = self.memoryModel.usedBytes;
    NSUInteger total = self.memoryModel.totalBytes;
    
    [self setLableInfo:[NSString stringWithFormat:@"used: %@ free: %@", [self format:used],[self format:(total - used)]]];
}

- (NSString *)format:(int64_t)n
{
    if ( n < K )
    {
        return [NSString stringWithFormat:@"%lldB", n];
    }
    else if ( n < M )
    {
        return [NSString stringWithFormat:@"%.1fK", (float)n / (float)K];
    }
    else if ( n < G )
    {
        return [NSString stringWithFormat:@"%.1fM", (float)n / (float)M];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fG", (float)n / (float)G];
    }
}

@end
