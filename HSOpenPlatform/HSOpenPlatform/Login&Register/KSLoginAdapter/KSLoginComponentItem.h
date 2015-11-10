//
//  KSLoginComponentItem.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface KSLoginComponentItem : WeAppComponentBaseItem

@property (nonatomic,strong) NSNumber* status;
@property (nonatomic,strong) NSString* msg;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* user_phone;
@property (nonatomic,strong) NSString* pre_user_phone;
@property (nonatomic,strong) NSString* user_trueName;
@property (nonatomic,strong) NSString* nick_name;
@property (nonatomic,strong) NSString* user_reg_time;
@property (nonatomic,strong) NSNumber* user_age;
@property (nonatomic,strong) NSNumber* user_sex;
@property (nonatomic,strong) NSString* user_head_img;
@property (nonatomic,strong) NSNumber* user_type;
@property (nonatomic,strong) NSNumber* user_status;
@property (nonatomic,strong) NSString* user_last_login_time;
// for new service
@property (nonatomic,strong) NSString* userPhone;
@property (nonatomic,strong) NSString* userStarLevel;
@property (nonatomic,strong) NSString* userPackage;

@property (nonatomic,assign) BOOL isLogined;

+(KSLoginComponentItem *)sharedInstance;

-(void)updateUserInfo:(NSDictionary*)userInfo;

-(void)updateUserComponentItem:(KSLoginComponentItem *)userComponentItem;

-(void)updateUserLogin:(BOOL)isLogin;

-(void)setPassword:(NSString *)password;

-(void)setAccountName:(NSString*)accountName;

-(NSString*)getAccountName;

-(NSString*)getPassword;

-(void)clearPassword;

@end
