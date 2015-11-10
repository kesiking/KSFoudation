//
//  HSMapViewContainer.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"

@interface HSMapViewContainer : KSView <MAMapViewDelegate>

@property (nonatomic, strong)MAMapView *mapView;

@property (nonatomic, strong)NSMutableArray *annotationsArray;

- (void)selecteAtIndex:(NSInteger)index WithPoiList:(NSArray *)poiList;

@end
