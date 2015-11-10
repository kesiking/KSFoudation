//
//  HSSubscribedBussinessViewCell.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSViewCell.h"

@interface HSSubscribedBussinessViewCell : KSViewCell

@property (weak, nonatomic) IBOutlet UILabel    *subscribedBussinessInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel    *subscribedBussinessStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel    *subscribedBussinessEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel    *subscribedBussinessStartTimeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel    *subscribedBussinessEndTimeLeftLabel;

@end
