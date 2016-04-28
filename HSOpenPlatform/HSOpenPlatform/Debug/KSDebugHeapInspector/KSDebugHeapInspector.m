//
//  KSDebugHeapInspector.m
//  KSDebug
//
//  Created by 孟希羲 on 16/4/22.
//  Copyright © 2016年 贯众爱家. All rights reserved.
//

#import "KSDebugHeapInspector.h"
#import "KSDebugOperationView.h"
#import "HINSPDebug.h"

@implementation KSDebugHeapInspector

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"内存泄露",@"title",NSStringFromClass([self class]),@"className", nil]];
}

-(void)startDebug{
    [super startDebug];
    [HINSPDebug start];
    [HINSPDebug addClassPrefixesToRecord:self.debugEnviromeng.classPrefixesToRecord];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSDebugBasicViewHideOperationViewNotification object:self userInfo:@{}];
}

-(void)endDebug{
    [super endDebug];
    [HINSPDebug stop];
}

@end
