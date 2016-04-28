//
//  HSBusinessUserInfoModifyService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoModifyService.h"

@implementation HSBusinessUserInfoModifyService

-(void)modifyBusinessUserInfoWithUserPhone:(NSString *)userPhone memberPhone:(NSString *)memberPhone deviceId:(NSNumber*)deviceId nickName:(NSString*)nickName{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if (deviceId == nil) {
        EHLogError(@"deviceId is nil!");
        return;
    }
    if ([EHUtils isEmptyString:nickName]) {
        EHLogError(@"nickName is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    if (deviceId) {
        [params setObject:deviceId forKey:@"deviceId"];
    }
    
    if (memberPhone && nickName) {
        NSArray* member = @[@{@"memberPhone":memberPhone,@"nickname":nickName}];
        [params setObject:member forKey:@"member"];
    }
    
    if (params) {
        [self loadItemWithAPIName:kHSModifyBusinessUserNickNameApiName params:params version:nil];
    }else{
        EHLogError(@"getJSONStringWithDictionary is failed!");
    }
}

@end
