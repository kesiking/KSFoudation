//
//  HSActivityInfoModel.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoModel.h"

@implementation HSActivityInfoModel

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"id":@"activityId",
                           @"startTime":@"activityStartTime",
                           @"endTime":@"activityEndTime",
                           @"targetDesc":@"activityTargetDesc",
                           @"status":@"activityStatus"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

-(NSString *)activityImageUrlForList{
    return self.activityBanner;
}

@end
