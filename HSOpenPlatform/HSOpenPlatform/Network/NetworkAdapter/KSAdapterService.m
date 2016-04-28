//
//  KSAdapterService.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterService.h"
#import "KSAdapterNetWork.h"
#import "KSAdapterCacheService.h"
#import "KSPageList.h"
#import "KSAdapterService+AddSignParam.h"

@implementation KSAdapterService

-(instancetype)init{
    if (self = [super init]) {
        [self setupService];
    }
    return self;
}

-(void)setupService{
    KSAdapterNetWork* network = [[KSAdapterNetWork alloc] init];
    network.addSignParamBlock = [self getAddSignParamBlock];
    network.needAuthenticationChallenge = YES;
    [self setNetwork:network];
    
    [self setPageListClass:[KSPageList class]];
    KSAdapterCacheService* cacheService = [KSAdapterCacheService new];
    cacheService.cacheStrategy.strategyType = KSCacheStrategyTypeRemoteData;
    [self setCacheService:cacheService];
    
    // 默认转成json格式
    [self.serviceContext.serviceContextDict setObject:@YES forKey:@"requestSerializerNeedJson"];
    [self.serviceContext.serviceContextDict setObject:@"application/json" forKey:@"Content-Type"];
    [self.serviceContext.serviceContextDict setObject:@"msg" forKey:@"resultString"];
    [self.serviceContext.serviceContextDict setObject:@"time" forKey:@"resultTime"];
    [self.serviceContext.serviceContextDict setObject:@"code" forKey:@"resultCode"];
    [self.serviceContext.serviceContextDict setObject:@"dataCounts" forKey:@"resultDataCount"];
}


@end
