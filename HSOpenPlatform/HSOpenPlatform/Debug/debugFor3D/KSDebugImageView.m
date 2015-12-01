//
//  WeAppDebugImageView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-9.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugImageView.h"

@implementation KSDebugImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

-(void)load{
    
}

-(void)unload{
    
}

- (void)dealloc
{
    [self unload];
}

@end
