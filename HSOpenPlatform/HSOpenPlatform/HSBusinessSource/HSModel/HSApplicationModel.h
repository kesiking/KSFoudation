//
//  HSApplicationModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface HSApplicationModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) NSString *appName;

@property (nonatomic, strong) NSString *appIconUrl;

@property (nonatomic, strong) NSString *placeholderImageStr;

@end
