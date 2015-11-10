//
//  HSActivityAdvertisementListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityAdvertisementListService.h"
#import "HSActivityInfoModel.h"

@implementation HSActivityAdvertisementListService

-(void)loadActivityAdvertisementListDataWithUserPhone:(NSString*)userPhone{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([EHUtils isNotEmptyString:userPhone]) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    self.itemClass = [HSActivityInfoModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    [self loadDataListWithAPIName:kHSGetActivityAdvertisementListApiName params:params version:nil];
}

@end
