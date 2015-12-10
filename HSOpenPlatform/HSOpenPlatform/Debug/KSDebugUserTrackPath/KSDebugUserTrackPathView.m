//
//  KSDebugUserTrackPathView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/7.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugUserTrackPathView.h"
#import "KSDebugUtils.h"
#import <objc/runtime.h>

static char KSDebug_UserTrackPathViewKey;
static char KSDebug_UserTrackStayTimeKey;

@interface UIViewController (KSDebug_ViewDidAppear)

-(void)KSDebug_ViewDidAppear:(BOOL)animated;

-(void)KSDebug_ViewDidDisappear:(BOOL)animated;

-(void)setks_debug_userTrackPathView:(KSDebugUserTrackPathView*)userTrackPathView;

-(KSDebugUserTrackPathView*)ks_debug_userTrackPathView;

-(void)setks_debug_userTrackStayTime:(NSDate*)userTrackStayTime;

-(NSDate*)ks_debug_userTrackStayTime;

@end

@implementation UIViewController (KSDebug_ViewDidAppear)

-(void)KSDebug_ViewDidAppear:(BOOL)animated{
    [self KSDebug_ViewDidAppear:animated];
    KSDebugUserTrackPathView* userTrackPathView = [self ks_debug_userTrackPathView];
    if (userTrackPathView && [userTrackPathView userTrackPaths]) {
        NSDate* currentData = [NSDate date];
        [self setks_debug_userTrackStayTime:currentData];
        [[userTrackPathView userTrackPaths] addObject:[NSString stringWithFormat:@"%lu、%@时，移入到 %@",[[userTrackPathView userTrackPaths] count], currentData, NSStringFromClass([self class])]];
        [userTrackPathView trimUserTrackPaths];
    }
}

-(void)KSDebug_ViewDidDisappear:(BOOL)animated{
    [self KSDebug_ViewDidDisappear:animated];
    KSDebugUserTrackPathView* userTrackPathView = [self ks_debug_userTrackPathView];
    if (userTrackPathView && [userTrackPathView userTrackPaths]) {
        NSDate* viewAppearDate = [self ks_debug_userTrackStayTime];
        NSTimeInterval timerBucket = [[NSDate date] timeIntervalSinceDate:viewAppearDate];
        [[userTrackPathView userTrackPaths] addObject:[NSString stringWithFormat:@"%lu、从 %@ 移出，总停留时间为：%f",[[userTrackPathView userTrackPaths] count], NSStringFromClass([self class]), timerBucket]];
        [userTrackPathView trimUserTrackPaths];
    }
}

-(void)setks_debug_userTrackPathView:(KSDebugUserTrackPathView*)userTrackPathView{
    objc_setAssociatedObject(self, &KSDebug_UserTrackPathViewKey, userTrackPathView, OBJC_ASSOCIATION_ASSIGN);
}

-(KSDebugUserTrackPathView*)ks_debug_userTrackPathView{
    KSDebugUserTrackPathView* ks_debug_userTrackPathView = objc_getAssociatedObject(self, &KSDebug_UserTrackPathViewKey);
    if (ks_debug_userTrackPathView == nil) {
        ks_debug_userTrackPathView = [KSDebugUserTrackPathView shareUserTrackPath];
    }
    return ks_debug_userTrackPathView;
}

-(void)setks_debug_userTrackStayTime:(NSDate*)userTrackStayTime{
    objc_setAssociatedObject(self, &KSDebug_UserTrackStayTimeKey, userTrackStayTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDate*)ks_debug_userTrackStayTime{
    return objc_getAssociatedObject(self, &KSDebug_UserTrackStayTimeKey);
}

@end

@interface KSDebugUserTrackPathView()

@end

@implementation KSDebugUserTrackPathView

#ifdef KSDebugToolsEnable
+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"用户轨迹",@"title",NSStringFromClass([self class]), @"className", nil]];
}
#endif

+(void)initialize{
    [self configTouch];
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidAppear:), @selector(KSDebug_ViewDidAppear:));
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidDisappear:), @selector(KSDebug_ViewDidDisappear:));
    });
}

static __weak KSDebugUserTrackPathView* userTrackPathView = nil;

+(KSDebugUserTrackPathView*)shareUserTrackPath{
    return userTrackPathView;
}

+(void)setShareUserTrackPath:(KSDebugUserTrackPathView*)shareUserTrackPath{
    userTrackPathView = shareUserTrackPath;
}


-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"用户轨迹"];
    [self.debugTextView setFont:[UIFont boldSystemFontOfSize:15]];
    _userTrackPaths = [[KSDebugUserTrackPathArrayClass alloc] init];
    [KSDebugUserTrackPathView setShareUserTrackPath:self];
    [self addNotification];
    [self setupExceptionHandler];
}

static NSUncaughtExceptionHandler* exceptionHandler = NULL;

-(void)setupExceptionHandler{
    exceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&KSDebug_uncaughtExceptionHandler);
}

-(void)resetExceptionHandler{
    if (exceptionHandler) {
        NSSetUncaughtExceptionHandler(exceptionHandler);
    }else{
        NSSetUncaughtExceptionHandler(NULL);
    }
}

void KSDebug_uncaughtExceptionHandler(NSException *exception){
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString* arrStr = nil;
    if (arr) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        arrStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@", name, reason, arrStr?:[arr componentsJoinedByString:@"\n"]];
    if (url) {
        [[[KSDebugUserTrackPathView shareUserTrackPath] userTrackPaths] addObject:url];
    }
    [[KSDebugUserTrackPathView shareUserTrackPath] saveKSDebugUserTrackPaths];

    if (exceptionHandler) {
        exceptionHandler(exception);
    }
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)startDebug{
    [super startDebug];
    self.debugTextView.text = [self generateStringWithDebugUserTrackPathArray:self.userTrackPaths];
}

-(void)endDebug{
    [super endDebug];
}

-(void)trimUserTrackPaths{
    // 主线程做清理操作
    if (self.userTrackPaths && [self.userTrackPaths count] >= KSDebug_UserTrackPaths_MaxCount) {
        if ([NSThread isMainThread]) {
            [self saveKSDebugUserTrackPaths];
            [self.userTrackPaths removeAllObjects];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveKSDebugUserTrackPaths];
                [self.userTrackPaths removeAllObjects];
            });
        }
    }
}

-(void)saveKSDebugUserTrackPaths{
    if (self.userTrackPaths) {
        [self saveArrayToKSDebugDiskWithDebugUserTrackPathArray:self.userTrackPaths keyPath:[NSString stringWithFormat:@"%@_%@",KSDebug_UserTrackPaths_Key,[NSDate date]]];
    }
}

-(NSString*)generateStringWithDebugUserTrackPathArray:(KSDebugUserTrackPathArrayClass*)array{
    if ([array isKindOfClass:[NSArray class]]) {
        return [self generateStringWithArray:(NSArray*)array];
    }else if ([array respondsToSelector:@selector(enumerateObjectsUsingBlock:)]){
        NSMutableArray* mutableArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                [mutableArray addObject:obj];
            }
        }];
        return [self generateStringWithArray:mutableArray];
    }
    return nil;
}

-(void)saveArrayToKSDebugDiskWithDebugUserTrackPathArray:(KSDebugUserTrackPathArrayClass*)array keyPath:(NSString*)path{
    if ([array isKindOfClass:[NSArray class]]) {
        [self saveArrayToKSDebugDiskWithArray:(NSArray*)array keyPath:path];
        return;
    }else if ([array respondsToSelector:@selector(enumerateObjectsUsingBlock:)]){
        NSMutableArray* mutableArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                [mutableArray addObject:obj];
            }
        }];
        [self saveArrayToKSDebugDiskWithArray:mutableArray keyPath:path];
    }
}

-(void)dealloc{
    [self removeNotification];
    [KSDebugUserTrackPathView setShareUserTrackPath:nil];
//    [self saveKSDebugUserTrackPaths];
    [self resetExceptionHandler];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)applicationWillTerminate:(NSNotification*)notification{
//    [self saveKSDebugUserTrackPaths];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)applicationDidEnterBackground:(NSNotification*)notification{
//    [self saveKSDebugUserTrackPaths];
}

@end