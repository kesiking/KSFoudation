//
//  HSProductInfoService.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductInfoService.h"

@implementation HSProductInfoService

- (void)loadProductInfoWithProductId:(NSNumber *)productId {
    self.itemClass = [HSProductInfoModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    NSDictionary *param;
    if (productId) {
        param = @{@"productId":productId};
    }
    [self loadItemWithAPIName:kHSProductInfoApiName params:param version:nil];

}

@end
