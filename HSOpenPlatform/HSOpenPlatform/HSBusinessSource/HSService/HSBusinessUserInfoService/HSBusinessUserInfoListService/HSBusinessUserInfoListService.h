//
//  HSBusinessUserInfoListService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSBusinessUserAccountInfoModel.h"

@interface HSBusinessUserInfoNickNameListService : KSAdapterService

-(void)loadBusinessUserInfoNickNameListWithUserPhones:(NSArray*)userPhones appId:(NSString*)appId;

-(void)loadBusinessUserInfoNickNameListWithUserPhoneStr:(NSString*)userPhoneStr appId:(NSString*)appId;

@end

@interface HSBusinessUserInfoListService : KSAdapterService

-(void)loadBusinessUserInfoListWithUserPhone:(NSString*)userPhone appId:(NSString*)appId;

@end
