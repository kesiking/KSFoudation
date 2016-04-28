//
//  LocationChange.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationChange : NSObject

//火星转百度坐标
+(void)eh_home_bd_encrypt:(double)gg_lat gg_lon:(double)gg_lon bd_lat:(double*)bd_lat bd_lon:(double*)bd_lon;
//百度坐标转火星
+(void)eh_home_bd_decrypt:(double)bd_lat bd_lon:(double)bd_lon gg_lat:(double*)gg_lat gg_lon:(double*)gg_lon;

@end
