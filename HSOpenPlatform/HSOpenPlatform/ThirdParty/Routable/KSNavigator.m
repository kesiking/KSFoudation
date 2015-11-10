//
//  KSNavigator.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSNavigator.h"

static KSNavigator* _navigator = nil;
static NSMutableDictionary*  _registeredPlugin = nil;//全局共用,保存path
static NSMutableDictionary*  _registeredPluginUrl = nil;//全局共用,保存url
static NSMutableArray*  _sortedRegisteredUrlArray = nil;//全局共用,保存排序好的url,避免每次都排序
static NSString *_registerConflictInfo = nil;//全局共用,保存冲突信息.

@implementation KSNavigator

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Public

+ (KSNavigator*)navigator {
    if (!_navigator) {
        _navigator = [[KSNavigator alloc] init];
    }
    return _navigator;
}

+ (void)setNavigator:(KSNavigator*)navigator {
    if (_navigator != navigator) {
        _navigator = navigator;
    }
}

- (NSDictionary *)registeredPlugin {
    @synchronized([self class]){
        return _registeredPlugin;
    }
}

- (NSDictionary *)registeredPluginUrl {
    @synchronized([self class]){
        return _registeredPluginUrl;
    }
}

- (NSArray *)sortedRegisteredUrlArray{
    @synchronized([self class]){
        return _sortedRegisteredUrlArray;
    }
}

- (NSString *)registerConflictInfo{
    @synchronized([self class]){
        return _registerConflictInfo;
    }
}
#pragma mark register

- (void)registerClass:(NSString *)className withPath:(NSString *)path {
    @synchronized([self class]){
        [self checkDataContainerInit];
        
        [self checkKeyValueSpecification:_registeredPlugin key:path value:className method:__PRETTY_FUNCTION__];
        
        [_registeredPlugin setValue:className forKey:path];
    }
}

+ (void)registerClass:(NSString *)className withPath:(NSString *)path{
    [[self navigator] registerClass:className withPath:path];
}

- (void)registerClass:(NSString *)className withUrl:(NSString *)url{
    @synchronized([self class]){
        [self checkDataContainerInit];
        
        if(![self checkUrlSpecification:url className:className]){
            return ;//不规范则不让注册！
        }
        
        if([self checkKeyValueSpecification:_registeredPluginUrl key:url value:className method:__PRETTY_FUNCTION__]){
            [self sortRegisteredUrl:url];//如果之前已经有某个url了，就没必要再放入数组了
        }
        
        [_registeredPluginUrl setValue:className forKey:url];
        
    }
}

+ (void)registerClass:(NSString *)className withUrl:(NSString *)url{
    [[self navigator] registerClass:className withUrl:url];
}


#pragma mark check

- (void)sortRegisteredUrl:(NSString *)url{
    NSUInteger index = _sortedRegisteredUrlArray.count;
    for (int i = 0; i < _sortedRegisteredUrlArray.count; ++i) {
        NSString *registeredUrl = [_sortedRegisteredUrlArray objectAtIndex:i];
        if(url.length > registeredUrl.length){
            index = i;
            break;
        }
    }
    [_sortedRegisteredUrlArray insertObject:url atIndex:index];
}

- (void)checkDataContainerInit{
    if (!_registeredPlugin) {
        _registeredPlugin = [[NSMutableDictionary alloc] init];
    }
    if (!_registeredPluginUrl) {
        _registeredPluginUrl = [[NSMutableDictionary alloc] init];
    }
    if(!_sortedRegisteredUrlArray){
        _sortedRegisteredUrlArray = [[NSMutableArray alloc] init];
    }
}

//检查url规范性
- (BOOL)checkUrlSpecification:(NSString *)url className:(NSString *)className{
    if([url hasPrefix:@"app:"] || [url hasPrefix:@"http:"] || [url hasPrefix:@"https:"]){
        _registerConflictInfo = [[NSString alloc] initWithFormat:@"错误!注册url不符合规范.(%@ : %@)不应含有scheme前缀", className, url];
        return NO;
    }
    if([url hasSuffix:@"/"]){
        _registerConflictInfo = [[NSString alloc] initWithFormat:@"错误!注册url不符合规范.(%@ : %@)不应含有/后缀", className, url];
        return NO;
    }
    return YES;
}

- (BOOL)checkKeyValueSpecification:(NSDictionary *)dict key:(NSString *)key value:(NSString *)value method:(const char *)method{
    NSString *oldValue = [dict objectForKey:key];
    if(oldValue){
        if(![oldValue isEqualToString:value]){
            _registerConflictInfo = [[NSString alloc]  initWithFormat:@"警告!: %s冲突, (key:%@ newValue:%@ oldValue:%@)", method, key, value, oldValue];
        }else{
            _registerConflictInfo = [[NSString alloc]  initWithFormat:@"警告!: %s重复, (key:%@ newValue:%@ oldValue:%@)", method, key, value, oldValue];//提示重复了
        }
        return NO;
    }
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (BOOL)openURLAction:(TBURLAction*)action {
    KSBasicURLResolver *urlResolver = [[KSBasicURLResolver alloc] init];
    if(![urlResolver handleURLAction:action])
        return NO;
    UIViewController* continerViewController = [self containerViewControllerForController:action.sourceController navigateType:action.navigationParams.navigationType];
    if (continerViewController == nil) {
        return NO;
    }
    if (!action.targetController) {
        return NO;
    }
    if ([action.targetController isKindOfClass:[UINavigationController class]] && [((UINavigationController*)action.targetController).viewControllers count] > 0) {
        [[((UINavigationController*)action.targetController) topViewController] setOpenNavigateType:action.navigationParams.navigationType];
    }else{
        [action.targetController setOpenNavigateType:action.navigationParams.navigationType];
    }
    [continerViewController addSubcontroller:action.targetController navigateType:action.navigationParams.navigationType animated:action.navigationParams.animated];
    return YES;
}

- (BOOL)backURLAction:(TBURLAction*)action {
    UIViewController* controller = action.sourceController;
    if (controller.navigationController) {
        if ([[controller.navigationController viewControllers] count] > 1) {
            [controller.navigationController popViewControllerAnimated:YES];
        }else{
            return NO;
        }
    } else if(controller.presentedViewController){
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
    return YES;
}


- (BOOL)openMenuFromSource:(UIViewController *)source sender:(id)sender {
    return NO;
}

- (UIViewController*)containerViewControllerForController:(UIViewController *)viewController navigateType:(TBNavigationType)type {
    if ((type == TBNavigationTypePush || TBNavigationTypePop == type)) {
        if (viewController.navigationController) {
            return viewController.navigationController;
        }
    } else if ( TBNavigationTypeDismiss == type) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f ){
            return viewController.parentViewController;
        } else {
            return viewController.presentingViewController;
        }
    } else if (TBNavigationTypePresent == type) {
        return viewController;
    }
    return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Shortcuts

UIViewController * getControllerofSource(id source) {
    UIViewController* targetController = nil;
    if ([source isKindOfClass:[UIView class]]) {
        UIView* targetView = (UIView *)source;
        targetController = [targetView viewController];
    } else if ([source isKindOfClass:[UIViewController class]]) {
        targetController = (UIViewController *)source;
    }
    return targetController;
}


BOOL TBOpenURLFromView(NSString* urlPath, UIView* view) {
    return TBOpenURLFromTarget(urlPath, view);
}


BOOL TBBackFromView(UIView* view) {
    return TBBackFromTarget(view);
}

BOOL TBOpenURLFromTarget(NSString* urlPath, id target) {
    return TBOpenURLFromSourceAndParams(urlPath, target, nil);
}

BOOL TBOpenURLFromSourceAndParams(NSString* urlPath, id source, NSDictionary* params) {
    return TBOpenURLFromTargetWithNativeParams(urlPath,source,nil,params);
}

BOOL TBOpenURLFromTargetWithNativeParams(NSString* urlPath, id source, NSDictionary* params, NSDictionary *nativeParams) {
    urlPath =  [urlPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    TBURLAction* action = [TBURLAction actionWithURLPath:urlPath sourceController:getControllerofSource(source)];
    action.nativeParams = nativeParams;
    if (![action.nativeParams isKindOfClass:[NSDictionary class]]) {
        action.nativeParams = nil;
    }
    action.extraInfo = params;
    if (![action.extraInfo isKindOfClass:[NSDictionary class]]) {
        action.extraInfo = nil;
    }
    return [[KSNavigator navigator] openURLAction:action];
}

BOOL TBBackFromTarget(id source) {
    UIViewController* targetController = getControllerofSource(source);
    TBURLAction* action = [TBURLAction actionWithURLPath:nil sourceController:targetController];
    return [[KSNavigator navigator] backURLAction:action];
}

BOOL TBShowMenuFromSource(id source, id sender) {
    UIViewController* targetController = getControllerofSource(source);
    return [[KSNavigator navigator] openMenuFromSource:targetController sender:sender];
}

