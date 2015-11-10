//
//  WeAppButtonWidthAlgorithm.m
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppButtonWidthAlgorithm.h"

@implementation WeAppButtonWidthAlgorithm

+(CGFloat)viewDynamicWidthWithNum:(NSUInteger)number{
    if (number == 1) {
        return (SCREEN_WIDTH - (2 + number - 1) * borderWidth) / 2;
    }else if (number == 2 || number == 3 || number == 4) {
        return (SCREEN_WIDTH - (2 + number - 1) * borderWidth) / number;
    }else if(number >= 5){
        return BUTTON_AVERAGE_WIDTH;
    }else{
        return SCREEN_WIDTH;
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
        return SCREEN_WIDTH;
    }
}

+(CGFloat)viewDynamicHeightWithNum:(NSUInteger)number{
    return defaultHeight;
}

+(NSString*)imageSelectNameWithNum:(NSUInteger)number{
    if (number == 2) {
        return @"tab3.png";
    }else if(number == 3){
        return @"tab2.png";
    }else if(number >= 4){
        return @"tab1.png";
    }else{
        return @"";
    }
}

+(NSString*)imageNormalNameWithNum:(NSUInteger)number{
    return @"tabbutton.png";
}


@end
