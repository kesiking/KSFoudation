//
//  HSActivityInfoPageListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoPageListService.h"
#import "HSActivityInfoModel.h"

@implementation HSActivityInfoPageListService

-(void)loadActivityInfoPageListWithUserPhone:(NSString*)userPhone{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if ([EHUtils isNotEmptyString:userPhone]) {
        [params setObject:userPhone forKey:@"userPhone"];
    }
    
    KSPaginationItem* pagnation = [KSPaginationItem new];
    pagnation.pageSize = DEFAULT_PAGE_SIZE;
    
    self.jsonTopKey = nil;
    self.listPath = RESPONSE_DATA_KEY;
    self.itemClass = [HSActivityInfoModel class];
    
    if (self.pagedList) {
        [self.pagedList refresh];
        [self.pagedList removeAllObjects];
    }
    
    [self loadPagedListWithAPIName:kHSActivityInfoListApiName params:params pagination:pagnation version:nil];
}

@end
