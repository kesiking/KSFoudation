//
//  KSConfigCenter.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSConfigCenter.h"

static NSDictionary*         _matrixConfig = nil;
static NSMutableDictionary*  _urlResolverDict = nil;
static NSMutableDictionary*  _nametoClassDict = nil;

@implementation KSConfigCenter

+(void)configMatrix{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MatrixConfig" ofType:@"plist"];
    _matrixConfig = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (_matrixConfig == nil) {
        _matrixConfig = [[NSDictionary alloc] init];
    }
    [self configBundleList];
}

+(void)configBundleList{
    NSArray* bundleList = [_matrixConfig objectForKey:@"bundle_list"];
    if (bundleList == nil) {
        return;
    }
    [bundleList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && [obj isKindOfClass:[NSString class]]) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:obj ofType:@"plist"];
            NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            [self configBundlePlistWithDict:dict];
            [self configNametoClassDictWithDict:dict];
        }
    }];
}

+(void)configBundlePlistWithDict:(NSDictionary*)dict{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray* objectList = [dict objectForKey:@"object_list"];
    if (objectList == nil) {
        return;
    }
    if (_urlResolverDict == nil) {
        _urlResolverDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    [objectList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary* objDict = (NSDictionary*)obj;
            NSString* name = [objDict objectForKey:@"name"];
            NSString* class = [objDict objectForKey:@"class"];
            if (name && class && NSClassFromString(class)) {
                Class urlResolverClass = NSClassFromString(class);
                [_urlResolverDict setObject:urlResolverClass forKey:name];
            }
        }
    }];
    
}

+(void)configNametoClassDictWithDict:(NSDictionary*)dict{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if (_nametoClassDict == nil) {
        _nametoClassDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    NSDictionary* name_to_class = [dict objectForKey:@"name_to_class"];
    if (name_to_class && [name_to_class isKindOfClass:[NSDictionary class]]) {
        [_nametoClassDict addEntriesFromDictionary:name_to_class];
    }
}

+(NSDictionary*)getViewContollerNameToClassDict{
    return _nametoClassDict;
}

+(Class)getUrlResolverClassWithName:(NSString*)name{
    if (!_urlResolverDict || name == nil) {
        return NSClassFromString(@"KSBasicURLResolver");
    }
    Class urlResolverClass = [_urlResolverDict objectForKey:name];
    if (urlResolverClass == nil) {
        return NSClassFromString(@"KSBasicURLResolver");
    }
    return urlResolverClass;
}

+(Class)getWebViewUrlResolverClassWithURL:(NSURL*)url{
    return NSClassFromString(@"KSWebViewURLResolver");
}

+(Class)getReactViewUrlResolverClassWithURL:(NSURL*)url{
    return NSClassFromString(@"KSReactURLResolver");
}

+(BOOL)isHttpUrlWithURL:(NSURL*)url{
    if([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]){
        return YES;
    }
    return NO;
}

+(BOOL)isReactUrlWithURL:(NSURL*)url{
    if([[url scheme] isEqualToString:kInternalReactNativeURLScheme]){
        return YES;
    }
    return NO;
}

@end
