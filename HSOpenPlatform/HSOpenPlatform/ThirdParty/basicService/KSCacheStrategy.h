//
//  KSCacheStrategy.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/3.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KSCacheStrategyType) {
    KSCacheStrategyTypeRemoteData          =  0, // 下载数据后删除缓存并用网络数据更新缓存
    KSCacheStrategyTypeUpdate              =  1, // 暂时没有实现
    KSCacheStrategyTypeInsert              =  2, // 暂时没有实现
    KSCacheStrategyTypeDelete              =  3, // 暂时没有实现
};

@interface KSCacheStrategy : NSObject

@property (nonatomic, assign) NSUInteger       strategyType;

@property (nonatomic, strong) NSDictionary*    strategyDict;

@property (nonatomic, strong) id               strategyExtObject;

@end
