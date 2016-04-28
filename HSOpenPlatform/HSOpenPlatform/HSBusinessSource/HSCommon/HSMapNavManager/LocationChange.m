//
//  LocationChange.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "LocationChange.h"

@implementation LocationChange

const double hsopen_platform_bd_map_x_pi = 3.14159265358979324 * 3000.0 / 180.0;

//火星转百度坐标
+(void)eh_home_bd_encrypt:(double)gg_lat gg_lon:(double)gg_lon bd_lat:(double*)bd_lat bd_lon:(double*)bd_lon
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * hsopen_platform_bd_map_x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * hsopen_platform_bd_map_x_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}
//百度坐标转火星
+(void)eh_home_bd_decrypt:(double)bd_lat bd_lon:(double)bd_lon gg_lat:(double*)gg_lat gg_lon:(double*)gg_lon
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * hsopen_platform_bd_map_x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * hsopen_platform_bd_map_x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}


@end
