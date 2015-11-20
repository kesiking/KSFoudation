//
//  HSBusinessUserInfoListService.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBusinessUserInfoListService.h"

@implementation HSBusinessUserInfoNickNameListService

-(void)loadBusinessUserInfoNickNameListWithUserPhones:(NSArray*)userPhones appId:(NSString*)appId{
    if ([WeAppUtils isEmpty:userPhones]) {
        EHLogError(@"userPhones is empty!");
        return;
    }
    
    NSString* userPhoneStr = [WeAppUtils getCollectionStringWithKeys:userPhones withSeparatedByString:@","];

    [self loadBusinessUserInfoNickNameListWithUserPhoneStr:userPhoneStr appId:appId];
}

-(void)loadBusinessUserInfoNickNameListWithUserPhoneStr:(NSString*)userPhoneStr appId:(NSString*)appId{
    if ([EHUtils isEmptyString:userPhoneStr]) {
        EHLogError(@"userPhones is empty!");
        return;
    }
    if ([EHUtils isEmptyString:appId]) {
        EHLogError(@"appId is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhoneStr) {
        [params setObject:userPhoneStr forKey:@"userPhones"];
    }
    if (appId) {
        [params setObject:appId forKey:@"appId"];
    }
    
    self.itemClass = [HSBusinessUserAccountInfoNickNameModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;

    [self loadDataListWithAPIName:kHSGetBusinessUserInfoNickNameApiName params:params version:nil];
}

@end

@interface HSBusinessUserInfoListService()

@property(nonatomic, strong) HSBusinessUserInfoNickNameListService*  userInfoNickNameListService;

@end

@implementation HSBusinessUserInfoListService

-(void)loadBusinessUserInfoListWithUserPhone:(NSString*)userPhone appId:(NSString*)appId{
    if ([EHUtils isEmptyString:userPhone]) {
        EHLogError(@"userPhone is nil!");
        return;
    }
    if ([EHUtils isEmptyString:appId]) {
        EHLogError(@"appId is nil!");
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (userPhone) {
        [params setObject:userPhone forKey:@"phone"];
    }
    if (appId) {
        [params setObject:appId forKey:@"appId"];
    }
    
    self.itemClass = [HSBusinessUserAccountInfoModel class];
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    [self loadDataListWithAPIName:kHSGetBusinessUserInfoListApiName params:params version:nil];
}

-(HSBusinessUserInfoNickNameListService *)userInfoNickNameListService{
    if (_userInfoNickNameListService == nil) {
        _userInfoNickNameListService = [HSBusinessUserInfoNickNameListService new];
    }
    return _userInfoNickNameListService;
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model{
    if (![WeAppUtils isEmpty:model.dataList]) {
        NSMutableArray* userPhones = [NSMutableArray array];
        for (HSBusinessUserAccountInfoModel* userInfoModel in model.dataList) {
            if (![userInfoModel isKindOfClass:[HSBusinessUserAccountInfoModel class]]) {
                continue;
            }
            if (userInfoModel.userAccountPhone) {
                [userPhones addObject:userInfoModel.userAccountPhone];
            }
        }
        [self.userInfoNickNameListService loadBusinessUserInfoNickNameListWithUserPhones:userPhones appId:[model.params objectForKey:@"appId"]];
        WEAKSELF
        self.userInfoNickNameListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            // to do update model 拿到昵称则做一次更新操作 而后返回userList数据
            if (service.dataList && [service.dataList count] > 0) {
                [strongSelf mergeUserInfoModels:model.dataList withUserInfoNickNamModels:service.dataList];
            }
            [strongSelf swizzledModelDidFinishLoad:model];
        };
        self.userInfoNickNameListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            // 拿不到 昵称就正常返回userList数据
            [strongSelf swizzledModelDidFinishLoad:model];
        };
    }
}

-(void)mergeUserInfoModels:(NSArray*)userInfoModels withUserInfoNickNamModels:(NSArray*)userInfoNickNameModels{
    for (HSBusinessUserAccountInfoModel* userInfoModel in userInfoModels) {
        if (![userInfoModel isKindOfClass:[HSBusinessUserAccountInfoModel class]]) {
            continue;
        }
        for (HSBusinessUserAccountInfoNickNameModel* userInfoNickNameModel in userInfoNickNameModels) {
            if (![userInfoNickNameModel isKindOfClass:[HSBusinessUserAccountInfoNickNameModel class]]) {
                continue;
            }
            if ([userInfoModel.userAccountPhone isEqualToString:userInfoNickNameModel.userPhone]) {
                userInfoModel.userAccountNickName = userInfoNickNameModel.nickname;
            }
        }
    }
}

-(void)swizzledModelDidFinishLoad:(WeAppBasicRequestModel *)model{
    [super modelDidFinishLoad:model];
}

@end
