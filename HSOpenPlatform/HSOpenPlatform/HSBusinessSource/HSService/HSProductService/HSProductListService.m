//
//  HSProductListService.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductListService.h"

@implementation HSProductListService

- (void)loadProductListWithBusinessId:(NSUInteger)businessId {
    self.itemClass = [HSProductInfoModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    NSDictionary *param;
    if (businessId) {
        param = @{@"businessId":@(businessId)};
    }
    [self loadDataListWithAPIName:kHSProductListApiName params:param version:nil];
}

@end
