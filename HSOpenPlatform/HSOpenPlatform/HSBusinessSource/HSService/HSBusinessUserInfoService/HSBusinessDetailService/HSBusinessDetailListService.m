//
//  HSBusinessDetailListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessDetailListService.h"

@implementation HSBusinessDetailListService

-(void)loadBusinessDetailListWithUserPhone:(NSString*)userPhone appId:(NSString*)appId{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if ([EHUtils isEmptyString:appId]) {
        EHLogError(@"appId is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"phone"];
    }
    if (appId) {
        [params setObject:appId forKey:@"appId"];
    }
    
    self.itemClass = [HSBusinessDetailModel class];
    
    [self loadDataListWithAPIName:kHSGetBusinessUserInfoListApiName params:params version:nil];
}

@end
