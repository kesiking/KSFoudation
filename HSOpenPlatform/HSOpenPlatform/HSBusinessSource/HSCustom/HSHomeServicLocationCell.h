//
//  HSHomeServicLocationCell.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/6.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMapPoiModel.h"

#define kHSBusinessHallListCellHeight caculateNumber(105)

@interface HSHomeServicLocationCell : UITableViewCell

@property (nonatomic, strong) HSMapPoiModel *model;

@end
