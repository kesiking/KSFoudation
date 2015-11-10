//
//  HSActivityInfoDetailService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoDetailService.h"
#import "HSActivityInfoModel.h"

@implementation HSActivityInfoDetailService

-(void)loadActivityInfoDetailWithActivityId:(NSString*)activityId userPhone:(NSString*)userPhone{
    if ([EHUtils isEmptyString:activityId]) {
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:activityId forKey:@"activityId"];
    if ([EHUtils isNotEmptyString:userPhone]) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    self.jsonTopKey = RESPONSE_DATA_KEY;
    self.itemClass = [HSActivityInfoModel class];

    [self loadItemWithAPIName:kHSActivityInfoDetailApiName params:params version:nil];
}

@end
