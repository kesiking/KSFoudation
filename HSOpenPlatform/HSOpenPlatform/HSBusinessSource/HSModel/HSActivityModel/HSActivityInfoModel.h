//
//  HSActivityInfoModel.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

typedef NS_ENUM(NSInteger, HSActivityInfoStatus) {
    HSActivityInfoStatus_Valid = 1,       // 有效
    HSActivityInfoStatus_Invalid,         // 过期
};

@interface HSActivityInfoModel : WeAppComponentBaseItem

@property (nonatomic,strong) NSString *        activityId;
/*!
 *  @brief  活动图片Url
 */
@property (nonatomic,strong) NSString *        activityImageUrlForList; // 活动列表 缩略图图片
@property (nonatomic,strong) NSString *        activityImageUrlForAdv;  // 活动广告 介绍图片
@property (nonatomic,strong) NSString *        activityImageUrl;        // 活动详情 介绍大图
/*!
 *  @brief  活动起止时间
 */
@property (nonatomic,strong) NSString *        activityStartTime;       // 活动起始日期
@property (nonatomic,strong) NSString *        activityEndTime;         // 活动截止日期
@property (nonatomic,strong) NSNumber *        activityStatus;          // 活动状态，有效、已过期（无效）
/*!
 *  @brief  活动内容
 */
@property (nonatomic,strong) NSString *        activityDetailText;      // 活动详情
@property (nonatomic,strong) NSString *        activityTitle;           // 活动标题
@property (nonatomic,strong) NSString *        activityAddress;         // 活动地址
@property (nonatomic,strong) NSString *        activityTargetDesc;      // 活动针对对象
@property (nonatomic,strong) NSString *        activityOwner;           // 活动所属
@property (nonatomic,strong) NSNumber *        activityCanAttend;       // 活动是否可参加
/*!
 *  @brief  活动链接
 */
@property (nonatomic,strong) NSString *        activityIntroduceUrl;    // 活动H5链接

@end
