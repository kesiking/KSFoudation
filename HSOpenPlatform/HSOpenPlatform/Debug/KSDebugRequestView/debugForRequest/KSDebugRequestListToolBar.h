//
//  KSDebugRequestListToolBar.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const KSDebugRequestShowTypeKey = @"KSDebugRequestShowTypeKey";

typedef NS_ENUM(NSInteger, KSDebugRequestListShowType) {
    KSDebugRequestListShowTypeDefault = 0,
    KSDebugRequestListShowTypeSortByVC,
};

typedef void (^ClearBtnClickedBlock)(void);

typedef void (^SortBtnClickedBlock)(KSDebugRequestListShowType showType);


@interface KSDebugRequestListToolBar : UIView

@property (nonatomic, strong) NSString *totalFlowCount;

@property (nonatomic, strong) ClearBtnClickedBlock clearBtnClickedBlock;

@property (nonatomic, strong) SortBtnClickedBlock sortBtnClickedBlock;

- (void)showTotalFlowCount;

@end
