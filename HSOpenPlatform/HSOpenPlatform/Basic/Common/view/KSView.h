//
//  KSView.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-17.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBModelStatusHandler.h"

#define service_error_message @"服务器在偷懒，请稍后再试"

@class KSView;

typedef void(^viewFrameWillChangedBlock) (KSView* view, CGRect newFrame ,CGRect currentFrame);

typedef void(^viewFrameDidChangedBlock) (KSView* view, CGRect currentFrame ,CGRect oldFrame);

@interface KSView : UIView

@property(nonatomic,strong) TBModelStatusHandler*               statusHandler;

@property(nonatomic, copy)  viewFrameWillChangedBlock           viewFrameWillChangedBlock;

@property(nonatomic, copy)  viewFrameDidChangedBlock            viewFrameDidChangedBlock;

// 寻找Keyboard输入框
+ (UIView *)findKeyboard;

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
