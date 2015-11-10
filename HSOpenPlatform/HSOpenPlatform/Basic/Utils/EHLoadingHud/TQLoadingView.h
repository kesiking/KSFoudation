//
//  TQLoadingView.h
//  TQLoadingView
//
//  Created by xtq on 15/4/22.
//  Copyright (c) 2015年 one. All rights reserved.
//  该视图为了适配封装进行设计，单独使用需稍作修改等。

#import <UIKit/UIKit.h>

typedef void (^FinishBlock)();

@interface TQLoadingView : UIView

@property(nonatomic,assign)CGFloat lineCount;   //线段数量
@property(nonatomic,assign)CGFloat lineWidth;   //线段宽度
@property(nonatomic,assign)CGFloat subCount;    //组合成弧线的所有分段弧线的数量
@property(nonatomic,strong)UIColor *lineColor;  //线段颜色
@property(nonatomic,assign)CGFloat duration;    //动画一周的时间

- (void)show;                                  //显示

- (void)success:(FinishBlock)finishBlock;      //完成等待进行成功结束动画结束并回调

- (void)error:(FinishBlock)finishBlock;        //完成等待进行错误结束动画结束并回调

- (void)hide;                                  //主动结束

@end
