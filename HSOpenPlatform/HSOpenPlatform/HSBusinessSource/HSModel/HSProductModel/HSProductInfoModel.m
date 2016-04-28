//
//  HSProductInfoModel.m
//  HSOpenPlatform
//
//  Created by xtq on 16/2/22.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSProductInfoModel.h"

@implementation HSProductComboModel


@end

@implementation HSProductInfoModel

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"id":@"productId"};
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

@end
