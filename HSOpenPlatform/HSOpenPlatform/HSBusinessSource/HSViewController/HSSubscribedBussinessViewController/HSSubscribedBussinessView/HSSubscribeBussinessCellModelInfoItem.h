//
//  HSSubscribeBussinessCellModelInfoItem.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDataSource.h"

@interface HSSubscribeBussinessCellModelInfoItem : KSCellModelInfoItem

@property (nonatomic, assign) CGSize             subscribedBussinessInfoDescSize;
@property (nonatomic, strong) NSString*          subscribedBussinessStartTime;
@property (nonatomic, strong) NSString*          subscribedBussinessEndTime;

@end
