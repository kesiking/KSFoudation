//
//  EHUpdateMessageNumberService.m
//  eHome
//
//  Created by 孟希羲 on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSUpdateMessageNumberService.h"

@implementation HSUpdateMessageNumberService

-(void)updateMessageNumberWithUserPhone:(NSString *)userPhone{
    if (userPhone == nil) {
        userPhone = [KSAuthenticationCenter userPhone];
    }
    if (userPhone == nil) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"phone"];
    }
    [params setObject:@"result" forKey:@"__jsonTopKey__"];
    
    [self loadItemWithAPIName:kHSUpdateMessageNumberApiName params:params version:nil];
}

@end
