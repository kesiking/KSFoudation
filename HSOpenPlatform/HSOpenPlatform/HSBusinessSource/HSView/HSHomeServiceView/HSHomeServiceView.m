//
//  HSHomeServiceView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeServiceView.h"
#import "HSHomeServiceActivityButton.h"

static NSString *const kHSActivityStr                    = @"最新活动";
static NSString *const kHSActivityImageName              = @"icon_活动";//@"img_new_activity";
static NSString *const kHSActivityHighlightedImageName      = @"icon_活动_点击";

static NSString *const kHSBusinessHallStr                = @"附近营业厅";
static NSString *const kHSBusinessHallImageName          = @"icon_营业厅";//@"img_nearby";
static NSString *const kHSBusinessHallHighlightedImageName  = @"icon_营业厅_点击";

static NSString *const kHSAfterSaleServiceStr               = @"售后服务";
static NSString *const kHSAfterSaleServiceImageName         = @"icon_售后服务";//@"img_after_sale-service";
static NSString *const kHSAfterSaleServiceHighlightedImageName = @"icon_售后服务_点击";


@interface HSHomeServiceView ()

@property (nonatomic, strong)HSHomeServiceButton *latestActivitiesView;

@property (nonatomic, strong)HSHomeServiceButton *nearbyBusinessHallView;

@property (nonatomic, strong)HSHomeServiceButton *AfterSaleServiceView;

@end

@implementation HSHomeServiceView

- (void)setupView {
    [super setupView];
    [self addSubview:self.latestActivitiesView];
    [self addSubview:self.nearbyBusinessHallView];
    [self addSubview:self.AfterSaleServiceView];
    [self addTopLine];
}

#pragma mark - Events Response
- (void)showLatestActivities {
    TBOpenURLFromTarget(internalURL(@"HSActivityInfoListViewController"), self);
}

- (void)showNearbyBusinessHall {
    TBOpenURLFromSourceAndParams(internalURL(@"HSBusinessHallListViewController"), self, nil);
}

- (void)showAfterSaleService {
    TBOpenURLFromSourceAndParams(internalURL(@"HSAfterSaleViewController"), self, nil);
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat sideSpace = caculateNumber(40)-20;
    CGSize btnSize = CGSizeMake(50+20+20, home_serviceView_height);
    self.latestActivitiesView.frame = CGRectMake(sideSpace, 0, btnSize.width, btnSize.height);
    self.nearbyBusinessHallView.frame = self.latestActivitiesView.frame;
    self.nearbyBusinessHallView.center = CGPointMake(self.width/2.0, self.height/2.0);
    self.AfterSaleServiceView.frame = CGRectMake(self.width-sideSpace-btnSize.width, 0, btnSize.width, btnSize.height);
}

#pragma mark - Getters And Setters
- (HSHomeServiceButton *)latestActivitiesView {
    if (!_latestActivitiesView) {
        _latestActivitiesView = [[HSHomeServiceButton alloc]init];
        [_latestActivitiesView setImage:[UIImage imageNamed:kHSActivityImageName] forState:UIControlStateNormal];
        [_latestActivitiesView setImage:[UIImage imageNamed:kHSActivityHighlightedImageName] forState:UIControlStateHighlighted];
        [_latestActivitiesView setTitle:kHSActivityStr forState:UIControlStateNormal];
        [_latestActivitiesView addTarget:self action:@selector(showLatestActivities) forControlEvents:UIControlEventTouchUpInside];
    }
    return _latestActivitiesView;
}

- (HSHomeServiceButton *)nearbyBusinessHallView {
    if (!_nearbyBusinessHallView) {
        _nearbyBusinessHallView = [[HSHomeServiceButton alloc]init];
        [_nearbyBusinessHallView setImage:[UIImage imageNamed:kHSBusinessHallImageName] forState:UIControlStateNormal];
        [_nearbyBusinessHallView setImage:[UIImage imageNamed:kHSBusinessHallHighlightedImageName] forState:UIControlStateHighlighted];
        [_nearbyBusinessHallView setTitle:kHSBusinessHallStr forState:UIControlStateNormal];
        [_nearbyBusinessHallView addTarget:self action:@selector(showNearbyBusinessHall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nearbyBusinessHallView;
}

- (HSHomeServiceButton *)AfterSaleServiceView {
    if (!_AfterSaleServiceView) {
        _AfterSaleServiceView = [[HSHomeServiceButton alloc]init];
        [_AfterSaleServiceView setImage:[UIImage imageNamed:kHSAfterSaleServiceImageName] forState:UIControlStateNormal];
        [_AfterSaleServiceView setImage:[UIImage imageNamed:kHSAfterSaleServiceHighlightedImageName] forState:UIControlStateHighlighted];
        [_AfterSaleServiceView setTitle:kHSAfterSaleServiceStr forState:UIControlStateNormal];
        [_AfterSaleServiceView addTarget:self action:@selector(showAfterSaleService) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AfterSaleServiceView;
}

- (void)addTopLine {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = HS_linecor1.CGColor;
    layer.frame = CGRectMake(0, 0, self.width, 0.5);
    [self.layer addSublayer:layer];
}

@end
