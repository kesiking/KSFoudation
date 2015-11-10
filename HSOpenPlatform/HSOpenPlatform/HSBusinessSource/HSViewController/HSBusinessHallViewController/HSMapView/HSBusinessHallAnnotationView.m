//
//  HSBusinessHallAnnotationView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessHallAnnotationView.h"
#import "HSMapViewManager.h"
#import "HSMapManagerActionSheet.h"

#define kCalloutWidth       caculateNumber(265)
#define kCalloutHeight      caculateNumber(66)

@implementation HSBusinessHallAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        [self showCalloutView];
        !self.annotationSelectedBlock?:self.annotationSelectedBlock();
    }
    else
    {
        [self hideCalloutView];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)showCalloutView {
    self.calloutView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self addSubview:self.calloutView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.calloutView.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
    }];
}

- (void)hideCalloutView {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.calloutView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self.calloutView removeFromSuperview];
    }];
}

#pragma mark - Getters And Setters
- (void)setPoi:(AMapPOI *)poi {
    _poi = poi;
    self.calloutView.name = poi.name;
    self.calloutView.distance = poi.distance;
    self.calloutView.address = [NSString stringWithFormat:@"%@%@",poi.district,poi.address];
}

- (HSBusinessHallCalloutView *)calloutView {
    if (!_calloutView) {
        _calloutView = [[HSBusinessHallCalloutView alloc]init];
        _calloutView.layer.anchorPoint = CGPointMake(0.5, 1);
        _calloutView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        _calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, self.calloutOffset.y);
        WEAKSELF
        _calloutView.navigateButtonClickBlock = ^(){
            STRONGSELF
            CLLocationCoordinate2D currentCoordinate = [HSMapViewManager sharedManager].coordinate;
            CLLocationCoordinate2D naviCoordinate = CLLocationCoordinate2DMake(strongSelf.poi.location.latitude, strongSelf.poi.location.longitude);
            [HSMapManagerActionSheet showMapManagerActionSheetWithCurrentPhoneCoordinate:currentCoordinate naviCoordinate:naviCoordinate withPopViewController:strongSelf.viewController];
        };
    }
    return _calloutView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

@end
