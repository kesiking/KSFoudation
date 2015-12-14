//
//  KSDebugRequestManager.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/3.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDebugRequestModel.h"

@interface KSDebugRequestManager : NSObject

@property (nonatomic, strong)NSMutableArray *requestArray;

+ (KSDebugRequestManager *)sharedManager;

+ (void)resetManager;

@end

