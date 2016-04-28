//
//  HSDeviceInfoService.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSDeviceInfoService.h"
#import "HSDeviceInfoModel.h"

@implementation HSDeviceInfoService

- (void)loadDeviceInfoWithUserPhone:(NSString *)userPhone deviceId:(NSNumber *)deviceId{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if (deviceId == nil) {
        EHLogError(@"deviceId is nil!");
        return;
    }
    self.itemClass = [HSDeviceInfoModel class];
    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:userPhone forKey:@"userPhone"];
    [params setObject:deviceId forKey:@"deviceId"];

    [self loadItemWithAPIName:kHSDeviceInfoApiName params:params version:nil];

}

@end
