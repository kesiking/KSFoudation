//
//  KSDebugFlexView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 16/4/27.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSDebugFlexView.h"
#import "KSDebugOperationView.h"
#import "FLEXManager.h"

@implementation KSDebugFlexView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"FLEX",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)startDebug{
    [super startDebug];
    [[FLEXManager sharedManager] showExplorer];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSDebugBasicViewHideOperationViewNotification object:self userInfo:@{}];
}

-(void)endDebug{
    [super endDebug];
    [[FLEXManager sharedManager] hideExplorer];
}

@end
