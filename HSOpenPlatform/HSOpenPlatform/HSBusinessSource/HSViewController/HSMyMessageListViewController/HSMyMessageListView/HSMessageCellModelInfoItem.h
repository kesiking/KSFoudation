//
//  HSMessageCellModelInfoItem.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDataSource.h"
#import "HSMessageExtModel.h"

@interface HSMessageCellModelInfoItem : KSCellModelInfoItem

@property (nonatomic, strong) NSString*          messageTime;
@property (nonatomic, strong) NSString*          messageDate;
@property (nonatomic, strong) NSString*          timeStamp;
@property (nonatomic, assign) CGSize             messageInfoSize;

@property (nonatomic, strong) HSMessageExtModel* messageLinkModel;

@end
