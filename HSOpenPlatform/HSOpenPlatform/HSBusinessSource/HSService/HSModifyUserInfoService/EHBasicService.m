//
//  EHBasicService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/28.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "EHBasicService.h"

#define EH_DEFAULT_SCHEME @"https"
#define EH_DEFAULT_HOST @"112.54.207.8"
#define EH_DEFAULT_PORT @"8081"
#define EH_DEFAULT_PARH @"PersonSafeManagement/"
#define EH_DEFAULT_BASE_URL [NSString stringWithFormat:@"%@://%@:%@/%@",EH_DEFAULT_SCHEME,EH_DEFAULT_HOST,EH_DEFAULT_PORT,EH_DEFAULT_PARH]

@implementation EHBasicService

-(void)setupService{
    [super setupService];
    self.serviceContext.baseUrl = EH_DEFAULT_BASE_URL;
    [self.serviceContext.serviceContextDict setObject:@"outPut_msg" forKey:@"resultString"];
    [self.serviceContext.serviceContextDict setObject:@"outPut_time" forKey:@"resultTime"];
    [self.serviceContext.serviceContextDict setObject:@"outPut_status" forKey:@"resultCode"];
    [self.serviceContext.serviceContextDict setObject:@YES forKey:@"requestSerializerNeedJson"];
    [self.serviceContext.serviceContextDict setObject:@"text/html" forKey:@"Content-Type"];
}

@end
