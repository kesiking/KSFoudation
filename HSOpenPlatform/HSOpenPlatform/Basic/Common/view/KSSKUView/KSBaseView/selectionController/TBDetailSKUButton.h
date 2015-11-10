//
//  TBDetailUIButton.h
//  TBTradeDetail
//
//  Created by chen shuting on 14/11/19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBDetailSKUButton : UIButton

@property (nonatomic,assign)  BOOL buttonDidSeleced;

/**
 *  设置在不同状态下按钮的背景颜色
 *
 *  @param backgroundColor 背景颜色
 *  @param state           状态
 */
-(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 *  设置不同状态下的边框颜色
 *
 *  @param borderColor 边框颜色
 *  @param state       状态
 */
-(void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state;

/**
 *  获取当前按钮的状态
 *
 *  @return 状态
 */
-(UIControlState)getCurrentState;

@end
