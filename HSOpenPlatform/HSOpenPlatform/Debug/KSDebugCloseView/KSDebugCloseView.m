//
//  KSDebugCloseView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugCloseView.h"
#import "KSDebugManager.h"

@implementation KSDebugCloseView

-(void)startDebug{
    [super startDebug];
    [KSDebugManager setupDebugToolsEnable:NO];
}

@end
