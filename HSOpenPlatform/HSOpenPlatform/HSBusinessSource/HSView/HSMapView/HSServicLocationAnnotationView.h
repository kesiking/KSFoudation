//
//  HSServicLocationAnnotationView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HSServicLocationCalloutView.h"
#import "HSMapPoiModel.h"

typedef void(^AnnotationSelectedBlock)(void);

@interface HSServicLocationAnnotationView : MAAnnotationView

@property (nonatomic, strong) HSServicLocationCalloutView *calloutView;

@property (nonatomic, strong) HSMapPoiModel *poiModel;

@property (nonatomic, strong) AnnotationSelectedBlock annotationSelectedBlock;

- (void)registerCalloutViewClass:(Class)calloutViewClass;


@end