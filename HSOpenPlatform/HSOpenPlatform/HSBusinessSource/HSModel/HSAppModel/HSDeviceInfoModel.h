//
//  HSDeviceInfoModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@protocol HSDeviceInfoModel <NSObject>

@end

@interface HSDeviceInfoModel : WeAppComponentBaseItem

@property (strong, nonatomic) NSNumber *deviceId;

@property (strong, nonatomic) NSString *businessId;

@property (strong, nonatomic) NSString *businessName;

@property (strong, nonatomic) NSNumber *productId;

@property (strong, nonatomic) NSString *productName;

@property (strong, nonatomic) NSString *productLogo;

@property (strong, nonatomic) NSString *placeholderImageStr;

//@property (strong, nonatomic) NSString *deviceId; 未区分两个deviceId

@property (strong, nonatomic) NSString *deviceCode;

@property (strong, nonatomic) NSString *totalUser;

@property (strong, nonatomic) NSString *deviceModel;

@property (strong, nonatomic) NSString *deviceFactory;

@property (strong, nonatomic) NSString *saleChannel;

@property (strong, nonatomic) NSString *combo;

@end
