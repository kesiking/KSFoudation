//
//  EHLogFormatter.h
//  eHome
//
//  Created by louzhenhua on 15/5/20.
//  Copyright (c) 2015年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Disable legacy macros
#ifndef DD_LEGACY_MACROS
#define DD_LEGACY_MACROS 0
#endif

#import "DDLog.h"

@interface EHLogFormatter : NSObject <DDLogFormatter>

- (instancetype)init;

@end
