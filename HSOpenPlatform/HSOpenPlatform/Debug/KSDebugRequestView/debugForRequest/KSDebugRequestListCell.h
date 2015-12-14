//
//  KSDebugRequestListCell.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugRequestModel.h"

#define ks_debug_requestListCell_height 44

@interface KSDebugRequestListCell : UITableViewCell

@property (nonatomic, strong)KSDebugRequestModel *requestModel;

@end
