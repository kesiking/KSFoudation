//
//  HSNationalAfterSaleService.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSNationalAfterSaleService.h"

@implementation HSNationalAfterSaleService

- (void)getNationalAfterSaleWithAppId:(NSString *)appId {
    self.itemClass = [HSNationalAfterSaleModel class];
//    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    [self loadItemWithAPIName:kHSNationalAfterSaleApiName params:@{@"appId":appId} version:nil];
}

@end
