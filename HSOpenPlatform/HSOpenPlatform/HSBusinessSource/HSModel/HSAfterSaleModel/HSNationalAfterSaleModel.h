//
//  HSNationalAfterSaleModel.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSNationalAfterSaleModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString *uniAfterSaleId;

@property (nonatomic, strong) NSString *uniAfterSaleName;

@property (nonatomic, strong) NSNumber *appId;

@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSString *afterSalePhone;

@property (nonatomic, strong) NSString *afterSaleMail;

@property (nonatomic, strong) NSString *addressDes;

@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *latitude;


@property (nonatomic, strong) NSString *appIconUrl;

@property (nonatomic, strong) NSString *placeholderImageStr;

@end
