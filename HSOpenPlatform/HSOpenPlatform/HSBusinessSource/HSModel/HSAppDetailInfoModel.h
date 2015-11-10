//
//  HSAppDetailInfoModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/22.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSAppDetailInfoModel : WeAppComponentBaseItem

@property (strong, nonatomic) NSString *appId;

@property (strong, nonatomic) NSString *appName;

@property (strong, nonatomic) NSString *appIconUrl;

@property (strong, nonatomic) NSString *appIOSURLScheme;

@property (strong, nonatomic) NSString *appIOSTpye;

@property (strong, nonatomic) NSString *appIOSVersion;

@property (strong, nonatomic) NSString *appIOSSize;

@property (strong, nonatomic) NSString *appIOSCompatible;

@property (strong, nonatomic) NSString *appIOSUpdateDate;


@end
