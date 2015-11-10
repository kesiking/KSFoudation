//
//  HSMapViewManager.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/15.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMapViewManager.h"

@interface HSMapViewManager () <MAMapViewDelegate>

@end

@implementation HSMapViewManager

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMapView];
    }
    return self;
}

#pragma mark - Common Methods
+ (HSMapViewManager *)sharedManager {
    static HSMapViewManager *mapViewManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapViewManager = [[HSMapViewManager alloc]init];
    });
    return mapViewManager;
}

- (void)getUserLocation {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
//    [WeAppToast toast:@"正在定位..."];
}

#pragma mark - MAMapViewDelegate
//定位回调一次，并重新设置地图
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"updatingLocation :latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.coordinate = userLocation.coordinate;
        !self.userLocationLoadFinishedBlock?:self.userLocationLoadFinishedBlock(userLocation.coordinate);
        self.mapView.showsUserLocation = NO;
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [WeAppToast toast:@"定位失败，请检查定位设置"];

    !self.userLocationLoadFailedBlock?:self.userLocationLoadFailedBlock();
}

#pragma mark - Common Methods
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = kMAMapAPIKey;   //设置KEY
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    self.mapView.showsUserLocation = NO;                       //YES 为打开定位，NO为关闭定位
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode: MAUserTrackingModeNone]; //地图不跟着位置移动
}

@end
