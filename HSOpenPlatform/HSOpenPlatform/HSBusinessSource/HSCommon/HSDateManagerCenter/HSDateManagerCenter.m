//
//  HSDateManagerCenter.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSDateManagerCenter.h"

@implementation HSDateManagerCenter

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)dealloc{

}

- (void)config{
    [self.inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.outputFormatter setDateFormat:@"yyyy-MM-dd"];
}

-(NSDateFormatter *)inputFormatter{
    if (_inputFormatter == nil) {
        _inputFormatter = [[NSDateFormatter alloc] init];
    }
    return _inputFormatter;
}

-(NSDateFormatter *)outputFormatter{
    if (_outputFormatter == nil) {
        _outputFormatter = [[NSDateFormatter alloc] init];
    }
    return _outputFormatter;
}

-(NSString*)currentTime{
    return [[HSDateManagerCenter sharedCenter].inputFormatter stringFromDate:[NSDate date]];
}

@end
