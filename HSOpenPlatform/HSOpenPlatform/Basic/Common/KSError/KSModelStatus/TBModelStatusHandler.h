//
//  TBErrorHandler.h
//  Taobao2013
//
//  Created by 晨燕 on 12-12-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBModelStatusInfo;

@protocol TBModelStatusDelegate <NSObject>

@optional
- (SEL)selectorForError:(NSError*)error;
- (SEL)selectorForEmpty;

@end


@interface TBModelStatusHandler : NSObject

@property (nonatomic, strong) TBModelStatusInfo *statusInfo;
@property (nonatomic, assign) id<TBModelStatusDelegate> delegate;

@property (nonatomic, strong) void (^selectorForErrorBlock)(NSError* error);
@property (nonatomic, strong) void (^selectorForEmptyBlock)();

- (id)initWithStatusInfo:(TBModelStatusInfo *)info delegate:(id<TBModelStatusDelegate>)delegate;
- (id)initWithStatusInfo:(TBModelStatusInfo *)info;

- (void)removeStatusViewFromView:(UIView *)view;

- (UIView *)showEmptyViewInView:(UIView *)parentView frame:(CGRect)frame;

/*
 *  统一的loading效果
 */
- (void)showLoadingViewInView:(UIView *)parentView;
- (void)showLoadingViewInView:(UIView *)parentView frame:(CGRect)frame;
- (void)hideLoadingView;

- (UIView *)showViewforError:(NSError *)error inView:(UIView *)parentView frame:(CGRect)frame;
- (UIView *)showViewforError:(NSError *)error inView:(UIView *)parentView frame:(CGRect)frame actionTarget:(id)actionTarget actionSelector:(SEL)actionSelector;
@end
