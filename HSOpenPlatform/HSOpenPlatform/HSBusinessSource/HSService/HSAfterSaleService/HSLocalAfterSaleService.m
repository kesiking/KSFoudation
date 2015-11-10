//
//  HSLocalAfterSaleService.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSLocalAfterSaleService.h"

@implementation HSLocalAfterSaleService

- (void)getLocalAfterSaleWithAppId:(NSString *)appId PageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage {
    self.itemClass = [HSLocalAfterSaleModel class];
//    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:appId forKey:@"appId"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(currentPage) forKey:@"currentPage"];

    [self loadDataListWithAPIName:kHSLocalAfterSaleApiName params:params version:nil];
}

@end
