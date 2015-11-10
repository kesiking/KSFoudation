//
//  HSActivityInfoCell.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSViewCell.h"

@interface HSActivityInfoCell : KSViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *activityImageView;
@property (weak, nonatomic) IBOutlet UIImageView    *activityBottomLineImageView;
@property (weak, nonatomic) IBOutlet UILabel        *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *activityInfoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel        *activityStartDateLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel        *activityStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel        *activityEndDateLabel;

@end
