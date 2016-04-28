//
//  HSBusinessUserAccountInfoModel.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserAccountInfoModel.h"

@implementation HSBusinessUserAccountInfoNickNameModel

@end

@implementation HSBusinessUserAccountInfoModel

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
    NSMutableArray* memberTmp = [NSMutableArray new];
    for (HSBusinessUserAccountInfoNickNameModel *userAccountInfoNickName in self.member) {
        userAccountInfoNickName.familiaPhone = self.familiaPhone;
        userAccountInfoNickName.productId = self.productId;
        userAccountInfoNickName.deviceId = self.deviceId;
        if ([userAccountInfoNickName.memberPhone isEqualToString:self.familiaPhone]) {
            userAccountInfoNickName.isUserAccountHousehold = YES;
            [memberTmp insertObject:userAccountInfoNickName atIndex:0];
        }else{
            [memberTmp addObject:userAccountInfoNickName];
        }
    }
    self.member = [memberTmp copy];
}

@end
