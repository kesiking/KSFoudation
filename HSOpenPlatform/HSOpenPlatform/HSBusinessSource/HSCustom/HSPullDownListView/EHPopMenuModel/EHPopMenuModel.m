//
//  EHPopMenuModel.m
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHPopMenuModel.h"

@implementation EHPopMenuModel

- (instancetype)initWithTitleText:(NSString*)titleText
{
    self = [super init];
    if (self) {
        self.titleText = titleText;
    }
    return self;
}

@end
