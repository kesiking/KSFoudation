//
//  KSWebViewController.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/9/19.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "SVWebViewController.h"
#import "KSFoundationCommon.h"
#import "TBModelStatusHandler.h"

#define WEB_REQUEST_URL_ADDRESS_KEY @"__webRequestUrl__"
#define WEB_VIEW_TITLE_KEY @"__webViewTitle__"

@interface KSWebViewController : SVWebViewController

@property(nonatomic,assign) BOOL                                isViewAppeared;

@property(nonatomic,strong) TBModelStatusHandler*               statusHandler;

/*!
 *  @author 孟希羲, 15-10-14 13:10:23
 *
 *  @brief  override for subclass. subclass can control webview request for youself.
 *
 *  @param webView        UIWebView instance
 *
 *  @since 1.0
 */

- (BOOL)webViewController:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewControllerDidStartLoad:(IMYWebView *)webView;

- (void)webViewControllerDidFinishLoad:(IMYWebView *)webView;

- (void)webViewController:(IMYWebView *)webView didFailLoadWithError:(NSError *)error;

// override for subclass 可控制是否展示toolBar栏
- (BOOL)needToolbarItems;

// override for subclass 改变viewFrame时使用
- (void)measureViewFrame;

// override for subclass 发生错误后点击或是需要刷新时调用可刷新页面数据
- (void)refreshDataRequest;

// call by subclass 统一展示错误页面，错误信息可通过 statusHandler的statusInfo绑定
- (void)showLoadingView;

- (void)showLoadingViewAfterDelay:(NSTimeInterval)delay;

- (void)hideLoadingView;

- (void)showErrorView:(NSError*)error;

- (void)hideErrorView;

- (void)showEmptyView;

- (void)hideEmptyView;

@end
