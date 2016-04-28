//
//  HSApplicationIntroModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
//#import "HSAppDetailInfoModel.h"
#import "HSAppSystemModel.h"
#import "HSAppDetailPicModel.h"

@interface HSApplicationIntroModel : WeAppComponentBaseItem

@property (strong,nonatomic) NSString *appId;

@property (strong,nonatomic) NSString *businessId;

@property (strong,nonatomic) NSString *partnerId;

@property (strong,nonatomic) NSString *productId;

@property (strong,nonatomic) NSString *productName;

@property (strong,nonatomic) NSString *productInfo;

@property (strong,nonatomic) NSString *appName;

@property (strong,nonatomic) NSString *appInfo;

@property (strong,nonatomic) NSString *appLogo;

@property (strong,nonatomic) NSArray<HSAppDetailPicModel> *appImages;

@property (strong,nonatomic) NSString *platUrl;

@property (strong,nonatomic) NSArray<HSAppSystemModel> *appSys;

@property (strong,nonatomic) NSString *appURLScheme;

@property (assign,nonatomic) NSInteger status;

@property (strong,nonatomic) NSString *createDate;

@property (strong,nonatomic) NSString *updateDate;

//@property (strong,nonatomic) NSString *appService;
//
//@property (strong,nonatomic) HSAppDetailInfoModel *appDetailIos;

@end
