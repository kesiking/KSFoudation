//
//  HSApplicationModel.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSApplicationModel.h"

@implementation HSApplicationModel

+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"id":@"appId",
                           };
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}


@end
