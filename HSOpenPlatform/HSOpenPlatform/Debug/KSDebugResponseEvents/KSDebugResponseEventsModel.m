//
//  KSDebugResponseEventsModel.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/23.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugResponseEventsModel.h"

@implementation KSDebugResponseEventsModel

-(void)setFinishTime:(NSDate *)finishTime{
    _finishTime = finishTime;
    _timeSpent = [_finishTime timeIntervalSinceDate:_beginTime];
}

@end
