//
//  TBURLAction.m
//  Taobao4iPad
//
//  Created by Tim Cao on 12-4-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "TBURLAction.h"

@implementation TBURLAction

NSStringEncoding TBDefaultEncoding() {
    return NSUTF8StringEncoding;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

+ (id)actionWithURLPath:(NSString *)urlPath sourceController:(UIViewController *)sourceViewController {
    return [[TBURLAction alloc] initWithURLPath:urlPath sourceController:sourceViewController];
}

- (id)initWithURLPath:(NSString*)urlPath sourceController:(UIViewController*)sourceViewController {
    self = [super init];
    
    self.urlPath = urlPath;
    self.sourceController = sourceViewController;
    
    return self;

}

- (BOOL)isActionURLLegal{
    if (self.URL
        && [self.URL scheme]
        && [self.URL host]
        && [self.URL path]) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark Public Accessors

- (void)setUrlPath:(NSString*)urlPath {
    if (_urlPath != urlPath) {
        _urlPath = nil;
        _URL = nil;
        _urlPath = urlPath;
    }
}

- (NSURL*)URL {
    if (!_URL && _urlPath.length>0) {
        _URL = [NSURL URLWithString:_urlPath];
    }
    
    return _URL;
}

- (NSString*)getURLPathWithoutSlash{
    NSString* path = self.URL.path;
    if ([path length] > 0 && [path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return path;
}

@end
