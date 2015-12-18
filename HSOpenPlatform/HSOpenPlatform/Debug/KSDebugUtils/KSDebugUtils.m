//
//  KSDebugUtils.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugUtils.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   钩子函数 swizzleSelector 将两个函数方法对调，其中对于同一个方法而言，先执行对调的方法先执行，后执行对调的方法后执行
void ks_debug_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation KSDebugUtils

+ (void)injectSwizzledSelector:(SEL)swizzledSelector withSelector:(SEL)selector withUndefinedBlock:(void (^)(id slf, id sender, id paramOne, id paramTwo, id paramThree))undefinedBlock withImplementationBlock:(void (^)(id slf, id sender, id paramOne, id paramTwo, id paramThree))implementationBlock intoTargetClass:(Class)cls{
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

/// All swizzled delegate methods should make use of this guard.
/// This will prevent duplicated sniffing when the original implementation calls up to a superclass implementation which we've also swizzled.
/// The superclass implementation (and implementations in classes above that) will be executed without inteference if called from the original implementation.
+ (void)sniffWithoutDuplicationForObject:(NSObject *)object selector:(SEL)selector sniffingBlock:(void (^)(void))sniffingBlock originalImplementationBlock:(void (^)(void))originalImplementationBlock
{
    const void *key = selector;
    
    // Don't run the sniffing block if we're inside a nested call
    if (!objc_getAssociatedObject(object, key)) {
        sniffingBlock();
    }
    
    // Mark that we're calling through to the original so we can detect nested calls
    objc_setAssociatedObject(object, key, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    originalImplementationBlock();
    objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
{
    if ([cls instancesRespondToSelector:selector]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selector == methodSelector) {
                implementsSelector = YES;
                break;
            }
        }
        
        free(methods);
        
        if (!implementsSelector) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;
{
    if ([self instanceRespondsButDoesNotImplementSelector:selector class:cls]) {
        return;
    }
    
#ifdef __IPHONE_6_0
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#else
    IMP implementation = imp_implementationWithBlock((__bridge void *)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#endif
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, method_getTypeEncoding(oldMethod));
        
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, method_getTypeEncoding(oldMethod));
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 当前展示的viewController
+ (UIViewController*)getCurrentAppearedViewController{
    UIView* leafView = [self getLeafSubView];
    
    UIViewController* currentAppearedViewController = [self getViewController:leafView];

    UIViewController* lastVC = [self getLastViewControllerFromCurrentNavigationVC:currentAppearedViewController];
    
    if (lastVC == nil || lastVC == currentAppearedViewController) {
        return currentAppearedViewController;
    }
    
    return lastVC;
}

+ (UIViewController*)getCurrentAppearedViewController:(UIView*)view {
    UIView* leafView = [self getLeafSubViewFromView:view];
    
    UIViewController* currentAppearedViewController = [self getViewController:leafView];
    
    UIViewController* lastVC = [self getLastViewControllerFromCurrentNavigationVC:currentAppearedViewController];
    
    if (lastVC == nil || lastVC == currentAppearedViewController) {
        return currentAppearedViewController;
    }
    return lastVC;
}

+(UIViewController*)getLastViewControllerFromCurrentNavigationVC:(UIViewController*)currentAppearedViewController{
    UIViewController* lastVC = nil;

    if (currentAppearedViewController.navigationController) {
       lastVC = [[currentAppearedViewController.navigationController viewControllers] count] > 1 ? [[currentAppearedViewController.navigationController viewControllers] lastObject] : nil;
    }
    if (lastVC) {
        return lastVC;
    }
    UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (rootViewController && [rootViewController isKindOfClass:[UINavigationController class]]) {
        lastVC = [[((UINavigationController*)rootViewController) viewControllers] count] > 1 ? [[((UINavigationController*)rootViewController) viewControllers] lastObject] : nil;
    }else if (rootViewController && rootViewController.navigationController){
        lastVC = [[((UINavigationController*)rootViewController.navigationController) viewControllers] count] > 1 ? [[((UINavigationController*)rootViewController.navigationController) viewControllers] lastObject] : nil;
    }
    
    return lastVC;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 所有的父view列表，包括其自身
+(NSArray*)getAllSuperViewArrayWithView:(UIView*)view{
    NSMutableArray* array = [NSMutableArray array];
    if (view == nil) {
        return array;
    }
    if (![view isKindOfClass:NSClassFromString(@"KSDebugPropertyButton")]) {
        [array addObject:view];
    }
    for (UIView* next = view; next; next = next.superview) {
        if ([next isKindOfClass:[UIView class]]
            && ![next isKindOfClass:NSClassFromString(@"KSDebugPropertyButton")]
            && ![next isKindOfClass:[UIWindow class]]) {
            [array addObject:next];
        }
    }
    return array;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 最深叶子节点
+ (UIView*)getLeafSubView{
    return [self getLeafSubViewFromView:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}

+ (UIView*)getLeafSubViewFromView:(UIView*)view{
    if (view == nil) {
        return nil;
    }
    NSUInteger depth = 0;
    UIView* maxDepthSubview = [self getMaxDepthSubviewWithView:view depth:&depth];
    return maxDepthSubview;
    /*
    if (view.subviews && [view.subviews count] > 0) {
        UIView * subview = [view.subviews firstObject];
        return [self getLeafSubViewFromView:subview];
    }
    return view;
     */
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 view对应的viewController
+ (UIViewController*)getViewController:(UIView*)view {
    for (UIView* next = view; next; next = next.superview) {
        if ([next.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next.nextResponder;
        }
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 最大深度路劲 方法
+(NSMutableArray*)getMaxDepthSubviewPathWithView:(UIView*)view{
    NSMutableArray* depthPath = [NSMutableArray array];
    NSUInteger depth = 0;
    UIView* maxDepthSubview = [self getMaxDepthSubviewWithView:view depth:&depth];
    [self getMaxDepthSubviewPathWithMaxDepthSubview:maxDepthSubview ancestorView:view depthPath:depthPath];
    return depthPath;
}

+(UIView*)getMaxDepthSubviewWithView:(UIView*)view depth:(NSUInteger*)depth{
    if (view == nil) {
        return nil;
    }
    if (view.subviews == nil || [view.subviews count] == 0) {
        return view;
    }
    UIView* maxDepthSubview = view;
    NSUInteger maxSubDepth = 0;
    for (UIView* subView in view.subviews) {
        NSUInteger subDepth = *depth + 1;
        UIView* subDepthSubview = view;
        subDepthSubview = [self getMaxDepthSubviewWithView:subView depth:&subDepth];
        if (subDepth > maxSubDepth) {
            maxSubDepth = subDepth;
            maxDepthSubview = subDepthSubview;
        }
    }
    *depth = maxSubDepth;
    return maxDepthSubview;
}

+(void)getMaxDepthSubviewPathWithMaxDepthSubview:(UIView*)maxDepthSubview ancestorView:(UIView*)ancestorView depthPath:(NSMutableArray*)depthPath{
    if (maxDepthSubview == nil) {
        return;
    }
    if (maxDepthSubview == ancestorView) {
        return;
    }
    if (maxDepthSubview.superview) {
        NSInteger index = [maxDepthSubview.superview.subviews indexOfObject:maxDepthSubview];
        if (index != NSNotFound) {
            [depthPath addObject:@(index)];
            [self getMaxDepthSubviewPathWithMaxDepthSubview:maxDepthSubview.superview ancestorView:ancestorView depthPath:depthPath];
        }else{
            return;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 instance变量的属性名称及属性变量
+(NSMutableDictionary*)getInstansePropertyWithInstanse:(id)instanse{
    if (instanse == nil) {
        return nil;
    }
    unsigned int numIvars = 0;
    NSString *key = nil;
    id value = nil;
    NSMutableDictionary* propertyDict = [NSMutableDictionary dictionary];
    Ivar * ivars = class_copyIvarList([instanse class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        /*
         * object_getIvar获取时如果不是对象类型会crash
         */
        /*
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
         
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
         
        value = object_getIvar(instanse, thisIvar);
         */

        const char *charString = ivar_getName(thisIvar);
        
        if (charString != NULL) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        }
        if (key) {
            value = [instanse valueForKey:key];
        }
        
        if(key && value){
            [propertyDict setObject:value forKey:key];
        }
    }
    free(ivars);
    
    if ([instanse respondsToSelector:NSSelectorFromString(@"sd_imageURL")]) {
        id instanseImageUrl = [instanse performSelector:NSSelectorFromString(@"sd_imageURL") withObject:nil];
        if (instanseImageUrl && [instanseImageUrl isKindOfClass:[NSString class]]) {
            [propertyDict setObject:instanseImageUrl forKey:@"sd_imageURL"];
        }else if (instanseImageUrl && [instanseImageUrl isKindOfClass:[NSURL class]]){
            [propertyDict setObject:((NSURL*)instanseImageUrl).absoluteString forKey:@"sd_imageURL"];
        }else if (instanseImageUrl){
            [propertyDict setObject:instanseImageUrl forKey:@"sd_imageURL"];
        }
    }
    
    return propertyDict;
}

@end
