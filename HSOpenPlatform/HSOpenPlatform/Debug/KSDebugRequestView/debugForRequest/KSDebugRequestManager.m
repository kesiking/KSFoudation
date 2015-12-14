//
//  KSDebugRequestManager.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/3.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestManager.h"
#import "KSDebugUtils.h"

@interface KSDebugRequestManager ()

@end

@implementation KSDebugRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestArray = [[NSMutableArray alloc]init];
    }
    return self;
}

static KSDebugRequestManager *requestManager;
+ (KSDebugRequestManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[KSDebugRequestManager alloc]init];
    });
    return requestManager;
}

+ (void)resetManager {
    [[KSDebugRequestManager sharedManager].requestArray removeAllObjects];

    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:KSDebugRequestFlowCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

