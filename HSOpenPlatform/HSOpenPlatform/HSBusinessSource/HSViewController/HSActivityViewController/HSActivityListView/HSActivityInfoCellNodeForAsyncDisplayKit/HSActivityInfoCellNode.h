//
//  HSActivityInfoCellNode.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#ifdef USE_AsyncDisplayKit

#import "KSViewCellNode.h"

@interface HSActivityInfoCellNode : KSViewCellNode

@property (strong, nonatomic) ASNetworkImageNode    *activityImageView;
@property (strong, nonatomic) ASTextNode            *activityTitleLabel;
@property (strong, nonatomic) ASTextNode            *activityInfoDescLabel;

@end

#endif
