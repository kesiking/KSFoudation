//
//  KSLoginComponentItem.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSLoginComponentItem.h"
#import "KSLoginKeyChain.h"

@implementation KSLoginComponentItem

static KSLoginComponentItem *userInfoModel=nil;

+(KSLoginComponentItem *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoModel = [[KSLoginComponentItem alloc] init];
        [userInfoModel initUserInfo];
    });
    
    return userInfoModel;
}

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"user_id":@"userId"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

- (void)initUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary   *dict         = [userDefaults objectForKey:@"userInfo"];
    
    [userInfoModel setFromDictionary:dict];
    
    userInfoModel.isLogined  = [userDefaults boolForKey:@"userLogined"];
}

- (void)updateUserInfo:(NSDictionary *)userInfo
{
    [self setFromDictionary:userInfo];
        
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateUserComponentItem:(KSLoginComponentItem *)userComponentItem{
    if (userComponentItem == nil || ![userComponentItem isKindOfClass:[KSLoginComponentItem class]]) {
        return;
    }
    self.user_phone = userComponentItem.userPhone?:self.user_phone;
    self.userPhone = userComponentItem.userPhone?:self.userPhone;
    self.userStarLevel = userComponentItem.userStarLevel?:self.userStarLevel;
    self.userPackage = userComponentItem.userPackage?:self.userPackage;
}

-(void)updateUserLogin:(BOOL)isLogin{
    userInfoModel.isLogined  = isLogin;
    // 退出登录时更新之前登录的用户
    if (!isLogin) {
        self.pre_user_phone = self.user_phone;
    }
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"userLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setPassword:(NSString *)password{
    [[KSLoginKeyChain sharedInstance] setPassword:password];
}

-(void)setAccountName:(NSString*)accountName{
    [[KSLoginKeyChain sharedInstance] setAccountName:accountName];
}

-(NSString*)getAccountName{
    return [[KSLoginKeyChain sharedInstance] getAccountName];
}

-(NSString*)getPassword{
    return [[KSLoginKeyChain sharedInstance] getPassword];
}

-(void)clearPassword{
    [[KSLoginKeyChain sharedInstance] clear];
}

@end
