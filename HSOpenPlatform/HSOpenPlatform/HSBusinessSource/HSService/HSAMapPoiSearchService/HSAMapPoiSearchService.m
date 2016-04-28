//
//  HSAMapPoiSearchService.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAMapPoiSearchService.h"
#import "HSMapViewManager.h"

#define kHSSearchKeyWord @"移动营业厅"

@interface HSAMapPoiSearchService ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HSAMapPoiSearchService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.offset = 10;
        [self configSearchRequest];
    }
    return self;
}

- (void)searchPoiWithPageNumber:(NSInteger)pageNumber {
    if (pageNumber == 1) {
        [self getUserLocation];
    }
    else {
        [self.search AMapPOIAroundSearch: [self getSearchRequestAtPage:pageNumber]];
    }
}


/**
 *  定位获取位置
 */
- (void)getUserLocation {
    HSMapViewManager *mapViewManager = [HSMapViewManager sharedManager];
    WEAKSELF
    mapViewManager.userLocationLoadFinishedBlock = ^(CLLocationCoordinate2D coordinate){
        STRONGSELF
        strongSelf.coordinate = coordinate;
        strongSelf.currentPage = 1;
        
        [strongSelf.search AMapPOIAroundSearch: [strongSelf getSearchRequestAtPage:strongSelf.currentPage]];
    };
    mapViewManager.userLocationLoadFailedBlock = ^(){
        STRONGSELF
        !strongSelf.searchFailedBlock?:strongSelf.searchFailedBlock();
    };
    [mapViewManager getUserLocation];
}

#pragma mark - AMapSearchDelegate
/**
 *  实现POI搜索对应的回调函数
 */
- (void)onPOISearchDone:(AMapPOIAroundSearchRequest *)request response:(AMapPOISearchResponse *)response
{
    NSMutableArray *poiModelArray = [[NSMutableArray alloc]init];
    for (AMapPOI *p in response.pois) {
        HSMapPoiModel *poiModel = [[HSMapPoiModel alloc]initWithAMapPoi:p];
        [poiModelArray addObject:poiModel];
    }
    !self.searchFinishedBlock?:self.searchFinishedBlock(poiModelArray);
}

/**
 *  搜索失败回调
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    [WeAppToast toast:@"加载失败"];
    !self.searchFailedBlock?:self.searchFailedBlock();
}

#pragma mark - Set Request
- (void)configSearchRequest {
    [AMapSearchServices sharedServices].apiKey = kMAMapAPIKey;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (AMapPOIAroundSearchRequest *)getSearchRequestAtPage:(NSInteger)page {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    request.keywords = kHSSearchKeyWord;
    request.sortrule = 0;
    request.requireExtension = YES;
    request.offset = self.offset;
    request.page = page;
    return request;
}

@end
