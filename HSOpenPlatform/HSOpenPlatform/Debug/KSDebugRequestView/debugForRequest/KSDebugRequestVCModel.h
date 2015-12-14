//
//  KSDebugRequestVCModel.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/7.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSDebugRequestModel.h"

@interface KSDebugRequestVCModel : NSObject

@property (nonatomic, strong) NSString         *requestedVC;        //!< 发起请求的VC（名称：地址）

@property (nonatomic, assign) NSInteger         requestCount;       //!< 请求数量

@property (nonatomic, strong) NSDate           *latestTime;         //!< 最新一次请求的时间

@property (nonatomic, assign) NSTimeInterval    totalTime;          //!< 所有请求总时间

@property (nonatomic, assign) long long         flowCount;    //!< 所有请求数据大小

@property (nonatomic, strong) NSMutableArray   *requestArray;       //!< 当前页面所有的请求

@end
