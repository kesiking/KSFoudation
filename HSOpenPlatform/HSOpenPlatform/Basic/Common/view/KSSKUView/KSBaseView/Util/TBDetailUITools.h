//
//  TBDetailUITools.h
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBDetailUIStyle.h"
#import <UIKit/UIKit.h>

@interface TBDetailUITools : NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AttributeString
/**
 *  将价格转化为属性字符串
 *  特点：将小数点后的数字变为尾数的字号
 *
 *  @param text 价格字符串
 *  @param sizeType 价格字体的类型
 *
 *  @return 带有属性的字符串
 */
+(NSAttributedString *)transferPriceTextToAttributeString:(NSString *)text
                                                fontStyle:(TBDetailFontStyle)fontStyle
                                                 sizeType:(TBDetailFontSize)sizeType;


//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI Tools
/**
 *  绘制一条水平分割线
 *
 *  @param x         x坐标
 *  @param y         y坐标
 *  @param lineWidth 线的宽度
 *
 *  @return 分割线视图
 */
+(UIView *)drawDivisionLine:(CGFloat)x yPos:(CGFloat)y lineWidth:(CGFloat)lineWidth;

/**
 *  绘制一条宽度与屏幕宽度相同的分割线
 *
 *  @param yPos y坐标
 *
 *  @return 分割线视图
 */
+(UIView *)drawFullDivisionLine:(CGFloat)yPos;

/**
 *  绘制一条去除左右留白局域的居中对齐的分割线
 *
 *  @param yPos y坐标
 *
 *  @return 分割线视图
 */
+(UIView *)drawCenterDivisionLine:(CGFloat)yPos;

/**
 *  绘制一条垂直分割线
 *
 *  @param x         x坐标
 *  @param y         y坐标
 *  @param lineHeight 线的高度
 *
 *  @return 分割线视图
 */
+(UIView *)drawVerticalDivisionLine:(CGFloat)x yPos:(CGFloat)y lineHeight:(CGFloat)lineHeight;

/**
 *  绘制详情页面的灰色分隔视图
 *
 *  @param yPos y轴坐标
 *
 *  @return 灰色分隔视图
 */
+(UIView *)drawDivisionGrayView:(CGFloat)yPos;

/**
 *  获得除去边部留白之后的可用绘制空间的宽度：10pt
 *  [注]根据不同的屏幕宽度进行适配，返回的是一个整数
 *
 *  @return 宽度
 */
+(NSInteger)getAvailableSpaceWidth;

/**
 *  获取详情的左右留白: 10pt
 *  【注】根据不同的屏幕宽度进行适配，返回的是一个整数
 *
 *  @return 边距值
 */
+(NSInteger)getDetailBorderGap;

/**
 *  获取评价页面，单条评价的左右边距
 *
 *  @return 边距值
 */
+(NSInteger)getDetailRateSubBorderGap;

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Others

/**
 *  检查当前是否为空字符串
 *
 *  @param text 待检查文案
 *
 *  @return YES：为空字符串；NO：不为空字符串
 */
+(BOOL)checkEmptyString:(NSString *)text;

/**
 *  判断当前的字符串是否为数字
 *  [注]若传入空字符串则返回NO
 *
 *  @param text 带检查文案
 *
 *  @return YES：当前为数字字符串；NO：不为数字字符串
 */
+(BOOL)checkIfIsNumberString:(NSString *)text;

/**
 *  将长的个位数转换为单位(万/亿)……
 *
 *  @param count 数字字符串
 *
 *  @return 缩略单位字符串
 */
+(NSString *)transferNumberLongToShort:(NSString *)count;

/**
 *  获取label的大小。（规整过的大小）
 *
 *  @param text 文案
 *  @param font 字体
 *  @param size 限制大小
 *
 *  @return label的大小
 */
+(CGSize)getLabelSize:(NSString *)text font:(UIFont *)font constrainedSize:(CGSize)size;

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Level 
+(NSString *)getGradeImage:(NSString *)preFix grade:(NSInteger)grade;

@end
