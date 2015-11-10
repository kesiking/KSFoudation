//
//  HSFamilyAppListService.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSFamilyAppListService.h"
#import "HSApplicationModel.h"

@implementation HSFamilyAppListService

-(void)loadFamilyAppListData{
    
    self.itemClass = [HSApplicationModel class];
    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    [self loadDataListWithAPIName:kHSFamilyAppInfoListApiName params:nil version:nil];

    
    
//    self.itemClass = [EHBabyAlarmModel class];
//    
//    // service 是否需要cache
//    self.needCache = NO;
//    self.onlyUserCache = NO;
//    self.jsonTopKey = @"responseData";
//    
//    [self loadDataListWithAPIName:kEHGetBabyAlarmApiName params:@{kEHBabyId : babyId} version:nil];
}


@end
