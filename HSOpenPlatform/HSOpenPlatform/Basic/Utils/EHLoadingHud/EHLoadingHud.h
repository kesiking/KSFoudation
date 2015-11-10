//
//  EHLoadingHud.h
//  6.29-tets-tqhud
//
//  Created by xtq on 15/6/29.
//  Copyright (c) 2015年 one. All rights reserved.
//  对MBProgressHUD对象和TQLoadingView进行整合封装

#import <UIKit/UIKit.h>
#import "TQLoadingView.h"
#import "MBProgressHUD.h"

typedef void (^FinishBlock)();

@interface EHLoadingHud : UIView

@property(nonatomic,assign)CGFloat lineCount;           //线段数量
@property(nonatomic,assign)CGFloat lineWidth;           //线段宽度
@property(nonatomic,assign)CGFloat subCount;            //组合成弧线的所有分段弧线的数量
@property(nonatomic,strong)UIColor *lineColor;          //线段颜色
@property(nonatomic,assign)CGFloat duration;            //动画一周的时间
@property(nonatomic,assign)CGFloat hideDelayTime;       //动画结束消失的延迟时间
@property(nonatomic,strong)FinishBlock hideFinishBlock; //hud完全隐藏之后的回调

/**
 *  显示hud
 */
- (void)showWithStatus:(NSString *)status InView:(UIView *)superView;

/**
 *  显示成功
 */
- (void)showSuccessWithStatus:(NSString *)status Finish:(FinishBlock)finish;

/**
 *  显示错误
 */
- (void)showErrorWithStatus:(NSString *)status Finish:(FinishBlock)finish;

/**
 *  不做处理主动隐藏
 */
- (void)hide:(BOOL)animated;

@end
