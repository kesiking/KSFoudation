//
//  ManWuCommodityDeleteBottom.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-7.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"

typedef void(^deleteViewDidClickedBlock) (void);

@interface HSMessageListDeleteBottom : KSView

@property(nonatomic,strong) deleteViewDidClickedBlock             deleteViewDidClickedBlock;

@end
