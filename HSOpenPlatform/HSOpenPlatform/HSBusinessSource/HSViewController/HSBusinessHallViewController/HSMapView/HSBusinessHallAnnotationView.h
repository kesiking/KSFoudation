//
//  HSBusinessHallAnnotationView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HSBusinessHallCalloutView.h"

typedef void(^AnnotationSelectedBlock)(void);

@interface HSBusinessHallAnnotationView : MAAnnotationView

@property (nonatomic, strong) HSBusinessHallCalloutView *calloutView;

@property (nonatomic, strong) AMapPOI *poi;

@property (nonatomic, strong) AnnotationSelectedBlock annotationSelectedBlock;

@end