//
//  KSWebViewURLResolver.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/9/19.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSWebViewURLResolver.h"
#import "KSWebViewController.h"

@implementation KSWebViewURLResolver

-(UIViewController *)viewControllerWithAction:(TBURLAction *)action {
    if([[action.URL scheme] isEqualToString:@"http"] || [[action.URL scheme] isEqualToString:@"https"]){
        KSWebViewController *webViewController = [[KSWebViewController alloc] initWithAddress:action.urlPath];
        return webViewController;
    }
    return nil;
}

@end
