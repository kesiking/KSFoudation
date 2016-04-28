//
//  HSDeviceListService.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSDeviceListService.h"
#import "HSDeviceModel.h"

@implementation HSDeviceListService

-(void)loadUserDeviceListWithUserPhone:(NSString *)userPhone productId:(NSString *)productId{
    if (userPhone == nil) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    self.itemClass = [HSDeviceModel class];
    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if (userPhone) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    if ([EHUtils isNotEmptyString:productId]) {
        [params setObject:productId forKey:@"productId"];
    }
    
    [self loadDataListWithAPIName:kHSDeviceListApiName params:params version:nil];

}


@end
