//
//  WeAppDebugEngineInfoTextView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-6.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugEngineInfoTextView.h"
#import "WeAppConstant.h"

@implementation KSDebugEngineInfoTextView

#ifdef DEBUG
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"基本信息",@"title",NSStringFromClass([self class]),@"className", nil]];
}
#endif

-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"基本信息"];
}

-(void)startDebug{
    [super startDebug];
    
    self.debugTextView.text = nil;
}

-(void)endDebug{
    [super endDebug];
}

@end
