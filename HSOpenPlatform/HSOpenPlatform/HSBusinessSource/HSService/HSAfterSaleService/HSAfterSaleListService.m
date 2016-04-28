//
//  HSAfterSaleListService.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/24.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSAfterSaleListService.h"
#import "HSMapViewManager.h"

@interface HSAfterSaleListService ()

@end

@implementation HSAfterSaleListService

- (void)getAfterSaleListWithProductId:(NSNumber *)productId PageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage {
    self.itemClass = [HSAfterSaleModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:productId forKey:@"productId"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(currentPage) forKey:@"currentPage"];
    
    //刷新就先定位获取当前坐标
    if (currentPage == 1) {
        [self getUserLocationWithParams:params];
    }
    else {
        [params setObject:@(self.coordinate.longitude) forKey:@"longitude"];
        [params setObject:@(self.coordinate.latitude) forKey:@"latitude"];
        [self loadDataListWithAPIName:kHSAfterSaleListApiName params:params version:nil];
    }
}

- (void)getUserLocationWithParams:(NSMutableDictionary *)params {
    HSMapViewManager *mapViewManager = [HSMapViewManager sharedManager];
    WEAKSELF
    mapViewManager.userLocationLoadFinishedBlock = ^(CLLocationCoordinate2D coordinate){
        STRONGSELF
        strongSelf.coordinate = coordinate;
        
        [params setObject:@(coordinate.longitude) forKey:@"longitude"];
        [params setObject:@(coordinate.latitude) forKey:@"latitude"];
        [strongSelf loadDataListWithAPIName:kHSAfterSaleListApiName params:params version:nil];
    };
    mapViewManager.userLocationLoadFailedBlock = ^(){
        STRONGSELF
        !strongSelf.serviceDidFailLoadBlock?:self.serviceDidFailLoadBlock(self,nil);
    };
    [mapViewManager getUserLocation];
}

@end
