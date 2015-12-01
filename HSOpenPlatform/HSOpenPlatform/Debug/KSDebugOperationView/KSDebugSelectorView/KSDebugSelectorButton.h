//
//  KSDebubSelectorButton.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugBasicMenuItemView.h"

@interface KSDebugSelectorButton : KSDebugBasicMenuItemView

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

@end
