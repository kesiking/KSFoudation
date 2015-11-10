//
//  EHLog.m
//  eHome
//
//  Created by louzhenhua on 15/6/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHLog.h"

@implementation EHLog

+ (void)initEHLog
{
    // 实例化 DDLOG
    EHLogFormatter* formatter = [[EHLogFormatter alloc] init];
    [DDTTYLogger sharedInstance].logFormatter = formatter;
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    fileLogger.logFormatter = formatter;
    [DDLog addLogger:fileLogger];
}
@end
