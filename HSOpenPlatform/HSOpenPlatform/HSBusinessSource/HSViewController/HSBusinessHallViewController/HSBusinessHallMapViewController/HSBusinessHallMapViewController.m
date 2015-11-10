//
//  HSBusinessHallMapViewController.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessHallMapViewController.h"
#import "HSMapViewContainer.h"

@interface HSBusinessHallMapViewController ()

@property (nonatomic, strong) HSMapViewContainer *mapView;

@property (nonatomic, strong) NSMutableArray *poiList;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation HSBusinessHallMapViewController

-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query nativeParams:(NSDictionary *)nativeParams{
    self = [super initWithNavigatorURL:URL query:query nativeParams:nativeParams];
    if (self) {
        self.poiList = [nativeParams objectForKey:@"poiList"];
        self.selectedIndex = [[nativeParams objectForKey:@"selectedIndex"] integerValue];
        HSMapPoiModel *poiModel = self.poiList[self.selectedIndex];
        self.title = poiModel.name;

        NSLog(@"self.poiList = %@",self.poiList);
        NSLog(@"self.selectedIndex = %ld",self.selectedIndex);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.mapView selecteAtIndex:self.selectedIndex WithPoiList:self.poiList];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mapView.mapView.delegate = nil;

}


- (HSMapViewContainer *)mapView {
    if (!_mapView) {
        _mapView = [[HSMapViewContainer alloc]initWithFrame:self.view.bounds];
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
