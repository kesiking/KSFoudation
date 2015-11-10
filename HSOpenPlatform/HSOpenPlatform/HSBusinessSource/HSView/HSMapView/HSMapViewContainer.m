//
//  HSMapViewContainer.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSMapViewContainer.h"
#import "HSMapViewManager.h"

static NSString *const kHS_ReCenterBtn_Normal_ImageName        = @"icon_location_n";
static NSString *const kHS_ReCenterBtn_HighLighted_ImageName        = @"icon_location_h";
static NSString *const kHS_BusinesshallPosition_ImageName        = @"icon_Position point";
static NSString *const kHS_MyPosition_ImageName        = @"icon_My position";


@interface HSMapViewContainer ()

@property (nonatomic, strong)NSMutableArray         *poiList;

@property (nonatomic, assign)NSInteger              selectedIndex;

@property (nonatomic, assign)CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, strong)UIButton               *reCenterButton;

@property (nonatomic, assign)BOOL                   isAnnotationSelecting;

@property (nonatomic, strong)Class                  annotationViewClass;

@end

@implementation HSMapViewContainer

-(void)setupView{
    [super setupView];
    
    self.annotationsArray = [[NSMutableArray alloc]init];
    self.poiList = [[NSMutableArray alloc]init];
    self.isAnnotationSelecting = YES;
    self.annotationViewClass = [HSServicLocationAnnotationView class];
    
    [self configMapView];
    [self addSubview:self.reCenterButton];
}

#pragma mark - Common Methods
- (void)registerAnnotationViewClass:(Class)annotationViewClass {
    self.annotationViewClass = annotationViewClass;
}

- (void)selecteAtIndex:(NSInteger)index WithPoiList:(NSArray *)poiList {
    if (poiList.count == 0) {
        return;
    }
    self.poiList = [poiList mutableCopy];
    self.selectedIndex = index;
    [self resetAnnotations];

    for (NSInteger i = 0; i < poiList.count; i++) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
        HSMapPoiModel *poiModel = poiList[i];
        annotation.coordinate = CLLocationCoordinate2DMake(poiModel.coordinate.latitude, poiModel.coordinate.longitude);
        [self.annotationsArray addObject:annotation];
    }
    [self.mapView addAnnotations:self.annotationsArray];
    [self reCenterMap];
}

- (void)resetAnnotations {
    [self.annotationsArray removeAllObjects];
    for (NSInteger i = 0; i < self.mapView.selectedAnnotations.count; i++) {
        [self.mapView deselectAnnotation:self.mapView.selectedAnnotations[i] animated:NO];
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reCenterMap{
    [self.mapView showAnnotations:self.annotationsArray animated:YES];
    HSMapPoiModel *poiModel = self.poiList[self.selectedIndex];
    [self.mapView setCenterCoordinate:poiModel.coordinate animated:YES];

    [self hideReCenterButton];
}

- (void)showReCenterButton {
    [UIView animateWithDuration:0.5 animations:^{
        self.reCenterButton.alpha = 1;
    }];
}

- (void)hideReCenterButton {
    [UIView animateWithDuration:0.5 animations:^{
        self.reCenterButton.alpha = 0;
    }];
}

- (void)reCenterButtonClick:(id)sender {
    [self reCenterMap];
    [self.mapView selectAnnotation:self.annotationsArray[self.selectedIndex] animated:YES];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        HSServicLocationAnnotationView *annotationView = (HSServicLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[self.annotationViewClass alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:kHS_BusinesshallPosition_ImageName];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);

        NSInteger index = [self.annotationsArray indexOfObject:annotation];
        annotationView.poiModel = self.poiList[index];
        WEAKSELF
        annotationView.annotationSelectedBlock = ^(){
            STRONGSELF
            strongSelf.selectedIndex = index;
            strongSelf.isAnnotationSelecting = YES;
            
            HSMapPoiModel *poiModel = strongSelf.poiList[index];
            [strongSelf.mapView setCenterCoordinate:poiModel.coordinate animated:YES];
            strongSelf.viewController.title = poiModel.name;
        };

        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:kHS_MyPosition_ImageName];
        annotationView.canShowCallout = YES;
        return annotationView;
    }

    return nil;
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    if (!self.isAnnotationSelecting) {
        [self showReCenterButton];
    }
    else {
        [self hideReCenterButton];
        self.isAnnotationSelecting = NO;
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView selectAnnotation:self.annotationsArray[self.selectedIndex] animated:YES];
    });
}

#pragma mark - Getters And Setters
- (void)configMapView{
    [MAMapServices sharedServices].apiKey = kMAMapAPIKey;       //设置KEY
    _mapView = [HSMapViewManager sharedManager].mapView;
    _mapView.frame = self.bounds;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;                       //YES 为打开定位，NO为关闭定位
    _mapView.pausesLocationUpdatesAutomatically = YES;      //是否自动暂停位置更新
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    _mapView.showsLabels = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = YES;
    _mapView.scaleOrigin = CGPointMake(70, _mapView.height - 25);
    _mapView.touchPOIEnabled = NO;
  
    [self addSubview:_mapView];
}

- (UIButton *)reCenterButton {
    if (!_reCenterButton) {
        _reCenterButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.height-80, 50, 50)];
        [_reCenterButton setImage:[UIImage imageNamed:kHS_ReCenterBtn_Normal_ImageName] forState:UIControlStateNormal];
        [_reCenterButton setImage:[UIImage imageNamed:kHS_ReCenterBtn_HighLighted_ImageName] forState:UIControlStateHighlighted];
        [_reCenterButton addTarget:self action:@selector(reCenterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _reCenterButton.alpha = 0;
    }
    return _reCenterButton;
}

@end
