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

- (instancetype)initWithLocalAfterSaleModel:(HSLocalAfterSaleModel*)model {
    self = [super init];
    if (self) {
        self.name       = model.localAfterSaleName;
        self.tel        = model.afterSalePhone;
        self.distance   = [model.distance integerValue];
        self.address    = model.addressDes;
        self.coordinate = CLLocationCoordinate2DMake([model.location[1] doubleValue], [model.location[0] doubleValue]);
    }
    return self;
}

@end
