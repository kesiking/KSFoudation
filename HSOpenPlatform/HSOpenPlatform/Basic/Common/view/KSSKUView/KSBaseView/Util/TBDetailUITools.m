//
//  TBDetailUITools.m
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailUITools.h"
#import "TBDetailSystemUtil.h"


@implementation TBDetailUITools
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AttributeString
+(UIFont *)getPriceTailFont:(TBDetailFontStyle)fontStyle sizeType:(TBDetailFontSize)sizeType
{
    if (sizeType == TBDetailFontSize_Price0) { //一级价格字体大小
        return [TBDetailUIStyle fontWithStyle:fontStyle size:TBDetailFontSize_Price0Tail];
    } else if (sizeType == TBDetailFontSize_Price1) {   //二级价格字体大小
        return [TBDetailUIStyle fontWithStyle:fontStyle size:TBDetailFontSize_Price1Tail];
    } else {
        return [TBDetailUIStyle fontWithStyle:fontStyle size:sizeType];
    }
}

+(NSAttributedString *)transferPriceTextToAttributeString:(NSString *)text
                                                fontStyle:(TBDetailFontStyle)fontStyle
                                                 sizeType:(TBDetailFontSize)sizeType
{
    if (text.length <= 0 ) {// || [TBDetailSystemUtil systemVersionIsLessThan6_0]) {
        /*低于iOS6平台不支持AttributedString*/
        return nil;
    }
    
    UIFont *priceFont  = [TBDetailUIStyle fontWithStyle:fontStyle size:sizeType];
    UIFont *weishuFont = [TBDetailUITools getPriceTailFont:fontStyle sizeType:sizeType];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:text];
    NSString *dot = @".";
    
    /*设置初始字体*/
    [result addAttribute:NSFontAttributeName value:priceFont range:NSMakeRange(0, text.length)];
    
    NSRange dotRange = [text rangeOfString:dot];
    if (dotRange.location == NSNotFound || (dotRange.location + dotRange.length == text.length)) {
        /*当前价格没有小数点 or 有小数点，但是小数点后没有尾数*/
        return result;
    }
    
    NSUInteger firstDot = dotRange.location + 1;
    NSUInteger secondDot = 0;
    /*判断是否只有一个小数点*/
    dotRange = [[text substringFromIndex:firstDot] rangeOfString:dot];
    if (dotRange.location != NSNotFound) {
        secondDot = firstDot + dotRange.location + 1;
    }
    
    /*将第一个小数点后的小数设置为位数的字体*/
    NSUInteger tailLength = 0;
    if (secondDot > 0) { //不止一个小数点
        /*找到价格之间的连接符*/
        NSUInteger index = firstDot;
        char num = [text characterAtIndex:index];
        while (num >= '0' && num <= '9') {
            ++tailLength;
            ++index;
            num = [text characterAtIndex:index];
        }
    } else {
        tailLength = text.length - firstDot;
    }
    [result addAttribute:NSFontAttributeName value:weishuFont range:NSMakeRange(firstDot, tailLength)];
    
    if (secondDot > 0) {
        tailLength = text.length - secondDot;
        [result addAttribute:NSFontAttributeName value:weishuFont range:NSMakeRange(secondDot, tailLength)];
    }
    
    return result;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI Tools
+(UIView *)drawDivisionLine:(CGFloat)x yPos:(CGFloat)y lineWidth:(CGFloat)lineWidth
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, lineWidth, 0.5)];
    [line setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]];
    return line;
}

+(UIView *)drawFullDivisionLine:(CGFloat)yPos
{
    return [TBDetailUITools drawDivisionLine:0 yPos:yPos lineWidth:[TBDetailSystemUtil getCurrentDeviceWidth]];
}

+(UIView *)drawCenterDivisionLine:(CGFloat)yPos
{
    return [TBDetailUITools drawDivisionLine:[TBDetailUITools getDetailBorderGap] yPos:yPos
                                   lineWidth:[TBDetailUITools getAvailableSpaceWidth]];
}

+(UIView *)drawVerticalDivisionLine:(CGFloat)x yPos:(CGFloat)y lineHeight:(CGFloat)lineHeight
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, 0.5, lineHeight)];
    [line setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]];
    return line;
}

+(UIView *)drawDivisionGrayView:(CGFloat)yPos
{
    CGRect frame     = CGRectMake(0, yPos, [TBDetailSystemUtil getCurrentDeviceWidth], 12);
    UIView *grayView = [[UIView alloc] initWithFrame:frame];
    [grayView setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_PageBg]];
    return grayView;
}

+(NSInteger)getAvailableSpaceWidth
{
    static NSInteger width = 0;
    if (width == 0) {
        CGFloat borderGap = [TBDetailUITools getDetailBorderGap];
        width = [TBDetailSystemUtil getCurrentDeviceWidth] - borderGap * 2;
    }
    return width;
}

+(NSInteger)getDetailBorderGap
{
    static NSInteger borderGap = 0;
    if (borderGap == 0) {
        borderGap = round(10 * [TBDetailSystemUtil getWidthRatioCompareToIphone4]);
    }
    return borderGap;
}

+(NSInteger)getDetailRateSubBorderGap
{
    static NSInteger borderGap = 0;
    if (borderGap == 0) {
        borderGap = round(14 * [TBDetailSystemUtil getWidthRatioCompareToIphone4]);
    }
    return borderGap;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Others
+(BOOL)checkEmptyString:(NSString *)text
{
    if (text == nil || text.length <= 0 || [text isEqualToString:@" "]) {
        return YES;
    }
    return NO;
}

+(BOOL)checkIfIsNumberString:(NSString *)text
{
    if ([self checkEmptyString:text]) { //字符串为空
        return NO;
    }
    
    if ([text componentsSeparatedByString:@"."].count > 2) {
        return NO;
    }
    
    for (int i = 0; i < text.length; ++i) {
        char c = [text characterAtIndex:i];
        if ((c < '0' || c > '9') && (c != '.')) {
            return NO;
        }
    }
    
    return YES;
}

+(NSString *)transferNumberLongToShort:(NSString *)count
{
    if (![self checkIfIsNumberString:count]) {
        return count;
    }
    
    double fansCount         = [count doubleValue];
    int level                = 0;
    NSInteger hundredMillion = 100000000;
    NSInteger myriad         = 10000;

    if (fansCount >= hundredMillion) {
        fansCount = fansCount / hundredMillion;
        level = 2;
    } else if (fansCount >= myriad){
        fansCount = fansCount / myriad;
        level = 1;
    }
    
    if (level > 0) {
        /*若有小数则取两位，否则不显示小数点*/
        count = [NSString stringWithFormat:@"%.2f",fansCount];
        NSRange range = [count rangeOfString:@"."];
        if (range.location != NSNotFound) { //一定能够找到
            if ([[count substringFromIndex:range.location+1] isEqualToString:@"00"]) {
                count = [count substringToIndex:range.location]; //不要显示小数点
            }
        }
        
        if (level == 1) {
            count = [count stringByAppendingString:@"万"];
        } else if (level == 2){
            count = [count stringByAppendingString:@"亿"];
        }
    }
    
    return count;
}

+(CGSize)getLabelSize:(NSString *)text font:(UIFont *)font constrainedSize:(CGSize)size
{
    
    if ([self checkEmptyString:text] || font == nil) {
        return CGSizeMake(0, 0);
    }
    
    if (size.width == 0 && size.height == 0) { //不限制大小
        size = CGSizeMake(800, 1000);
    }
    
    CGSize labelSize;
    if ([TBDetailSystemUtil systemVersionIsLessThan7_0]) {
        labelSize = [text sizeWithFont:font constrainedToSize:size];
    } else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:text];
        [attributeString addAttribute:NSFontAttributeName
                                value:font
                                range:range];
        labelSize = [attributeString boundingRectWithSize:size
                                                  options:NSStringDrawingTruncatesLastVisibleLine
                                                  context:nil].size;
    }
    
    return CGSizeMake(ceilf(labelSize.width), ceilf(labelSize.height));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Level
+(NSString *)getGradeImage:(NSString *)preFix grade:(NSInteger)grade
{
    NSInteger section = grade / 5 + 1;
    NSInteger offset = grade % 5;
    
    if (offset == 0 && section > 1) {
        offset = 5;
        section -= 1;
    }
    
    NSString *name = [NSString stringWithFormat:@"%@-%ld-%ld", preFix, (long)section, (long)offset];
    return name;
}

@end
