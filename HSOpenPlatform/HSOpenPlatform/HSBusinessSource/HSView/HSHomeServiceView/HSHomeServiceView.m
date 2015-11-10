//
//  HSHomeServiceView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeServiceView.h"
#import "HSHomeServiceButton.h"

static NSString *const kHSActivityStr              = @"最新活动";
static NSString *const kHSActivityImageName        = @"img_new_Activity";

static NSString *const kHSBusinessHallStr          = @"附近营业厅";
static NSString *const kHSBusinessHallImageName    = @"img_Nearby";

static NSString *const kHSLocalDiscountStr         = @"售后服务";
static NSString *const kHSLocalDiscountImageName   = @"img_After_sale service";


@interface HSHomeServiceView ()

@property (nonatomic, strong)HSHomeServiceButton *latestActivitiesView;

@property (nonatomic, strong)HSHomeServiceButton *nearbyBusinessHallView;

@property (nonatomic, strong)HSHomeServiceButton *localDiscountView;

@end

@implementation HSHomeServiceView

- (void)setupView {
    [super setupView];
    [self addSubview:self.latestActivitiesView];
    [self addSubview:self.nearbyBusinessHallView];
    [self addSubview:self.localDiscountView];
    [self addSeparatorLines];
}

#pragma mark - Events Response
- (void)showLatestActivities {
    TBOpenURLFromTarget(internalURL(@"HSActivityInfoListViewController"), self);
}

- (void)showNearbyBusinessHall {
    TBOpenURLFromSourceAndParams(internalURL(@"HSBusinessHallListViewController"), self, nil);
}

- (void)showLocalDiscount {
    TBOpenURLFromSourceAndParams(internalURL(@"HSAfterSaleViewController"), self, nil);
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.latestActivitiesView.frame = CGRectMake(0, 0, caculateNumber(215), home_serviceView_height);
    self.nearbyBusinessHallView.frame = CGRectMake(self.latestActivitiesView.width, 0, self.width - self.latestActivitiesView.width, home_serviceView_height/2.0);
    self.localDiscountView.frame = CGRectMake(self.latestActivitiesView.width, home_serviceView_height/2.0, self.nearbyBusinessHallView.width, home_serviceView_height/2.0);
}

#pragma mark - Getters And Setters
- (HSHomeServiceButton *)latestActivitiesView {
    if (!_latestActivitiesView) {
        _latestActivitiesView = [[HSHomeServiceButton alloc]init];
        [_latestActivitiesView setBackgroundImage:[UIImage imageNamed:kHSActivityImageName] forState:UIControlStateNormal];
        [_latestActivitiesView setTitle:kHSActivityStr forState:UIControlStateNormal];
        [_latestActivitiesView addTarget:self action:@selector(showLatestActivities) forControlEvents:UIControlEventTouchUpInside];
    }
    return _latestActivitiesView;
}

- (HSHomeServiceButton *)nearbyBusinessHallView {
    if (!_nearbyBusinessHallView) {
        _nearbyBusinessHallView = [[HSHomeServiceButton alloc]init];
        [_nearbyBusinessHallView setBackgroundImage:[UIImage imageNamed:kHSBusinessHallImageName] forState:UIControlStateNormal];
        [_nearbyBusinessHallView setTitle:kHSBusinessHallStr forState:UIControlStateNormal];
        [_nearbyBusinessHallView addTarget:self action:@selector(showNearbyBusinessHall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nearbyBusinessHallView;
}

- (HSHomeServiceButton *)localDiscountView {
    if (!_localDiscountView) {
        _localDiscountView = [[HSHomeServiceButton alloc]init];
        [_localDiscountView setBackgroundImage:[UIImage imageNamed:kHSLocalDiscountImageName] forState:UIControlStateNormal];
        [_localDiscountView setTitle:kHSLocalDiscountStr forState:UIControlStateNormal];
        [_localDiscountView addTarget:self action:@selector(showLocalDiscount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _localDiscountView;
}

- (void)addSeparatorLines {
    CGRect frame1 = CGRectMake(caculateNumber(215), 0, 0.5, self.height);
    CGRect frame2 = CGRectMake(caculateNumber(215), self.height/2.0, self.width - caculateNumber(215), 0.5);
    
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    [muArr addObject:[NSValue valueWithCGRect:frame1]];
    [muArr addObject:[NSValue valueWithCGRect:frame2]];
    
    for (NSInteger i = 0; i<2; i++) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = EHLinecor1.CGColor;
        layer.frame = [muArr[i] CGRectValue];
        [self.layer addSublayer:layer];
    }
}


@end
