//
//  WeAppSelectorButton.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppBasicMenuItemView.h"

@interface WeAppSelectorButton : WeAppBasicMenuItemView

// selector左边放置的icon图标
@property (nonatomic,strong) UIImageView *selectorIcon;
// selector右边放置的小红点
@property (nonatomic,strong) UIImageView *selectorPoint;
// selector右边放置的数字红点
@property (nonatomic,strong) UIImageView *selectorNumImage;
// selector的button包含点击事件，背景颜色，背景图片等
@property (nonatomic,strong) UIButton    *imageButton;
// selector右边放置的数字label
@property (nonatomic,strong) UILabel     *numberLabel;
// selector的文案描述
@property (nonatomic,strong) UILabel     *textLabel;

@property (nonatomic,assign) BOOL         isSelected;

// 设置selector的文案
-(void)setTitle:(NSString *)title forState:(UIControlState)state;
// 设置selector的Icon图标
-(void)setSelectorIcon:(NSString *)imageUrl forState:(UIControlState)state;
// 设置selector的Icon图标 含有显示参数
-(void)setSelectorIcon:(NSString *)imageUrl forState:(UIControlState)state forParam:(NSDictionary*)param;
// 设置selector的背景图片
-(void)setBackgroundImage:(NSString *)imageUrl forState:(UIControlState)state;
// 设置selector的背景图片 含有显示参数
-(void)setBackgroundImage:(NSString *)imageUrl forState:(UIControlState)state forParam:(NSDictionary*)param;
// 设置selector的数字红点属性，默认展示9+的情况
-(void)setNumber:(NSUInteger)number andNeedPoint:(BOOL)needPoint;
// 设置selector的数字红点属性,根据formatType及precision设定展示样式
/********************************************************
 具体规则见如下：
 http://confluence.taobao.ali.com/pages/viewpage.action?pageId=215910736#2.5.1_%E5%BE%AE%E6%B7%98_WeApp_%E5%8D%8F%E8%AE%AE-%E6%95%B0%E5%AD%97%E6%A0%BC%E5%BC%8Fformat%E7%9A%84%E6%94%AF%E6%8C%81
 ********************************************************/
-(void)setNumber:(NSUInteger)number formatType:(NSString*)formatType precision:(NSString*)precision andNeedPoint:(BOOL)needPoint;

@end
