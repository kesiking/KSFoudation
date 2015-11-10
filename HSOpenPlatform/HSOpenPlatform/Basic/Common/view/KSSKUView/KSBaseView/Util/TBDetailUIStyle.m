//
//  TBDetailUIStyle.m
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailUIStyle.h"
#import "TBDetailSystemUtil.h"
//#import "TBDetailIconFont.h"
@implementation TBDetailUIStyle
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Color
+ (UIColor *)colorWithStyle:(TBDetailColorStyle)style alpha:(float)alpha
{
    if (alpha >= 1) {
        alpha = 1;
    } else if (alpha <= 0) {
        alpha = 0;
    }
    
    switch (style) {
        case TBDetailColorStyle_Title0:
            return [self colorWithHex:0x000000 alpha:alpha];
        case TBDetailColorStyle_Title1:
            return [self colorWithHex:0x3d4245 alpha:alpha];
        case TBDetailColorStyle_Title2:
            return [self colorWithHex:0x5f646e alpha:alpha];
        case TBDetailColorStyle_Title3:
            return [self colorWithHex:0x999999 alpha:alpha];
        case TBDetailColorStyle_Tag:
            return [self colorWithHex:0xffffff alpha:alpha];
        case TBDetailColorStyle_AppendRate:
            return [self colorWithHex:0x4c566c alpha:alpha];
        case TBDetailColorStyle_Price0:
            return [self colorWithHex:0xff5000 alpha:alpha];
        case TBDetailColorStyle_Price1:
            return [self colorWithHex:0x3d4245 alpha:alpha];
        case TBDetailColorStyle_Price2:
            return [self colorWithHex:0x999999 alpha:alpha];
        case TBDetailColorStyle_Price3:
            return [self colorWithHex:0xffffff alpha:alpha];
        case TBDetailColorStyle_Price4:
            return [self colorWithHex:0xED6737 alpha:alpha];
        case TBDetailColorStyle_PageBg:
            return [self colorWithHex:0xeeeeee alpha:alpha];
        case TBDetailColorStyle_ComponentBg1:
            return [self colorWithHex:0xffffff alpha:alpha];
        case TBDetailColorStyle_ComponentBg2:
            return [self colorWithHex:0xf5f5f5 alpha:alpha];
        case TBDetailColorStyle_LineColor1:
            return [self colorWithHex:0xdddddd alpha:alpha];
        case TBDetailColorStyle_LineColor2:
            return [self colorWithHex:0xfd0000 alpha:alpha];
        case TBDetailColorStyle_Yellow:
            return [self colorWithHex:0xff5000 alpha:alpha];
        case TBDetailColorStyle_Blue:
            return [self colorWithHex:0x47b3f9 alpha:alpha];
        case TBDetailColorStyle_Green:
            return [self colorWithHex:0x6aa81f alpha:alpha];
        case TBDetailColorStyle_Orange:
            return [self colorWithHex:0xED6737 alpha:alpha];
        case TBDetailColorStyle_White:
            return [self colorWithHex:0xffffff alpha:alpha];
        case TBDetailColorStyle_DarkGray:
            return [self colorWithHex:0x5f646e alpha:alpha];
        case TBDetailColorStyle_Gray:
            return [self colorWithHex:0xdddddd alpha:alpha];
        case TBDetailColorStyle_Black:
            return [self colorWithHex:0x000000 alpha:alpha];
        case TBDetailColorStyle_LightGray:
            return [self colorWithHex:0x999999 alpha:alpha];
        case TBDetailColorStyle_ButtonNormal1:
            return [self colorWithHex:0xff9402 alpha:alpha];
        case TBDetailColorStyle_ButtonNormal2:
            return [self colorWithHex:0xff5000 alpha:alpha];
        case TBDetailColorStyle_ButtonHighlight1:
            return [self colorWithHex:0xef8223 alpha:alpha];
        case TBDetailColorStyle_ButtonHighlight2:
            return [self colorWithHex:0xe85423 alpha:alpha];
        case TBDetailColorStyle_ButtonDisabled:
            return [self colorWithHex:0xdddddd alpha:alpha];
        case TBDetailColorStyle_ButtonDisabledLine:
            return [self colorWithHex:0xcdcdcd alpha:alpha];
        case TBDetailColorStyle_NaviBg:
            return [self colorWithHex:0x3d4245 alpha:alpha];
        case TBDetailColorStyle_JHSPrewarmColor:
            return [self colorWithHex:0x18aa6b alpha:alpha];
        case TBDetailColorStyle_JHSBuyingColor:
            return [self colorWithHex:0xf72862 alpha:alpha];
        case TBDetailColorStyle_JHSBackColor:
            return [self colorWithHex:0xfff7f9 alpha:alpha];
        case TBDetailColorStyle_SKUButtonColor:
            return [self colorWithHex:0x333333 alpha:alpha];
        default:
            return [UIColor clearColor];
    }
}

+ (UIColor *)colorWithStyle:(TBDetailColorStyle)style
{
    return [TBDetailUIStyle colorWithStyle:style alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStirng
{
    return [self colorWithHexString:colorStirng alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStirng alpha:(float)alpha
{
    NSString *cString = [[colorStirng stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    /* String should be 6 or 8 characters */
    if ([cString length] < 6 || [cString length] > 8) {
        return [UIColor clearColor];
    }
    
    /* strip 0X if it appears */
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    };
    
    /* Separate into r, g, b substrings */
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (NSString *)colorTypeToString:(TBDetailColorStyle)style
{
    switch (style) {
        case TBDetailColorStyle_Title0:
            return @"0x000000";
        case TBDetailColorStyle_Title1:
            return @"0x3d4245";
        case TBDetailColorStyle_Title2:
            return @"0x5f646e";
        case TBDetailColorStyle_Title3:
            return @"0x999999";
        case TBDetailColorStyle_Tag:
            return @"0xffffff";
        case TBDetailColorStyle_AppendRate:
            return @"0x4c566c";
        case TBDetailColorStyle_Price0:
            return @"0xff5000";
        case TBDetailColorStyle_Price1:
            return @"0x3d4245";
        case TBDetailColorStyle_Price2:
            return @"0x999999";
        case TBDetailColorStyle_Price3:
            return @"0xffffff";
        case TBDetailColorStyle_Price4:
            return @"0xED6737";
        case TBDetailColorStyle_PageBg:
            return @"0xeeeeee";
        case TBDetailColorStyle_ComponentBg1:
            return @"0xffffff";
        case TBDetailColorStyle_ComponentBg2:
            return @"0xf5f5f5";
        case TBDetailColorStyle_LineColor1:
            return @"0xdddddd";
        case TBDetailColorStyle_LineColor2:
            return @"0xfd0000";
        case TBDetailColorStyle_Yellow:
            return @"0xff5000";
        case TBDetailColorStyle_Blue:
            return @"0x47b3f9";
        case TBDetailColorStyle_Green:
            return @"0x6aa81f";
        case TBDetailColorStyle_Orange:
            return @"0xED6737";
        case TBDetailColorStyle_White:
            return @"0xffffff";
        case TBDetailColorStyle_DarkGray:
            return @"0x5f646e";
        case TBDetailColorStyle_Gray:
            return @"0xdddddd";
        case TBDetailColorStyle_Black:
            return @"0x000000";
        case TBDetailColorStyle_LightGray:
            return @"0x999999";
        case TBDetailColorStyle_ButtonNormal1:
            return @"0xff9402";
        case TBDetailColorStyle_ButtonNormal2:
            return @"0xff5000";
        case TBDetailColorStyle_ButtonHighlight1:
            return @"0xef8223";
        case TBDetailColorStyle_ButtonHighlight2:
            return @"0xe85423";
        case TBDetailColorStyle_ButtonDisabled:
            return @"0xdddddd";
        case TBDetailColorStyle_ButtonDisabledLine:
            return @"0xcdcdcd";
        case TBDetailColorStyle_NaviBg:
            return @"0x3d4245";
        case TBDetailColorStyle_JHSPrewarmColor:
            return @"0x18aa6b";
        case TBDetailColorStyle_JHSBuyingColor:
            return @"0xf72862";
        case TBDetailColorStyle_JHSBackColor:
            return @"0xfff7f9";
    }
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Font
+ (int)fontWithSizeType:(TBDetailFontSize)sizeType
{
    switch (sizeType) {
        case TBDetailFontSize_Title0:
            return 16;
        case TBDetailFontSize_Title1:
            return 14;
        case TBDetailFontSize_Title2:
            return 12;
        case TBDetailFontSize_Title3:
            return 10;
        case TBDetailFontSize_Price0:
//            if([TBDetailSystemUtil systemVersionIsLessThan6_0]) {
//                return 16;
//            }
            return 22;
        case TBDetailFontSize_Price0Tail:
            return 18;
        case TBDetailFontSize_Price1:
            return 18;
        case TBDetailFontSize_Price1Tail:
            return 14;
        case TBDetailFontSize_Price2:
            return 12;
        case TBDetailFontSize_Tag:
            return 10;
        case TBDetailFontSize_GroupIcon:
            return 14;
        case TBDetailFontSize_ShopIcon:
            return 18;
        case TBDetailFontSize_ShareIcon:
            return 20;
        case TBDetailFontSize_ShopCartIcon:
            return 20;
        case TBDetailFontSize_ToolIcon:
            return 20;
        case TBDetailFontSize_NaviCenter:
            return 18;
        case TBDetailFontSize_RightArrow:
            return 15;
        default:
            return 12;
    }
}

+ (UIFont *)fontWithStyle:(TBDetailFontStyle)style size:(TBDetailFontSize)sizeType
{
    
    return [TBDetailUIStyle fontWithStyle:style
                             specificSize:[TBDetailUIStyle fontWithSizeType:sizeType]];
}

+ (UIFont *)fontWithStyle:(TBDetailFontStyle)style specificSize:(CGFloat)fontSize
{
    fontSize = (fontSize <= 0) ? 10 : fontSize;
    switch (style) {
        case TBDetailFontStyle_Chinese:
            return [UIFont systemFontOfSize:fontSize];
        case TBDetailFontStyle_ChineseBold:
            return [UIFont boldSystemFontOfSize:fontSize];
        case TBDetailFontStyle_English:
//            if ([TBDetailSystemUtil systemVersionIsLessThan6_0]) {
//                return [UIFont systemFontOfSize:fontSize];
//            } else {
            return [UIFont fontWithName:@"Avenir" size:fontSize];
//            }
        case TBDetailFontStyle_EnglishBold:
//            if ([TBDetailSystemUtil systemVersionIsLessThan6_0]) {
//                return [UIFont systemFontOfSize:fontSize];
//            } else {
            return [UIFont fontWithName:@"Avenir-Heavy" size:fontSize];
//            }
        case TBDetailFontStyle_Number:
            return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
        case TBDetailFontStyle_IconFont:
            return [UIFont systemFontOfSize:fontSize];
//            return [TBIconFont iconFontWithSize:fontSize];
        default:
            break;
    }
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}


+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage stretchableImageWithLeftCapWidth:theImage.size.width/2 topCapHeight:theImage.size.height/2];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
