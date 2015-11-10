//
//  KSViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-17.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSFoundationCommon.h"
#import "TBModelStatusHandler.h"

@interface KSViewController : UIViewController

@property(nonatomic,assign) BOOL                                isViewAppeared;

@property(nonatomic,strong) TBModelStatusHandler*               statusHandler;

// override for subclass 改变viewFrame时使用
-(void)measureViewFrame;

// override for subclass 发生错误后点击或是需要刷新时调用可刷新页面数据
-(void)refreshDataRequest;

// call by subclass 统一展示错误页面，错误信息可通过 statusHandler的statusInfo绑定
-(void)showLoadingView;

-(void)showLoadingViewAfterDelay:(NSTimeInterval)delay;

-(void)hideLoadingView;

-(void)showErrorView:(NSError*)error;

-(void)hideErrorView;

-(void)showEmptyView;

-(void)hideEmptyView;

@end
