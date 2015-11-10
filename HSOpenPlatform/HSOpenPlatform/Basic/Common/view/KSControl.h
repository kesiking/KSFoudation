//
//  KSControl.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSControl : UIControl

@property(nonatomic,strong) TBModelStatusHandler*               statusHandler;

// override for subclass 初始化当前view
-(void)setupView;

// override for subclass 发生错误后点击或是需要刷新时调用可刷新页面数据
-(void)refreshDataRequest;

// call by subclass 统一展示错误页面，错误信息可通过 statusHandler的statusInfo绑定
-(void)showLoadingView;

-(void)hideLoadingView;

-(void)showErrorView:(NSError*)error;

-(void)hideErrorView;

-(void)showEmptyView;

-(void)hideEmptyView;

-(BOOL)needTouchEventLog;

@end
