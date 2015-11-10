//
//  TBDetailUIStyle.h
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
typedef enum{
    /**
     *  一级标题字体颜色:纯黑色
     */
    TBDetailColorStyle_Title0,
    /**
     *  二级标题字体颜色:黑色
     */
    TBDetailColorStyle_Title1,
    /**
     *  三级标题字体颜色:深灰色
     */
    TBDetailColorStyle_Title2,
    /**
     *  四级标题字体颜色:浅灰色
     */
    TBDetailColorStyle_Title3,
    /**
     *  标的字体颜色:白
     */
    TBDetailColorStyle_Tag,
    /**
     *  追加评价的颜色
     */
    TBDetailColorStyle_AppendRate,
    /**
     *  活动价格的字体颜色:橘黄
     */
    TBDetailColorStyle_Price0,
    /**
     *  普通价格的字体颜色:黑色
     */
    TBDetailColorStyle_Price1,
    /**
     *  原件or失效价格的字体颜色:灰色
     */
    TBDetailColorStyle_Price2,
    /**
     *  聚划算价格的字体颜色:白色
     */
    TBDetailColorStyle_Price3,
    /**
     *  商品推荐价格字体颜色:橙色
     */
    TBDetailColorStyle_Price4,
    /**
     *  主页面的背景颜色:灰色
     */
    TBDetailColorStyle_PageBg,
    /**
     *  通用组件背景颜色：白色
     */
    TBDetailColorStyle_ComponentBg1,
    /**
     *  特殊组件背景颜色：浅灰色
     */
    TBDetailColorStyle_ComponentBg2,
    /**
     *  分割线/普通按钮边框的颜色: 深灰色
     */
    TBDetailColorStyle_LineColor1,
    /**
     *  高亮边框颜色: 红色
     */
    TBDetailColorStyle_LineColor2,
    /**
     *  淘系色表：黄
     */
    TBDetailColorStyle_Yellow,
    /**
     *  淘系色表：蓝
     */
    TBDetailColorStyle_Blue,
    /**
     *  淘系色表：绿
     */
    TBDetailColorStyle_Green,
    /**
     *  淘系色表：橙
     */
    TBDetailColorStyle_Orange,
    /**
     *  淘系色表：白
     */
    TBDetailColorStyle_White,
    /**
     *  淘系色表：深灰
     */
    TBDetailColorStyle_DarkGray,
    /**
     *  淘系色表：灰
     */
    TBDetailColorStyle_Gray,
    /**
     *  淘系色表：纯黑
     */
    TBDetailColorStyle_Black,
    /**
     *  淘系色表：浅灰
     */
    TBDetailColorStyle_LightGray,
    /**
     *  底部导航栏按钮高亮:黄
     */
    TBDetailColorStyle_ButtonNormal1,
    /**
     *  底部导航栏按钮高亮:淘系黄
     */
    TBDetailColorStyle_ButtonNormal2,
    /**
     *  底部导航栏按钮高亮:姜黄
     */
    TBDetailColorStyle_ButtonHighlight1,
    /**
     *  底部导航栏按钮高亮:橙红
     */
    TBDetailColorStyle_ButtonHighlight2,
    /**
     *  底部导航栏按钮失效:浅灰
     */
    TBDetailColorStyle_ButtonDisabled,
    /**
     *  失效button分割线颜色
     */
    TBDetailColorStyle_ButtonDisabledLine,
    /**
     *  导航栏按钮的背景色
     */
    TBDetailColorStyle_NaviBg,
    /*
     *  聚划算预热状态的颜色，草绿色
     */
    TBDetailColorStyle_JHSPrewarmColor,
    /*!
     *  聚划算开团状态的颜色，粉色
     */
    TBDetailColorStyle_JHSBuyingColor,
    /*!
     *  聚划算背景颜色，浅粉色
     */
    TBDetailColorStyle_JHSBackColor,
    /*!
     *  屋满SKUbutton字体颜色，0x333333
     */
    TBDetailColorStyle_SKUButtonColor
}TBDetailColorStyle;

typedef enum {
    /**
     *  中文普通字体
     */
    TBDetailFontStyle_Chinese,
    /**
     *  中文加粗字体
     */
    TBDetailFontStyle_ChineseBold,
    /**
     *  英文/数字普通字体
     */
    TBDetailFontStyle_English,
    /**
     *  英文/数字加粗字体
     */
    TBDetailFontStyle_EnglishBold,
    /**
     *  数字普通字体
     */
    TBDetailFontStyle_Number,
    /**
     *  iconFont字体
     */
    TBDetailFontStyle_IconFont,
}TBDetailFontStyle;

typedef enum{
    /**
     *  一级标题字体大小:16
     */
    TBDetailFontSize_Title0,
    /**
     *  二级标题字体大小:14
     */
    TBDetailFontSize_Title1,
    /**
     *  三级标题字体大小:12
     */
    TBDetailFontSize_Title2,
    /**
     *  四级标题字体大小:10
     */
    TBDetailFontSize_Title3,
    /**
     *  一级价格字体大小:活动促销价格 22
     */
    TBDetailFontSize_Price0,
    /**
     *  一级价格位数字体大小:18
     */
    TBDetailFontSize_Price0Tail,
    /**
     *  二级价格字体大小:预售、normal价格、聚划算…… 18
     */
    TBDetailFontSize_Price1,
    /**
     *  二级价格位数字体大小: 14
     */
    TBDetailFontSize_Price1Tail,
    /**
     *  三级价格字体大小:原始价格/失效价格 12
     */
    TBDetailFontSize_Price2,
    /**
     *  标的字体大小 10
     */
    TBDetailFontSize_Tag,
    /**
     *  消保区域icon的字体大小 14
     */
    TBDetailFontSize_GroupIcon,
    /**
     *  店铺区块icon的大小 18
     */
    TBDetailFontSize_ShopIcon,
    /**
     *  分享按钮的icon大小 20
     */
    TBDetailFontSize_ShareIcon,
    /**
     *  购物车的icon大小 20
     */
    TBDetailFontSize_ShopCartIcon,
    /**
     *  底部导航栏icon的大小
     */
    TBDetailFontSize_ToolIcon,
    /**
     *  顶部导航栏中间的字体大小 18
     */
    TBDetailFontSize_NaviCenter,
    /**
     *  详情页面右箭头号的大小 15
     */
    TBDetailFontSize_RightArrow
}TBDetailFontSize;

@interface TBDetailUIStyle : NSObject
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Color
/**
 *  根据传入的颜色样式，初始化创建颜色
 *
 *  @param style 颜色样式
 *
 *  @return 颜色对象
 */
+(UIColor *)colorWithStyle:(TBDetailColorStyle)style;

/**
 *  根据传入的颜色样式和透明度初始化创建颜色
 *
 *  @param style 颜色样式
 *  @param alpha 透明度
 *
 *  @return 颜色对象
 */
+(UIColor *)colorWithStyle:(TBDetailColorStyle)style alpha:(float)alpha;

/**
 *  根据传入的HexString创建一个颜色
 *
 *  @param colorStirng 颜色字符串
 *
 *  @return 颜色
 */
+(UIColor *)colorWithHexString:(NSString *)colorStirng;

/**
 *  根据传入的HexString创建一个颜色
 *
 *  @param colorStirng 颜色字符串
 *  @param alpha       透明度
 *
 *  @return 颜色
 */
+(UIColor *)colorWithHexString:(NSString *)colorStirng alpha:(float)alpha;

/**
 *  根据颜色的类型转化为颜色字符串
 *
 *  @param style 类型
 *
 *  @return 颜色字符串
 */
+(NSString *)colorTypeToString:(TBDetailColorStyle)style;

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Font
/**
 *  字体大小
 *
 *  @param size 根据传入
 *
 *  @return 字体大小
 */
+ (int)fontWithSizeType:(TBDetailFontSize)sizeType;

/**
 *  根据传入的字体类型和大小初始化创建字体
 *
 *  @param style    字体样式
 *  @param sizeType 字体大小
 *
 *  @return 字体对象
 */
+ (UIFont *)fontWithStyle:(TBDetailFontStyle)style size:(TBDetailFontSize)sizeType;

/**
 *  根据传入的字体类型和指定的字体大小创建字体
 *
 *  @param style    字体样式
 *  @param fontSize 字体大小
 *
 *  @return 字体
 */
+ (UIFont *)fontWithStyle:(TBDetailFontStyle)style specificSize:(CGFloat)fontSize;


+ (UIImage *)createImageWithColor:(UIColor *) color;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

@end
