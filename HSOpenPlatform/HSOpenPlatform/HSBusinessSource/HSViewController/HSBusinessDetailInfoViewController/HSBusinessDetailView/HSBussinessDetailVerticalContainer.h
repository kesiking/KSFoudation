//
//  HSBussinessDetailVerticalContainer.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "HSDeviceModel.h"
#import "HSDeviceInfoModel.h"

@interface HSBussinessDetailVerticalContainer : KSView

@property (nonatomic, strong) HSDeviceInfoModel              *bussinessDetailModel;

@property (nonatomic, strong) HSDeviceModel                  *deviceModel;

@property (nonatomic, strong) NSNumber                       *productId;

@property (nonatomic, strong) NSNumber                       *deviceId;

- (void)reloadDataAndContaier;

@end
