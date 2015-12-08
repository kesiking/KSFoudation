//
//  KSDebugUtils.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugUtils.h"
#import <objc/runtime.h>

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -   获取 当前展示的viewController
+ (UIViewController*)getCurrentAppearedViewController{
    UIView* leafView = [self getLeafSubView];
    return [self getViewController:leafView];
}

+ (UIViewController*)getCurrentAppearedViewController:(UIView*)view {
    UIView* leafView = [self getLeafSubViewFromView:view];
    return [self getViewController:leafView];
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
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        const char *charString = ivar_getName(thisIvar);
        
        if (charString != NULL) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        }
        
        value = object_getIvar(instanse, thisIvar);
        
        if(key && value){
            [propertyDict setObject:value forKey:key];
        }
    }
    free(ivars);
    
    return propertyDict;
}

@end
