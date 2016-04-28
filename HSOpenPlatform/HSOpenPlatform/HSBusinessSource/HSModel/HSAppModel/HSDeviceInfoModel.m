//
//  HSDeviceInfoModel.m
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSDeviceInfoModel.h"

@implementation HSDeviceInfoModel

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}


@end
