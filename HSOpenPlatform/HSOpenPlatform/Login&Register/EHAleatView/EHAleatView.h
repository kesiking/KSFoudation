//
//  EHAleatView.h
//  eHome
//
//  Created by 孟希羲 on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHAleatView;

typedef void(^clickedButtonAtIndexBlock) (EHAleatView * alertView, NSUInteger index);

@interface EHAleatView : UIAlertView<UIAlertViewDelegate>

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message clickedButtonAtIndexBlock:(clickedButtonAtIndexBlock)clickedButtonAtIndex cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property (nonatomic, copy)   clickedButtonAtIndexBlock   clickedButtonAtIndex;

// 可设置自定义view，如果子类继承可用getCustomView，如果关联使用可用customView属性
@property (nonatomic, strong) UIView*                     customView;

- (void)config;

// override by subclass for change aleatview show
- (UIView*)getAleatCustomView;

@end
