//
//  HSMyMessageModel.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSMyMessageModel : WeAppComponentBaseItem

@property (nonatomic,strong) NSString *        msgId;
@property (nonatomic,strong) NSString *        userPhone;
@property (nonatomic,strong) NSString *        msgDate;
@property (nonatomic,strong) NSNumber *        msgCategory;
@property (nonatomic,strong) NSString *        msgContent;
@property (nonatomic,strong) NSString *        rechargeUrl;
@property (nonatomic,strong) NSString *        detailUrl;

@property (nonatomic,strong) NSString *        userId;
@property (nonatomic,strong) NSNumber *        dataCounts;
@property (nonatomic,strong) NSDictionary *    msgParams;
// for remote message

@end
