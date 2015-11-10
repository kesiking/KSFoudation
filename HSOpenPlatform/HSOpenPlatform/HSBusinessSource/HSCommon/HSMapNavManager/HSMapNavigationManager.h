//
//  EHMapNavigationManager.h
//  eHome
//
//  Created by 孟希羲 on 15/8/25.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HSMapNavigationManager : NSObject

+(NSArray *)checkHasOwnApp;

+(void)openMapUrlArrayWithCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate naviCoordinate:(CLLocationCoordinate2D)naviCoordinate withMapDescription:(NSString*)mapDescription;

@end
