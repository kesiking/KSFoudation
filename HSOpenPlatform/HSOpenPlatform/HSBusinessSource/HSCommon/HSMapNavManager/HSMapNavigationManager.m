//
//  EHMapNavigationManager.m
//  eHome
//
//  Created by 孟希羲 on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSMapNavigationManager.h"
#import "LocationChange.h"
#import <MapKit/MapKit.h>

@interface HSMapNavigationManager()

@end

@implementation HSMapNavigationManager

+(NSArray *)checkHasOwnApp{
    NSDictionary *mapSchemeDict = @{@"iosamap://navi":@{@"mapDescription":@"高德地图",@"mapImageBundle":@"public_icon_gaode_map"},@"baidumap://map/":@{@"mapDescription":@"百度地图",@"mapImageBundle":@"public_icon_baidumap"},@"iosDefaultMap":@{@"mapDescription":@"苹果地图",@"mapImageBundle":@"public_icon_iosmap"}};
    NSMutableArray *mapsArray = [NSMutableArray array];
    for (NSString* mapSchemeStr in [mapSchemeDict allKeys]) {
        NSURL *mapUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",mapSchemeStr]];
        if ([[UIApplication sharedApplication] canOpenURL:mapUrl] || [@"iosDefaultMap" isEqualToString:mapSchemeStr]) {
            NSDictionary* mapDict = [mapSchemeDict objectForKey:mapSchemeStr];
            if (mapDict == nil || ![mapDict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            NSString* mapDescription = [mapDict objectForKey:@"mapDescription"];
            NSString* mapImageBundle = [mapDict objectForKey:@"mapImageBundle"];
            if (mapDescription == nil) {
                continue;
            }
            [mapsArray addObject:@{@"mapDescription":mapDescription?:@"",@"mapImageBundle":mapImageBundle?:@""}];
        }
    }
    
    return mapsArray;
}

+(void)openMapUrlArrayWithCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate naviCoordinate:(CLLocationCoordinate2D)naviCoordinate withMapDescription:(NSString*)mapDescription{
    if (mapDescription == nil) {
        return;
    }
    if ([mapDescription isEqualToString:@"苹果地图"]) {
        if (IOS_VERSION < 7.0) {//ios6 调用goole网页地图
            NSString *urlString = [[NSString alloc]
                                   initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%.8f,%.8f&dirfl=d",naviCoordinate.latitude,naviCoordinate.longitude];
            
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        }else{//ios7 跳转apple map
            CLLocationCoordinate2D to;
            
            to.latitude = naviCoordinate.latitude;
            to.longitude = naviCoordinate.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
    }else if ([mapDescription isEqualToString:@"百度地图"]) {
        double bdNowLat,bdNowLon,bdLat,bdLon;
        [LocationChange eh_home_bd_encrypt:currentCoordinate.latitude gg_lon:currentCoordinate.longitude bd_lat:&bdNowLat bd_lon:&bdNowLon];
        [LocationChange eh_home_bd_encrypt:naviCoordinate.latitude gg_lon:naviCoordinate.longitude bd_lat:&bdLat bd_lon:&bdLon];
//        bd_encrypt(currentCoordinate.latitude, currentCoordinate.longitude, &bdNowLat, &bdNowLon);
//        bd_encrypt(naviCoordinate.latitude, naviCoordinate.longitude, &bdLat, &bdLon);
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",bdNowLat,bdNowLon,bdLat,bdLon];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }else if([mapDescription isEqualToString:@"高德地图"]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=ehome&lat=%.8f&lon=%.8f&dev=1&style=2",naviCoordinate.latitude,naviCoordinate.longitude]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
