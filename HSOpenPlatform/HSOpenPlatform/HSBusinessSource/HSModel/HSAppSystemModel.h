//
//  HSAppSystemModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/24.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
@protocol HSAppSystemModel<NSObject>

@end
@interface HSAppSystemModel : WeAppComponentBaseItem

@property (strong,nonatomic) NSString *adaptationSys;

@property (strong,nonatomic) NSString *appSize;

@property (strong,nonatomic) NSString *appVersion;

@property (strong,nonatomic) NSString *appCompatible;

@property (strong,nonatomic) NSString *language;

@property (strong,nonatomic) NSString *downUrl;

@end
