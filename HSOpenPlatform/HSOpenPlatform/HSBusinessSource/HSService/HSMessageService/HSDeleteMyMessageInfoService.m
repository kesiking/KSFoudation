//
//  HSDeleteMyMessageInfoService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSDeleteMyMessageInfoService.h"

@implementation HSDeleteMyMessageInfoService

-(void)deleteMyMessagesInfoWithUserPhone:(NSString*)userPhone messageIds:(NSArray*)messageIds{
    if ([EHUtils isEmptyString:userPhone] || [WeAppUtils isEmpty:messageIds]) {
        return;
    }
    // 获取数组拼接字符串
    NSString* messageIdStr = [WeAppUtils getCollectionStringWithKeys:messageIds withSeparatedByString:@","];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ([EHUtils isNotEmptyString:messageIdStr]) {
        [params setObject:messageIdStr forKey:@"msgIds"];
    }
    [params setObject:userPhone forKey:@"userPhone"];
    
    [self loadObjectValueWithAPIName:kHSDeleteMyMessageInfoApiName params:params version:nil];
}

@end
