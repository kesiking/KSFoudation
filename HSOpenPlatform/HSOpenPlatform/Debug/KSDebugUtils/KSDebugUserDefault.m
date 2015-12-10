//
//  KSDebugUserDefault.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/4.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugUserDefault.h"

#define KSDebug_UserHadClicedLayoutInfoBtn  @"UserHadClicedLayoutInfoBtn"
#define KSDebug_UserHadClicedMemoryBtn      @"UserHadClicedMemoryBtn"
#define KSDebug_UserHadClicedGridBtn        @"UserHadClicedGridBtn"

@implementation KSDebugUserDefault

+(BOOL)getUserHadClicedLayoutInfoBtn{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KSDebug_UserHadClicedLayoutInfoBtn];
}

+(void)setUserHadClicedLayoutInfoBtn:(BOOL)userHadClicedLayoutInfoBtn{
    [[NSUserDefaults standardUserDefaults] setBool:userHadClicedLayoutInfoBtn forKey:KSDebug_UserHadClicedLayoutInfoBtn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getUserHadClicedMemoryBtn{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KSDebug_UserHadClicedMemoryBtn];
}

+(void)setUserHadClicedMemoryBtn:(BOOL)userHadClicedMemoryBtn{
    [[NSUserDefaults standardUserDefaults] setBool:userHadClicedMemoryBtn forKey:KSDebug_UserHadClicedMemoryBtn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getUserHadClicedGridBtn{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KSDebug_UserHadClicedGridBtn];
}

+(void)setUserHadClicedGridBtn:(BOOL)userHadClicedGridBtn{
    [[NSUserDefaults standardUserDefaults] setBool:userHadClicedGridBtn forKey:KSDebug_UserHadClicedGridBtn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
