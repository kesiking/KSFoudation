//
//  HSBusinessUserInfoModifyService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoModifyService.h"

@implementation HSBusinessUserInfoModifyService

-(void)modifyBusinessUserInfoWithUserPhone:(NSString *)userPhone appId:(NSString*)appId nickName:(NSString*)nickName userTrueName:(NSString*)tureName{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if ([EHUtils isEmptyString:appId]) {
        EHLogError(@"appId is nil!");
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
    if (appId) {
        [params setObject:appId forKey:@"appId"];
    }
    if (nickName) {
        [params setObject:nickName forKey:@"nickname"];
    }
    if (tureName) {
        [params setObject:tureName forKey:@"realname"];
    }
    
    NSString* paramStr = [WeAppUtils getJSONStringWithDictionary:params];
    
    if (paramStr) {
        [self loadItemWithAPIName:kHSModifyBusinessUserNickNameApiName params:@{@"UserNickname":paramStr} version:nil];
    }else{
        EHLogError(@"getJSONStringWithDictionary is failed!");
    }
}

@end
