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
#import <objc/message.h>

static char KSDebug_UserTrackPathViewKey;
static char KSDebug_UserTrackStayTimeKey;
static char KSDebug_ControlSelectorKey;

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
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        currentDate = [currentDate  dateByAddingTimeInterval: interval];
        [self setks_debug_userTrackStayTime:currentDate];
        [[userTrackPathView userTrackPaths] addObject:[NSString stringWithFormat:@"%lu.at %@ time, move in %@",[[userTrackPathView userTrackPaths] count], currentDate, NSStringFromClass([self class])]];
        [userTrackPathView trimUserTrackPaths];
    }
}

-(void)KSDebug_ViewDidDisappear:(BOOL)animated{
    [self KSDebug_ViewDidDisappear:animated];
    KSDebugUserTrackPathView* userTrackPathView = [self ks_debug_userTrackPathView];
    if (userTrackPathView && [userTrackPathView userTrackPaths]) {
        NSDate* viewAppearDate = [self ks_debug_userTrackStayTime];
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        currentDate = [currentDate  dateByAddingTimeInterval: interval];
        NSTimeInterval timerBucket = [currentDate timeIntervalSinceDate:viewAppearDate];
        [[userTrackPathView userTrackPaths] addObject:[NSString stringWithFormat:@"%lu.from %@ move out,totle time is:%f",[[userTrackPathView userTrackPaths] count], NSStringFromClass([self class]), timerBucket]];
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

@interface UIControl (KSDebug_EndTrackingTouch)

- (void)KSAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)KSEndTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)KSDebugActionSelectorWithTarget:(id)target sender:(id)sender;

- (void)setks_debug_controlSelector:(NSString*)selector;

- (NSString*)ks_debug_controlSelector;

@end

@implementation UIButton (KSDebug_EndTrackingTouch)

- (void)KSAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self KSAddTarget:target action:action forControlEvents:controlEvents];
    NSString* className = NSStringFromClass([target class]);
    if (![className hasPrefix:@"KSDebug"]) {
        [self setks_debug_controlSelector:NSStringFromSelector(action)];
    }
}

- (void)KSEndTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self KSEndTrackingWithTouch:touch withEvent:event];
    NSSet* sets = [self allTargets];
    id target = [sets anyObject];
    [self KSDebugActionSelectorWithTarget:target sender:self];
}

-(void)KSDebugActionSelectorWithTarget:(id)target sender:(id)sender{
    if (sender == self && [self ks_debug_controlSelector]) {
        KSDebugUserTrackPathView* ks_debug_userTrackPathView = [KSDebugUserTrackPathView shareUserTrackPath];
        if (ks_debug_userTrackPathView) {
            NSDate* currentDate = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: currentDate];
            currentDate = [currentDate  dateByAddingTimeInterval: interval];
            [[ks_debug_userTrackPathView userTrackPaths] addObject:[NSString stringWithFormat:@"%lu.button is clickedd at %@ time, on '%@' with selector: '%@'",[[ks_debug_userTrackPathView userTrackPaths] count], currentDate, NSStringFromClass([self class]), [self ks_debug_controlSelector]]];
            [ks_debug_userTrackPathView trimUserTrackPaths];
        }
    }
}

-(void)setks_debug_controlSelector:(NSString*)selector{
    objc_setAssociatedObject(self, &KSDebug_ControlSelectorKey, selector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)ks_debug_controlSelector{
    return objc_getAssociatedObject(self, &KSDebug_ControlSelectorKey);
}

- (SEL)swizzledSelectorForSelector:(SEL)selector;
{
    return NSSelectorFromString([NSString stringWithFormat:@"_ks_debug_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

@end

@interface KSDebugUserTrackPathView()

@end

@implementation KSDebugUserTrackPathView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"用户轨迹",@"title",NSStringFromClass([self class]), @"className", nil]];
}

+(void)initialize{
    [self configTouch];
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidAppear:), @selector(KSDebug_ViewDidAppear:));
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidDisappear:), @selector(KSDebug_ViewDidDisappear:));
        ks_debug_swizzleSelector([UIButton class], @selector(addTarget:action:forControlEvents:), @selector(KSAddTarget:action:forControlEvents:));
        ks_debug_swizzleSelector([UIButton class], @selector(endTrackingWithTouch:withEvent:), @selector(KSEndTrackingWithTouch:withEvent:));
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
    _userTrackPaths = [NSMutableArray array];
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
    self.debugTextView.text = [self generateStringWithArray:self.userTrackPaths];
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
        [self saveArrayToKSDebugDiskWithArray:self.userTrackPaths keyPath:[NSString stringWithFormat:@"%@_%@",KSDebug_UserTrackPaths_Key,[NSDate date]]];
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