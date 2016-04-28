//
//  KSDebugResponseEventsModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/23.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugResponseEventsModel : NSObject

@property (strong,nonatomic) NSString *eventId;

@property (strong,nonatomic) NSDate *beginTime;

@property (strong,nonatomic) NSDate *finishTime;

@property (assign,nonatomic) NSTimeInterval timeSpent;

@property (strong,nonatomic) NSString *viewControllerName;

@property (assign,nonatomic) BOOL isContentEmpty;

@property (strong,nonatomic) NSError *error;

@property (strong,nonatomic) NSDictionary *param;

@end
