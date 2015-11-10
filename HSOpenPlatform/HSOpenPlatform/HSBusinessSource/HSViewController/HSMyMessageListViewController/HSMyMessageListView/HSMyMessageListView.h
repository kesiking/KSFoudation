//
//  HSMyMessageListView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"

@interface HSMyMessageListView : KSView{
    KSTableViewController*          _tableViewCtl;
}

@property (nonatomic,strong) KSTableViewController* tableViewCtl;

@property (nonatomic,assign) BOOL                   isTableViewEdit;


-(void)refreshDataRequestWithUserPhone:(NSString*)userPhone;

@end
