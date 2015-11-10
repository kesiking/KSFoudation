//
//  HSActivityInfoCellModelInfoItem.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDataSource.h"

@interface HSActivityInfoCellModelInfoItem : KSCellModelInfoItem

@property (nonatomic, strong) NSDate*               activityStartDate;
@property (nonatomic, strong) NSDate*               activityEndDate;
@property (nonatomic, strong) NSString*             activityStartTimeStr;
@property (nonatomic, strong) NSString*             activityEndTimeStr;
@property (nonatomic, assign) CGSize                activityInfoDescSize;

@end
