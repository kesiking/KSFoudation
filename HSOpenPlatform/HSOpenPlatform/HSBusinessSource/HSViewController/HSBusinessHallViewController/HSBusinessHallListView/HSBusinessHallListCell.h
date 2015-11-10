//
//  HSBusinessHallListCell.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/16.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHSBusinessHallListCellHeight caculateNumber(105)

@interface HSBusinessHallListCell : UITableViewCell

- (void)configWithModel:(AMapPOI *)poi;

@end
