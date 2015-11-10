//
//  KSTouchEvent.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/20.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSTouchEvent.h"
#import "UIButton+KSTouchEvent.h"
#import <objc/runtime.h>

@implementation KSTouchEvent

static BOOL _needTouchEventLog = NO;
static BOOL _needTouchEvent    = NO;

static inline void eh_touch_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eh_touch_swizzleSelector([UITableViewCell class], @selector(setSelected:animated:), @selector(KSSetSelected:animated:));
        eh_touch_swizzleSelector([UICollectionViewCell class], @selector(setSelected:), @selector(KSSetSelected:));
        eh_touch_swizzleSelector([UIGestureRecognizer class], @selector(_updateGestureWithEvent:buttonEvent:), @selector(KSUpdateGestureWithEvent:buttonEvent:));
        [self setNeedTouchEventLog:NO];
        [self setNeedTouchEvent:YES];
    });
}

+(void)setNeedTouchEventLog:(BOOL)needTouchEventLog{
    _needTouchEventLog = needTouchEventLog;
}

+(void)setNeedTouchEvent:(BOOL)needTouchEvent{
    _needTouchEvent = needTouchEvent;
}

+(void)touchWithView:(UIView*)view{
    if (view == nil) {
        return;
    }
    [self touchWithView:view eventAttributes:view.ks_eventAttributes];
}

+(void)touchWithView:(UIView*)view eventAttributes:(NSDictionary*)eventAttributes{
    if (view == nil) {
        return;
    }
    if (!_needTouchEvent) {
        return;
    }
    if (view.ks_notNeedEventLog) {
        return;
    }
    NSDate* currentDate = [NSDate date];
    NSString* instanseName = nil;
    NSString* actionForTarget = nil;
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl* control = (UIControl*)view;
        NSSet* sets = [control allTargets];
        id target = [sets anyObject];
        if (target) {
            instanseName = [self getInstanseNameWithInstanse:view target:target];
            NSArray* actions = [control actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            if ([actions count] > 0) {
                actionForTarget = [actions firstObject];
            }
        }
    }
    NSMutableDictionary* mutableEventAttributes = eventAttributes ? [eventAttributes mutableCopy] : [NSMutableDictionary dictionary];
    if (instanseName) {
        [mutableEventAttributes setObject:instanseName forKey:@"instanseName"];
    }
    if (actionForTarget) {
        [mutableEventAttributes setObject:actionForTarget forKey:@"actionForTarget"];
    }
    NSString* vcName = view.viewController ? NSStringFromClass([view.viewController class]) : @"UIViewController";
    NSString* viewName = NSStringFromClass([view class]);
    NSString* eventName = view.ks_eventName?:(actionForTarget?:@"touch");
    if (_needTouchEventLog) {
        EHLogInfo(@"\n ----> touch in %@, eventName is %@,\nit's viewController name is %@, at time %@ \n eventAttributes:  %@" ,viewName, eventName,vcName, currentDate, mutableEventAttributes);
    }
    if (viewName) {
        [mutableEventAttributes setObject:viewName forKey:@"clicedViewClass"];
    }
    if (vcName) {
        [mutableEventAttributes setObject:vcName forKey:@"clicedViewControllerName"];
    }
    if (eventName) {
        [mutableEventAttributes setObject:eventName forKey:@"eventName"];
    }
    [MobClick event:[NSString stringWithFormat:@"auto_data_trace_clicked"] attributes:mutableEventAttributes];
}

+(NSString*)getInstanseNameWithInstanse:(id)instanse target:(id)target{
    if (target == nil || instanse == nil) {
        return nil;
    }
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([target class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(target, thisIvar) == instanse)) {
            const char *charString = ivar_getName(thisIvar);
            if (charString != NULL) {
                key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            }
            break;
        }
    }
    free(ivars);
    return key;
}

+ (void)event:(NSString *)eventId{
    [MobClick event:eventId];
}


+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    [MobClick event:eventId attributes:attributes];
}


+ (void)beginLogPageView:(NSString *)pageName{
    [MobClick beginLogPageView:pageName];
}

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)endLogPageView:(NSString *)pageName{
    [MobClick endLogPageView:pageName];
}

#pragma mark - user methods
/** active user sign-in.
 使用sign-In函数后，如果结束该PUID的统计，需要调用sign-Off函数
 @param puid : user's ID
 @param provider : 不能以下划线"_"开头，使用大写字母和数字标识; 如果是上市公司，建议使用股票代码。
 @return void.
 */
+ (void)profileSignInWithPUID:(NSString *)puid{
    if (puid) {
        [MobClick profileSignInWithPUID:puid];
    }
}

+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider{
    if (puid && provider) {
        [MobClick profileSignInWithPUID:puid provider:provider];
    }
}

/** active user sign-off.
 停止sign-in PUID的统计
 @return void.
 */
+ (void)profileSignOff{
    [MobClick profileSignOff];
}

@end
