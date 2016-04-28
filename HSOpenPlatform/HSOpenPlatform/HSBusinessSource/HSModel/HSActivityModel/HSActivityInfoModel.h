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
@property (nonatomic,strong) NSString *        activityBanner;          // 活动广告 介绍图片
@property (nonatomic,strong) NSString *        activityPoster;          // 活动详情 介绍大图
/*!
 *  @brief  活动起止时间
 */
@property (nonatomic,strong) NSString *        activityStartTime;       // 活动起始日期
@property (nonatomic,strong) NSString *        activityEndTime;         // 活动截止日期
@property (nonatomic,strong) NSNumber *        activityStatus;          // 活动状态，有效、已过期（无效）
/*!
 *  @brief  活动内容
 */
@property (nonatomic,strong) NSString *        activityContent;         // 活动详情
@property (nonatomic,strong) NSString *        activityTitle;           // 活动标题
@property (nonatomic,strong) NSString *        activityAddress;         // 活动地址
@property (nonatomic,strong) NSString *        activityTargetDesc;      // 活动针对对象
@property (nonatomic,strong) NSString *        activityOwner;           // 活动所属
@property (nonatomic,strong) NSString *        activityRule;            // 活动规则
@property (nonatomic,strong) NSString *        activityReward;          // 活动奖励
@property (nonatomic,strong) NSNumber *        activityCanAttend;       // 活动是否可参加
@property (nonatomic,strong) NSNumber *        isTop;                   // 活动是否置顶
@property (nonatomic,strong) NSNumber *        isIndex;                 // 活动是否首页广告
@property (nonatomic,strong) NSNumber *        needLogin;               // 活动是否需要登录
/*!
 *  @brief  活动链接
 */
@property (nonatomic,strong) NSString *        activityUrl;             // 活动H5链接
/*!
 *  @brief  活动创建或是更新的时间
 */
@property (nonatomic,strong) NSString *        createDate;              // 活动创建日期
@property (nonatomic,strong) NSString *        updateDate;              // 活动更新日期

@end
