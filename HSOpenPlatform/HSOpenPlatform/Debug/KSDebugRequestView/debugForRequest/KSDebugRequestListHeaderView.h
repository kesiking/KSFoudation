//
//  KSDebugRequestListHeaderView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/8.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugRequestVCModel.h"

#define ks_debug_requestListHeaderView_height 40

@interface KSDebugRequestListHeaderView : UIView

- (void)configWithVCModel:(KSDebugRequestVCModel *)VCModel;

@end
