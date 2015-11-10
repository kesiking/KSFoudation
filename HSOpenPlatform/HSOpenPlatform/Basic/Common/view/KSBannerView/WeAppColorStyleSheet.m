//
//  WeAppColorStyleSheet.m
//  taobao4iphone
//
//  Created by 燕 晨 on 12-9-20.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "WeAppColorStyleSheet.h"
#import "UIColor+WeAppColor.h"

@implementation WeAppColorStyleSheet

+ (UIColor *)colorWithColorType:(TBColors)colorType{
    switch (colorType) {
        case TBColorAa:
        {
        return [UIColor colorWithWhite:1.0 alpha:1.0f];
        } break;
        case TBColorAb:
        {
        return [UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1.0f];
        } break;
        case TBColorB:
        {
            return [UIColor colorWithWhite:170 /255.0f alpha:1.0f];
        } break;

        case TBColorC:
        {
            return [UIColor colorWithWhite:119 /255.0f alpha:1.0f];
        } break;
        case TBColorD:
        {
            return [UIColor colorWithWhite:188 /255.0f alpha:1.0f];
        } break;
        case TBColorE:
        {
            return [UIColor colorWithRed:61/255.0f green:66/255.0f blue:69/255.0f alpha:1.0f];
        } break;
        case TBColorF:
        {
            return [UIColor colorWithRed:120/255.0f green:128/255.0f blue:135/255.0f alpha:1.0f];
        } break;
        case TBColorJ:
        {
            return [UIColor colorWithWhite:102 /255.0f alpha:1.0f];
        } break;
        case TBColorH:
        {
            return [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0/255.0f alpha:1.0f];
        } break;
        case TBColorG:
        {
            return [UIColor colorWithRed:69/255.0f green:112/255.0f blue:170/255.0f alpha:1.0f];
        } break;
        case TBColorI:
        {
            return [UIColor colorWithWhite:153 /255.0f alpha:1.0f];
        } break;
        case TBColorL:
        {
            return [UIColor colorWithRed:0x3d/255.0f green:0x42/255.0f blue:0x45/255.0f alpha:1.0f];
        } break;
        case TBColorK:
        {
            return [UIColor colorWithRed:0x5f/255.0f green:0x64/255.0f blue:0x6e/255.0f alpha:1.0f];
        } break;
            
        case TBColorBG_A:
        {
            return [UIColor colorWithWhite:232/255.0f alpha:1.0f];
        } break;
        case TBColorBG_B:
        {
            return [UIColor colorWithWhite:223/255.0f alpha:1.0f];
        } break;

        case TBColorBG_C:
        {
            return [UIColor colorWithWhite:249/255.0f alpha:1.0f];
        } break;
        case TBColorBG_D:
        {
            return [UIColor colorWithRed:61/255.0f green:66/255.0f blue:69/255.0f alpha:1.0f];
        } break;
        case TBColorBG_E:
        {
            return [UIColor colorWithWhite:238 /255.0f alpha:1.0f];
        } break;

        case TBColorBG_F:
        {
            return [UIColor weappColorWithRed:61 green:66 blue:69 alpha:0.9];
        } break;
        
        case TBColorBG_G:
        {
            return [UIColor colorWithWhite:218/255.0f alpha:1.0f];
        }break;

        default:
            break;
    }

}

+ (UIColor *)colorDb {
    return [UIColor weappColorWithRed:85 green:85 blue:85 alpha:1];
}


+ (UIColor *)separatorColor {
    return [UIColor weappColorWithRed:208 green:208 blue:208 alpha:1];
}


+ (UIColor *)cellSeparatorColor {
    return [UIColor weappColorWithRed:224 green:225 blue:225 alpha:1];
}

+ (UIColor *)tableSeparatorColor {
    return  [UIColor colorWithPatternImage: [UIImage imageNamed: @"listline"]];
}

+ (UIColor *)categoryTableSeparatorColor {
    return  [UIColor colorWithPatternImage: [UIImage imageNamed: @"shaixuanline2"]];
}

+ (UIColor *)tableviewCellSelectionBackground {
    return  [UIColor weappColorWithRed:238 green:238 blue:238 alpha:1];
}

+ (UIColor *)colorOfWhite204 {
    return [UIColor colorWithWhite:204/255.0f alpha:1.0f];
}


+ (UIColor *)colorOfWhite221 {
    return [UIColor colorWithWhite:221/255.0f alpha:1.0f];
}


+ (UIColor *)colorOfWhite238 {
    return [UIColor colorWithWhite:238/255.0f alpha:1.0f];
}


+ (UIColor *)colorOfWhite249 {
    return [UIColor colorWithWhite:249/255.0f alpha:1.0f];
}

+ (UIColor *)orangeColor {
    return [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0f];
}

+ (UIColor *)toolbarBtnTitleColor {
    return [UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1.0f];
}



@end
