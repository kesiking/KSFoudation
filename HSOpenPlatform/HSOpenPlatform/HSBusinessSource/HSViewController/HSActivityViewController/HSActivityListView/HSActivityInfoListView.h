//
//  HSActivityInfoListView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"

@interface HSActivityInfoListView : KSView{
    KSTableViewController*          _tableViewCtl;
}

@property (nonatomic,strong) KSTableViewController* tableViewCtl;

-(void)refreshDataRequestWithUserPhone:(NSString*)userPhone;

@end
