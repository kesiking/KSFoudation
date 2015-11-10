//
//  HSMapViewManager.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/15.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserLocationLoadFinishedBlock)(CLLocationCoordinate2D coordinate);
typedef void(^UserLocationLoadFailedBlock)  (void);


@interface HSMapViewManager : NSObject

@property (nonatomic, strong)MAMapView *mapView;

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@property (nonatomic, strong)UserLocationLoadFinishedBlock userLocationLoadFinishedBlock;

@property (nonatomic, strong)UserLocationLoadFailedBlock userLocationLoadFailedBlock;

+ (HSMapViewManager *)sharedManager;

- (void)getUserLocation;

@end
