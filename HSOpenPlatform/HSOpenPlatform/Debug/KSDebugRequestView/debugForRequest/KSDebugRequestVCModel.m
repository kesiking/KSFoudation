//
//  KSDebugRequestVCModel.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestVCModel.h"

@implementation KSDebugRequestVCModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestedVC = nil;
        self.requestCount = 0;
        self.latestTime = nil;
        self.totalTime = 0;
        self.flowCount = 0;
        self.requestArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
