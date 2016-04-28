//
//  HSBusinessUserInfoListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoListService.h"

@interface HSBusinessUserInfoListService()

@end

@implementation HSBusinessUserInfoListService

-(void)loadBusinessUserInfoListWithUserPhone:(NSString*)userPhone deviceId:(NSNumber*)deviceId{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if (deviceId == nil) {
        EHLogError(@"deviceId is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    if (deviceId) {
        [params setObject:deviceId forKey:@"deviceId"];
    }
    
    self.itemClass = [HSBusinessUserAccountInfoModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    [self loadItemWithAPIName:kHSGetBusinessUserNickNameApiName params:params version:nil];
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [super modelDidFinishLoad:model];
}

@end
