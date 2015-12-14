//
//  KSDebugRequestListHeaderView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/8.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestListHeaderView.h"

@interface KSDebugRequestListHeaderView ()

@property (nonatomic, strong)UILabel *VCLabel;

@property (nonatomic, strong)UILabel *detailLabel;

@property (nonatomic, strong)CALayer *topLayer;

@property (nonatomic, strong)CALayer *bottomLayer;

@end

@implementation KSDebugRequestListHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.VCLabel];
    [self addSubview:self.detailLabel];
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.bottomLayer];
}

- (void)configWithVCModel:(KSDebugRequestVCModel *)VCMode {
    self.VCLabel.text           = VCMode.requestedVC;
    
    NSString *flowCountStr = [KSDebugRequestModel getDataLengthStrWithLength:VCMode.flowCount];
    self.detailLabel.text = [NSString stringWithFormat:@"流量(%@)  次数(%ld)  时间共(%.2fs)",flowCountStr,VCMode.requestCount,VCMode.totalTime];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.VCLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);
    self.detailLabel.frame = CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height/2.0);
    self.topLayer.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.bottomLayer.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

#pragma mark - Getters
- (UILabel *)VCLabel {
    if (!_VCLabel) {
        _VCLabel = [[UILabel alloc]init];
        _VCLabel.font = [UIFont boldSystemFontOfSize:14];
        _VCLabel.textColor = [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
        _VCLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _VCLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (CALayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [[CALayer alloc]init];
        _topLayer.backgroundColor = [UIColor grayColor].CGColor;
    }
    return _topLayer;
}

- (CALayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc]init];
        _bottomLayer.backgroundColor = [UIColor grayColor].CGColor;
    }
    return _bottomLayer;
}

@end
