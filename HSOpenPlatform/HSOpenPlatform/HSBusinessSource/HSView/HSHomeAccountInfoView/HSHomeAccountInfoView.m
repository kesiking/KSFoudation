//
//  HSHomeAccountInfoView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHomeAccountInfoView.h"
#import "HSHomeAccountInfoButton.h"

static NSString *const kHSBalanceStr              = @"账户余额";
static NSString *const kHSBalanceImageName        = @"icon_Balance";

static NSString *const kHSPhoneChargeStr          = @"实时话费";
static NSString *const kHSPhoneChargeImageName    = @"icon_Sim";

static NSString *const kHSRestFlowStr             = @"剩余流量";
static NSString *const kHSRestFlowImageName       = @"icon_Flow";


@interface HSHomeAccountInfoView ()

@property (nonatomic, strong) HSHomeAccountInfoButton *balanceBtn;

@property (nonatomic, strong) HSHomeAccountInfoButton *phoneChargeBtn;

@property (nonatomic, strong) HSHomeAccountInfoButton *restFlowBtn;

@end

@implementation HSHomeAccountInfoView

- (void)setupView {
    [self addSubview:self.balanceBtn];
    [self addSubview:self.phoneChargeBtn];
    [self addSubview:self.restFlowBtn];
    [self addSeparatorLines];
    
    [self showNoInfo];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.balanceBtn.frame = CGRectMake(0, 0, self.width/3.0, self.height);
    self.phoneChargeBtn.frame = CGRectMake(self.width/3.0, 0, self.width/3.0, self.height);
    self.restFlowBtn.frame = CGRectMake(self.width/3.0*2, 0, self.width/3.0, self.height);
}

- (void)showNoInfo {
    self.balanceBtn.infoLabel.text     = @"      --";
    self.phoneChargeBtn.infoLabel.text = @"      --";
    self.restFlowBtn.infoLabel.text    = @"      --";
}

#pragma mark - Getters And Setters
- (void)setBalance:(NSString *)balance {
    _balance = balance;
    self.balanceBtn.infoLabel.text = [NSString stringWithFormat:@"%@ 元",balance];
}

- (void)setPhoneCharge:(NSString *)phoneCharge {
    _phoneCharge = phoneCharge;
    self.phoneChargeBtn.infoLabel.text = [NSString stringWithFormat:@"%@ 元",phoneCharge];
}

- (void)setRestFlow:(NSString *)restFlow {
    _restFlow = restFlow;
    self.restFlowBtn.infoLabel.text = [NSString stringWithFormat:@"%@ GB",restFlow];
}

#pragma mark - Subviews
- (HSHomeAccountInfoButton *)balanceBtn {
    if (!_balanceBtn) {
        _balanceBtn = [[HSHomeAccountInfoButton alloc]init];
        _balanceBtn.imv.image = [UIImage imageNamed:kHSBalanceImageName];
        _balanceBtn.nameLabel.text = kHSBalanceStr;
    }
    return _balanceBtn;
}

- (HSHomeAccountInfoButton *)phoneChargeBtn {
    if (!_phoneChargeBtn) {
        _phoneChargeBtn = [[HSHomeAccountInfoButton alloc]init];
        _phoneChargeBtn.imv.image = [UIImage imageNamed:kHSPhoneChargeImageName];
        _phoneChargeBtn.nameLabel.text = kHSPhoneChargeStr;
    }
    return _phoneChargeBtn;
}

- (HSHomeAccountInfoButton *)restFlowBtn {
    if (!_restFlowBtn) {
        _restFlowBtn = [[HSHomeAccountInfoButton alloc]init];
        _restFlowBtn.imv.image = [UIImage imageNamed:kHSRestFlowImageName];
        _restFlowBtn.nameLabel.text = kHSRestFlowStr;
    }
    return _restFlowBtn;
}

- (void)addSeparatorLines {
    CGRect frame1 = CGRectMake(0, 0, self.width, 0.5);
    CGRect frame2 = CGRectMake(self.width/3.0, caculateNumber(16), 0.5, self.height - caculateNumber(16) * 2);
    CGRect frame3 = CGRectMake(self.width/3.0*2, caculateNumber(16), 0.5, self.height - caculateNumber(16) * 2);
    
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    [muArr addObject:[NSValue valueWithCGRect:frame1]];
    [muArr addObject:[NSValue valueWithCGRect:frame2]];
    [muArr addObject:[NSValue valueWithCGRect:frame3]];
    
    for (NSInteger i = 0; i<3; i++) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = EHLinecor1.CGColor;
        layer.frame = [muArr[i] CGRectValue];
        [self.layer addSublayer:layer];
    }
}

@end
