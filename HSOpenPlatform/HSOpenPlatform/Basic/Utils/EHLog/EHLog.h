//
//  EHLog.h
//  eHome
//
//  Created by louzhenhua on 15/6/2.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"
#import "EHLogFormatter.h"

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelVerbose;
#endif

#define EHLogError      DDLogError
#define EHLogWarn       DDLogWarn
#define EHLogInfo       DDLogInfo
#define EHLogDebug      DDLogDebug
#define EHLogVerbose    DDLogVerbose

@interface EHLog : NSObject

+ (void)initEHLog;

@end
