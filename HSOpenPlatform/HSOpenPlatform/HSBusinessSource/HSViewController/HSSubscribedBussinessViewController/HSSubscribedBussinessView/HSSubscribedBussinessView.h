//
//  HSSubscribedBussinessView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSControl.h"
#import "KSTableViewController.h"
#import "HSSubscribedBussinessBasicService.h"

@interface HSSubscribedBussinessView : KSControl{
    KSTableViewController*        _tableViewCtl;
}

@property (nonatomic,strong) KSTableViewController* tableViewCtl;
@property (nonatomic,strong) HSSubscribedBussinessBasicService* subscribedBussinessListService;

@end
