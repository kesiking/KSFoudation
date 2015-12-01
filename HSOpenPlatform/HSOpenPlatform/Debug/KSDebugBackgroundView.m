//
//  WeAppDebugBackgroundView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-3.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugBackgroundView.h"

#define random_background_color_low  (180)
#define random_background_color_high (230)

@implementation KSDebugBackgroundView

#ifdef DEBUG
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Debug开关",@"title",@"KSDebugBackgroundView",@"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"组件属性"];
    self.needCancelBackgroundAction = NO;
}

-(void)startDebug{
    [super startDebug];
    
    self.hidden = YES;
    [self removeFromSuperview];
}

-(void)endDebug{
    [super endDebug];
}

-(void)closeButtonDidSelect{
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.needCancelBackgroundAction = NO;
    [self removeFromSuperview];
}

@end
