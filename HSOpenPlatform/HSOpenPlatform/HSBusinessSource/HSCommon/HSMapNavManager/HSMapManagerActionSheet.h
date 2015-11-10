//
//  EHMapManagerActionSheet.h
//  eHome
//
//  Created by 孟希羲 on 15/8/26.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import <MapKit/MapKit.h>

@interface HSMapManagerActionSheet : KSView

/*!
 *  @author 孟希羲, 15-10-13 09:10:48
 *
 *  @brief  弹出ActionSheet选择后跳转到第三方导航，目前支持苹果、高德、百度
 *
 *  @param currentCoordinate 当前位置
 *  @param naviCoordinate    目的地
 *  @param popViewController UIViewController，presentViewController的载体
 *
 *  @since 1.0
 */
+(void)showMapManagerActionSheetWithCurrentPhoneCoordinate:(CLLocationCoordinate2D)currentCoordinate naviCoordinate:(CLLocationCoordinate2D)naviCoordinate withPopViewController:(UIViewController*)popViewController;

@property (nonatomic, strong) UIViewController            *popViewController;

-(void)showMapManagerActionSheetWithCurrentPhoneCoordinate:(CLLocationCoordinate2D)currentCoordinate naviCoordinate:(CLLocationCoordinate2D)naviCoordinate;

@end
