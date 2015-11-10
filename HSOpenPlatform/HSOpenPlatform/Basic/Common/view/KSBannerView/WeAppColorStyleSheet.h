//
//  WeAppColorStyleSheet.h
//  taobao4iphone
//
//  Created by 燕 晨 on 12-9-20.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

typedef  enum  {
    TBColorAa=0,
    TBColorAb,
    TBColorB,
    TBColorC,    TBColorD,    TBColorE,    TBColorF,    TBColorG,    TBColorH,    TBColorI,    TBColorJ, TBColorL,TBColorK,
    TBColorBG_A,TBColorBG_B,TBColorBG_C,TBColorBG_D,TBColorBG_E,TBColorBG_F,TBColorBG_G
} TBColors;

@interface WeAppColorStyleSheet : NSObject

+ (UIColor *)colorWithColorType:(TBColors)colorType;

+ (UIColor *)colorOfWhite204;

+ (UIColor *)colorOfWhite221;

+ (UIColor *)colorOfWhite238;

+ (UIColor *)colorOfWhite249;

+ (UIColor *)orangeColor;

+ (UIColor *)toolbarBtnTitleColor;

+ (UIColor *)separatorColor;
+ (UIColor *)cellSeparatorColor;

+ (UIColor *)tableSeparatorColor;
+ (UIColor *)categoryTableSeparatorColor;
+ (UIColor *)tableviewCellSelectionBackground;
+ (UIColor *)colorDb;

@end
