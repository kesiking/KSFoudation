//
//  HSMapPoiModel.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "HSLocalAfterSaleModel.h"

@interface HSMapPoiModel : WeAppComponentBaseItem

@property (nonatomic, copy)   NSString *name;                    //!< 名称

@property (nonatomic, copy)   NSString *address;                 //!< 地址

@property (nonatomic, copy)   NSString *tel;                     //!< 电话

@property (nonatomic, assign) NSInteger distance;                //!< 距中心点距离

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; //!< 经纬度

- (instancetype)initWithAMapPoi:(AMapPOI*)poi;

- (instancetype)initWithLocalAfterSaleModel:(HSLocalAfterSaleModel*)model;

@end
