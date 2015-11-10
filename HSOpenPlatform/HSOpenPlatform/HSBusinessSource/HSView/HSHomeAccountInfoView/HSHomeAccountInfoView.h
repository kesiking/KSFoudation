//
//  HSHomeAccountInfoView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"

#define home_accountInfoView_height               (caculateNumber(61.0))

@interface HSHomeAccountInfoView : KSView

@property (nonatomic, strong) NSString *balance;        //话费余额

@property (nonatomic, strong) NSString *phoneCharge;    //实时话费

@property (nonatomic, strong) NSString *restFlow;       //剩余流量

- (void)showNoInfo;                                     //无数据显示

@end
