//
//  HSApplicationModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSApplicationModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSNumber *appId;//待更新

@property (nonatomic, strong) NSNumber *businessId;

@property (nonatomic, strong) NSNumber *partnerId;

@property (nonatomic, strong) NSNumber *productId;

@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSString *appInfo;

@property (nonatomic, strong) NSString *appLogo;

@property (nonatomic, strong) NSString *platUrl;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *updateDate;

@property (nonatomic, strong) NSString *placeholderImageStr;

@end
