//
//  HSDeviceModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "HSDeviceInfoModel.h"

@interface HSDeviceModel : WeAppComponentBaseItem

@property (strong, nonatomic) NSString *userPhone;

@property (strong, nonatomic) NSString *businessId;

@property (strong, nonatomic) NSString *businessName;

@property (strong, nonatomic) NSNumber *productId;

@property (strong, nonatomic) NSString *productName;

@property (strong, nonatomic) NSString *productLogo;

@property (strong, nonatomic) NSString *platUrl;

@property (strong, nonatomic) NSArray<HSDeviceInfoModel> *deviceData;

@property (strong, nonatomic) NSString *placeholderImageStr;

@end
