//
//  HSSubscribedBussinessBasicModel.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSSubscribedBussinessBasicModel : WeAppComponentBaseItem

/*!
 *  @brief  活动起止时间
 */
@property (nonatomic,strong) NSString *        subscribedBussinessStartTime;       // 订阅业务起始日期
@property (nonatomic,strong) NSString *        subscribedBussinessEndTime;         // 订阅业务截止日期
/*!
 *  @brief  活动内容
 */
@property (nonatomic,strong) NSString *        subscribedBussinessDetailText;      // 订阅业务详情

@end
