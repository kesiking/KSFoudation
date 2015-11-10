//
//  KSScrollViewConfigObject.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-25.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
// render type
typedef NS_ENUM(NSInteger, KSScrollViewConfigCacheType) {
    KSScrollViewConfigCacheType_default = 1,        // 默认为请求数据时就刷新缓存
    KSScrollViewConfigCacheType_afterFail,          // 失败后再刷新缓存
};

@interface KSScrollViewConfigObject : NSObject

@property (nonatomic, assign) BOOL                 needNextPage;
@property (nonatomic, assign) BOOL                 needRefreshView;
@property (nonatomic, assign) BOOL                 needFootView;
@property (nonatomic, assign) BOOL                 needErrorView;
@property (nonatomic, assign) BOOL                 needQueueLoadData;
@property (nonatomic, assign) BOOL                 needLoadingView;
@property (nonatomic, assign) BOOL                 serviceCanLoadData;
@property (nonatomic, assign) KSScrollViewConfigCacheType scrollViewCacheType;

-(void)setupStandConfig;

@end
