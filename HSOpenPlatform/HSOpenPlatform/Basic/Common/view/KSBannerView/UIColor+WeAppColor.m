//
//  UIColor+WeAppColor.m
//  Taobao2013
//
//  Created by 香象 on 12-12-19.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "UIColor+WeAppColor.h"

@implementation UIColor (WeAppColor)
+ (UIColor *)weappLineColor{
    return  [UIColor colorWithRed:208 green:208 blue:208 alpha:1];
    
}
+ (UIColor *)weappBackgroundColor{
    return  [UIColor colorWithRed:232 green:232 blue:232 alpha:1];
}

+(UIColor *)weappColor153{
       return [UIColor weappColorWithRed:153 green:153 blue:153 alpha:1];
    
}

+(UIColor *)weappColor61{
    return [UIColor weappColorWithRed:61 green:66 blue:69 alpha:1];
    
}

+(UIColor *)weappColor102{
    return [UIColor weappColorWithRed:102 green:102 blue:102 alpha:1];
    
}
+(UIColor *)weappColor249{
    return [UIColor weappColorWithRed:249 green:249 blue:249 alpha:1];
    
}

+(UIColor *)weappColor238{
    return [UIColor weappColorWithRed:238 green:238 blue:238 alpha:1];
}

+ (UIColor *)weappColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return  [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}
@end
