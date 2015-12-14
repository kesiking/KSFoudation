//
//  KSDebugRequestListView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugRequestModel.h"
#import "KSDebugRequestListToolBar.h"

typedef void (^SelectedRequestModelBlock)(KSDebugRequestModel *model);

@interface KSDebugRequestListView : UITableView

@property (nonatomic, strong) NSMutableArray *requestArray;

@property (nonatomic, strong) SelectedRequestModelBlock selectedRequestModelBlock;

- (void)reloadData;

- (void)reloadDataWithType:(KSDebugRequestListShowType)showType;

@end
