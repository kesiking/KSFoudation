//
//  KSDebugButtonWidthAlgorithm.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugButtonWidthAlgorithm.h"

@implementation KSDebugButtonWidthAlgorithm

+(CGFloat)viewDynamicWidthWithNum:(NSUInteger)number{
    if (number == 1) {
        return ([[UIScreen mainScreen]bounds].size.width - (2 + number - 1) * borderWidth) / 2;
    }else if (number == 2 || number == 3 || number == 4) {
        return ([[UIScreen mainScreen]bounds].size.width - (2 + number - 1) * borderWidth) / number;
    }else if(number >= 5){
        return BUTTON_AVERAGE_WIDTH;
    }else{
        return [[UIScreen mainScreen]bounds].size.width;
    }
}

+(CGFloat)viewDynamicWidthWithNum:(NSUInteger)number andParentWidth:(CGFloat)width{
    if (number == 1) {
        return (width - (2 + number - 1) * borderWidth) / 2;
    }else if (number == 2 || number == 3 || number == 4) {
        return (width - (2 + number - 1) * borderWidth) / number;
    }else if(number >= 5){
        return BUTTON_AVERAGE_WIDTH;
    }else{
        return [[UIScreen mainScreen]bounds].size.width;
    }
}

+(CGFloat)viewDynamicHeightWithNum:(NSUInteger)number{
    return defaultHeight;
}

+(NSString*)imageSelectNameWithNum:(NSUInteger)number{
    return @"";
}

+(NSString*)imageNormalNameWithNum:(NSUInteger)number{
    return nil;
}

@end
