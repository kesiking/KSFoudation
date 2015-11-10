//
//  HSSubscribedBussinessBasicService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSSubscribedBussinessBasicService.h"
#import "HSSubscribedBussinessBasicModel.h"

@implementation HSSubscribedBussinessBasicService

-(void)loadSubscribedBussinessDataListWithUserPhone:(NSString*)userPhone bussinessId:(NSString*)bussinessId{
    if ([EHUtils isEmptyString:userPhone] || [EHUtils isEmptyString:bussinessId]) {
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:userPhone forKey:@"userPhone"];
    [params setObject:bussinessId forKey:@"bussinessId"];
    
    self.jsonTopKey = RESPONSE_DATA_KEY;
    self.itemClass = [HSSubscribedBussinessBasicModel class];
    
    [self loadDataListWithAPIName:kHSSubscribedBussinessInfoListApiName params:params version:nil];
}

@end
