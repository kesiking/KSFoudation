//
//  EHExemptionDescriptionViewController.m
//  eHome
//
//  Created by xtq on 15/6/24.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "HSExemptionDescriptionViewController.h"

@implementation HSExemptionDescriptionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"免责说明";
    [self.view addSubview:[self agreementWebview]];
}

- (UIWebView*)agreementWebview
{
    UIWebView* webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kHSAGREEMENT_WEBVIEW_URL]]];
    /*
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
     */
    return webview;
}

@end
