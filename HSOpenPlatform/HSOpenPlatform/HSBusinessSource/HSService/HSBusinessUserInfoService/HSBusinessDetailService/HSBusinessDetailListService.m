//
//  HSBusinessDetailListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessDetailListService.h"

@implementation HSBusinessDetailListService

-(void)loadBusinessDetailListWithUserPhone:(NSString*)userPhone productId:(NSString*)productId{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if ([EHUtils isEmptyString:productId]) {
        EHLogError(@"productId is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"phone"];
    }
    if (productId) {
        [params setObject:productId forKey:@"productId"];
    }
    
    self.itemClass = [HSBusinessDetailModel class];
    
    [self loadDataListWithAPIName:kHSGetBusinessUserNickNameApiName params:params version:nil];
}

@end
