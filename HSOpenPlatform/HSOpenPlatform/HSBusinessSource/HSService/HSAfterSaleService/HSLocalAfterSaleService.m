//
//  HSLocalAfterSaleService.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSLocalAfterSaleService.h"
#import "HSMapViewManager.h"

@interface HSLocalAfterSaleService ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation HSLocalAfterSaleService

- (void)getLocalAfterSaleWithAppId:(NSString *)appId PageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage {
    self.itemClass = [HSLocalAfterSaleModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:appId forKey:@"appId"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(currentPage) forKey:@"currentPage"];

    //刷新就先定位获取当前坐标
    if (currentPage == 1) {
        [self getUserLocationWithParams:params];
    }
    else {
        [params setObject:@(self.coordinate.longitude) forKey:@"longitude"];
        [params setObject:@(self.coordinate.latitude) forKey:@"latitude"];
        [self loadDataListWithAPIName:kHSLocalAfterSaleApiName params:params version:nil];
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
        [strongSelf loadDataListWithAPIName:kHSLocalAfterSaleApiName params:params version:nil];
    };
    mapViewManager.userLocationLoadFailedBlock = ^(){
        STRONGSELF
        !strongSelf.serviceDidFailLoadBlock?:self.serviceDidFailLoadBlock(self,nil);
    };
    [mapViewManager getUserLocation];
}

@end
