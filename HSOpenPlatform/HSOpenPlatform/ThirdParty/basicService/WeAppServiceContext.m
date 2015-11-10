//
//  WeAppServiceContext.m
//  eHome
//
//  Created by 孟希羲 on 15/6/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "WeAppServiceContext.h"

@implementation WeAppServiceContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serviceContextDict = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
