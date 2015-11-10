//
//  HSApplicationIntroModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "HSAppDetailInfoModel.h"

@interface HSApplicationIntroModel : WeAppComponentBaseItem

@property (strong,nonatomic) NSString *appId;

@property (strong,nonatomic) NSString *appName;

@property (strong,nonatomic) NSString *appIconUrl;

@property (strong,nonatomic) NSString *appInfo;

@property (strong,nonatomic) NSString *appImageUrl;

@property (strong,nonatomic) NSString *appDownLoadUrl;

@property (strong,nonatomic) NSString *appExtUrl;

@property (strong,nonatomic) NSString *appService;

@property (strong,nonatomic) HSAppDetailInfoModel *appDetailIos;




@end
