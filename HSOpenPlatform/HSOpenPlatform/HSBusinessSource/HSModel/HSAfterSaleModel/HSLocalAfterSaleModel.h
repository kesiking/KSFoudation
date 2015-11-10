//
//  HSLocalAfterSaleModel.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSLocalAfterSaleModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString *localAfterSaleId;

@property (nonatomic, strong) NSString *localAfterSaleName;

@property (nonatomic, strong) NSNumber *appId;

@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSString *afterSalePhone;

@property (nonatomic, strong) NSString *afterSaleMail;

@property (nonatomic, strong) NSString *addressDes;

@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *latitude;

@end
