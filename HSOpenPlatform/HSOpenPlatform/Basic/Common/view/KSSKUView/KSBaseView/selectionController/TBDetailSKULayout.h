//
//  TBDetailSKULayout.h
//  TBTradeDetail
//
//  Created by 溸馨 on 14-10-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef TBTradeDetail_TBDetailSKULayout_h
#define TBTradeDetail_TBDetailSKULayout_h

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common
/*参数定义*/
#define TBSKU_RATIO     (TB_SCREEN_WIDTH / TBDETAIL_IPHONE_5_WIDTH)     //放大比例

/*间隔*/
//#define TBSKU_BORDER_GAP                  round(TBSKU_RATIO * 10)   //sku左右间隔定义
#define TBSKU_BORDER_GAP                  10   //sku左右间隔定义
#define TBSKU_HEADER_LINE_GAP             2   //sku头部的文字行间隔
#define TBSKU_VERTICAL_GAP                16  //sku行间距。例如：属性上下间隔

/*字体大小定义*/
#define TBSKU_TITLE_FONTSIZE            14  //sku标题字体大小：cell的标题、价格
#define TBSKU_SUBTITLE_FONTSIZE         12  //SKU副标题字体大小：文案
#define TBSKU_PRICE_FONTSIZE            16  //价格的字体大小
#define TBSKU_BOTTOMBUTTON_FONT_SIZE    16  //sku页面底部按钮字体大小

/*字体颜色定义*/
#define TBSKU_PRICE_COLOR   [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]//价格的字体颜色
#define TBSKU_TEXT_COLOR    [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Title1]//库存量信息的字体颜色
#define TBSKU_TITLE_COLOR   [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Title2]//其他文案的字体颜色


/*宽度定义*/
#define TBSKU_CONTROL_WIDTH       ([TBDetailSystemUtil getCurrentDeviceWidth] - TBSKU_BORDER_GAP * 2)                    //sku控件的宽度
#define TBSKU_LINE_WIDTH          ([TBDetailSystemUtil getCurrentDeviceWidth] - TBSKU_BORDER_GAP * 2)                    //分割线的宽度

/*高度定义*/
#define TBSKU_CONTROL_HEIGHT    30//选择控件的高度

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SKU头部
/*图片大小定义*/
#define TBSKU_HEADER_CLOSE_IMG_SIZE 22//头部关闭按钮图片大小
#define TBSKU_HEADER_IMG_SIZE       118//头部缩略图大小
#define TBSKU_HEADER_IMG_SIZE2      53

/*间隔*/
#define TBSKU_HEADER_VERTICAL_GAP         16//sku头部区域与上下的间隔
#define TBSKU_HEADER_TOPBG_GAP            22//头部图片与头部实际背景的间隔
#define TBSKU_HEADER_CLOSE_BORDER_GAP      8//关闭按钮距离右和上边框的间距

/*价格文案的相关间距*/
#define TBSKU_HEADER_DINGJING_AFTER_PRICE 6 //sku头部定金与价格之间的间距
#define TBSKU_HEADER_STORE_AFTER_PRICE    4 //sku头部库存量与价格的距离
#define TBSKU_HEADER_PRICE_TOP_GAP        20//价格与顶部的间距
#define TBSKU_HEADER_BELOW_PRICE_GAP      3//sku库存量与价格的垂直间距
#define TBSKU_HEADER_BELOW_STORE_GAP      3//sku文案与库存量的垂直间隔
#define TBSKU_HEADER_BETWEEN_HEADIMG      12//价格等文案与头图的距离
#define TBSKU_HAEDER_BETWEEN_CLOSEBTN     5//文案与关闭按钮之间的间距

/*高度*/
#define TBSKU_HEADER_HEIGHT     (TBSKU_HEADER_VERTICAL_GAP + TBSKU_HEADER_IMG_SIZE)//sku头部区域高度
#define TBSKU_HEADER_BG_HEIGHT  (TBSKU_HEADER_HEIGHT - TBSKU_HEADER_TOPBG_GAP) //头部实际背景的高度

/*宽度*/
#define TBSKU_HEADER_BORDER_WIDTH 2 //头图边框的宽度

/*字体定义*/
#define TBSKUFONT_PRICE    TBDETAIL_ENGLISH_FONT(TBSKU_PRICE_FONTSIZE)   //sku价格字体
#define TBSKUFONT_SKU_TEXT TBDETAIL_CHINESE_FONT(TBSKU_SUBTITLE_FONTSIZE)//库存量和sku提示文案字体

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 条码购
/*间隔*/
#define TBSKU_BARCODE_TOP_GAP      39//条码购frame与顶部的距离

/*高度*/
#define TBSKU_BARCODE_HEIGHT       40//条码够区域的高度
#define TBSKU_BARCODE_LABEL_HEIGHT 30//条码购label的高度

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 区域限售
/*间隔*/
#define TBSKU_AREA_TITLE_TOP_GAP    13//区域限售title与顶部的距离
#define TBSKU_AREA_TITLE_BOTTOM_GAP 12//区域限售选择按钮与标题的间隔

/*宽度*/

/*高度*/
#define TBSKU_AREA_TITLE_HEIGHT     20//区域限售标题高度
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 属性选择
/*间隔*/
#define TBSKU_PROP_LINE_GAP        10 //属性选择按钮的行间距
#define TBSKU_PROP_HORIZONTAL_GAP  10//属性选择按钮的水平间距
#define TBSKU_PROP_TITLE_BELOW_GAP 10//属性选择标题与属性的间距

/*参数定义*/
#define TBSKU_PROP_BUTTON_MORE_THAN_ONE 15//超过一行的条件

/*宽度定义*/
#define TBSKU_PROP_BUTTON_MAX_WIDTH 50          //sku属性选择按钮的最大宽度
#define TBSKU_PROP_BUTTON_WIDTH_INNER_WIDTH 20  //sku属性选择按钮的左右留白总和

/*高度定义*/
#define TBSKU_PROP_BUTTON_SINGLE_HEIGHT    30//属性选择按钮单行的高度
#define TBSKU_PROP_BUTTON_DOUBLE_HEIGHT    35//属性选择按钮双行的高度
#define TBSKU_PROP_TITLE_LABLE_HEIGHT      15//标题label的高度
#define TBSKU_PROP_TITLE_HEIGHT            30//属性标题的高度
//#define TBSKU_PROP_SELECTIONTITLE_HEIGHT   (TBSKU_HEADER_VERTICAL_GAP * 2 + TBSKU_TITLE_FONTSIZE)//sku属性选择标题高度定义
#define TBSKU_PROP_SELECTIONTITLE_HEIGHT   TBSKU_TITLE_FONTSIZE//sku属性选择标题高度定义

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 天猫服务赠送
#define TBSKU_SERVICE_TITLE_TOP_GAP 28  //天猫服务赠送标题与顶部的距离

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 级联选择（汽车配件）
/*间距*/
#define TBSKU_CAS_TITLE_TOP_GAP 10//级联选择标题与顶部的距离

/*宽度*/
#define TBSKU_CAS_LABLE_WIDTH   40//级联选择label的宽度

/*高度*/
#define TBSKU_CAS_TITLE_HEIGHT  20//级联选择标题的高度

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 计数器

/*宽度定义*/
#define TBSKU_NUMBER_STEPPER_WIDTH                                      98                   //计数器的宽度

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 底部导航栏

/*宽度定义*/
#define TBSKU_BOTTOM_BUTTON_WIDTH  ceilf(88 * TBSKU_RATIO)//确定/加入购物车/立即购买按钮的宽度

/*高度定义*/
#define TBSKU_BOTTOM_HEIGHT        48//底部工具栏的高度
#define TBSKU_BOTTOM_BUTTON_HEIGHT 44//底部区域button的高度

/*间隔定义*/
#define TBSKU_BOTTOM_BTN_TOPGAP    8 //底部区域button与顶部的间隔
#define TBSKU_BOTTOM_BTN_GAP       10//底部区域button之间的间隔

/*字体颜色定义*/
#define TBSKUCOLOR_SKU_TEXT [TBUIStyle colorWithStyle:TBColorStyle_L]   //sku文案字体颜色

#endif
