//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController
#import "IMYWebView.h"

@interface SVWebViewController : UIViewController<IMYWebViewDelegate>

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

- (void)setWebUrlString:(NSString*)urlString;

@property (nonatomic, weak) id<IMYWebViewDelegate> delegate;

- (BOOL)needToolbarItems;

@end
