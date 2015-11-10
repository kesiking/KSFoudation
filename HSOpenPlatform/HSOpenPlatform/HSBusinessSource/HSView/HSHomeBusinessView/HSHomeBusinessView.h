//
//  HSHomeBusinessView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/14.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "HSHomeBusinessListView.h"

#define home_businessView_height               (caculateNumber(124.0) * 3)

typedef void(^ResetFrameBlock)(void);

@interface HSHomeBusinessView : KSView

@property (nonatomic, copy)ResetFrameBlock resetFrameBlock;

-(void)refreshDataRequest;

@end
