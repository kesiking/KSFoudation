//
//  HSApplicationIntroModel.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSApplicationIntroModel.h"

@implementation HSApplicationIntroModel


+(TBJSONModelKeyMapper*)modelKeyMapper{
    NSDictionary* dict = @{@"id":@"appId",
                           };
    return [[TBJSONModelKeyMapper alloc] initWithDictionary:dict];
}

-(void)setFromDictionary:(NSDictionary *)dict{
    [super setFromDictionary:dict];
}

@end
