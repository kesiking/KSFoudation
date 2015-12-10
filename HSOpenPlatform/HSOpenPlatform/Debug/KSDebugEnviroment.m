//
//  WeAppDebugEnviroment.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugEnviroment.h"

@implementation KSDebugEnviroment

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    _filePathArray = [NSMutableArray array];
}

@end
