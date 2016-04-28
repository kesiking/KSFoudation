//
//  HSMapPoiModel.m
//  HSOpenPlatform
//
//  Created by xtq on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMapPoiModel.h"

@implementation HSMapPoiModel

- (instancetype)initWithAMapPoi:(AMapPOI*)poi {
    self = [super init];
    if (self) {
        self.name       = poi.name;
        self.tel        = poi.tel;
        self.distance   = poi.distance;
        self.address    = [NSString stringWithFormat:@"%@%@",poi.district,poi.address];
        self.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    }
    return self;
}

- (instancetype)initWithAfterSaleModel:(HSAfterSaleModel*)model {
    self = [super init];
    if (self) {
        self.name       = model.outletsName;
        self.tel        = model.outletsTel;
        self.address    = model.outletsAddress;
        self.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
        
        CLLocationDistance distance;
        if ([self isEmptyCoordinate:self.coordinate]) {
            distance = 0;
        }
        else {
            MAMapPoint point1 = MAMapPointForCoordinate(self.coordinate);
            MAMapPoint point2 = MAMapPointForCoordinate(model.currentCoordinate);
            //2.计算距离
            distance = MAMetersBetweenMapPoints(point1,point2);
        }
        self.distance = distance;
    }
    return self;
}

- (BOOL)isEmptyCoordinate:(CLLocationCoordinate2D)coordinate2D {
    if (coordinate2D.latitude == 0 && coordinate2D.longitude == 0) {
        return YES;
    }
    return NO;
}

@end
