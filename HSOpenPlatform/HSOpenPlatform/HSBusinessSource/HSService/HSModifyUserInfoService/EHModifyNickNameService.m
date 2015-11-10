//
//  EHModifyNickNameService.m
//  eHome
//
//  Created by xtq on 15/6/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyNickNameService.h"

@implementation EHModifyNickNameService

-(void)modifyNickNameWithUserPhone:(NSString *)userPhone nickName:(NSString*)nickName{
    if (userPhone == nil) {
        userPhone = [KSLoginComponentItem sharedInstance].user_phone;
    }
    if (nickName == nil) {
        EHLogError(@"nakeName is nil");
        return;
    }
    [self loadItemWithAPIName:kHSModifyUserInfoApiName params:@{@"user_phone":userPhone,@"nick_name":nickName,@"flag":@"00000100"} version:nil];
}

@end
