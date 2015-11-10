//
//  HSMessageService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMyMessageInfoListService.h"

@implementation HSMyMessageInfoListService

-(void)loadMyMessageInfoListWithUserPhone:(NSString*)userPhone{
    if ([EHUtils isEmptyString:userPhone]) {
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:userPhone forKey:@"userPhone"];
    
    KSPaginationItem* pagnation = [KSPaginationItem new];
    pagnation.pageSize = DEFAULT_PAGE_SIZE;
    
    self.jsonTopKey = nil;
    self.listPath = RESPONSE_DATA_KEY;
    self.itemClass = [HSMyMessageModel class];
    
    if (self.pagedList) {
        [self.pagedList refresh];
        [self.pagedList removeAllObjects];
    }
    
    [self loadPagedListWithAPIName:kHSMyMessageInfoListApiName params:params pagination:pagnation version:nil];
}

@end
