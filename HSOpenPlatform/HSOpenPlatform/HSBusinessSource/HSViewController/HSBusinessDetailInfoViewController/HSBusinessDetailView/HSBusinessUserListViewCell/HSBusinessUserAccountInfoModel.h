//
//  HSBusinessUserAccountInfoModel.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@protocol HSBusinessUserAccountInfoNickNameModel <NSObject>

@end

@interface HSBusinessUserAccountInfoNickNameModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString      *memberPhone;

@property (nonatomic, strong) NSString      *nickname;

@property (nonatomic, strong) NSString      *familiaPhone;

@property (nonatomic, strong) NSString      *productId;

@property (nonatomic, strong) NSString      *deviceId;

@property (nonatomic, assign) BOOL           isUserAccountHousehold;

@end

@interface HSBusinessUserAccountInfoModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString      *familiaPhone;

@property (nonatomic, strong) NSString      *productId;

@property (nonatomic, strong) NSString      *deviceId;

@property (nonatomic, strong) NSArray<HSBusinessUserAccountInfoNickNameModel>       *member;

@end
