//
//  KSDebugViewAppearDurationView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/8.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugViewAppearDurationView.h"
#import "KSDebugUtils.h"
#import <objc/runtime.h>

static char KSDebug_ViewAppareDurationViewKey;
static char KSDebug_ViewAppearDurationKey;


@interface UIViewController (KSDebug_ViewAppearDuration)

- (instancetype)KSDebug_InitWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil;

- (nullable instancetype)KSDebug_InitWithCoder:(NSCoder *)aDecoder;

-(void)KSDebug_ViewDidAppearDuration:(BOOL)animated;

-(void)setks_debug_viewAppearDurationView:(KSDebugViewAppearDurationView *)viewAppearDurationView;

-(KSDebugViewAppearDurationView *)ks_debug_viewAppearDurationView;

//-(void)setks_debug_viewAppearDuration:(NSDate*)viewAppearDuration;
//
//-(NSDate*)ks_debug_viewAppearDuration;

-(void)setks_debug_vcInitDate:(NSDate*)vcInitDate;

-(NSDate*)ks_debug_vcInitDate;

    
@end


@implementation UIViewController (KSDebug_ViewAppearDuration)


- (instancetype)KSDebug_InitWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    [self KSDebug_InitWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    KSDebugViewAppearDurationView *viewAppearDurationView = [self ks_debug_viewAppearDurationView];
    
    if (viewAppearDurationView && [viewAppearDurationView viewAppearDurations]) {
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        [self setks_debug_vcInitDate:localeDate];
        [[viewAppearDurationView viewAppearDurations] addObject:[NSString stringWithFormat:@"%lu、%@时，%@开始初始化",[[viewAppearDurationView viewAppearDurations] count],currentDate,NSStringFromClass([self class])]];
        [viewAppearDurationView trimUserTrackPaths];

    }
    return self;
    
}

- (nullable instancetype)KSDebug_InitWithCoder:(NSCoder *)aDecoder{
    [self KSDebug_InitWithCoder:aDecoder];
    
    KSDebugViewAppearDurationView *viewAppearDurationView = [self ks_debug_viewAppearDurationView];
    
    if (viewAppearDurationView && [viewAppearDurationView viewAppearDurations]) {
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        [self setks_debug_vcInitDate:localeDate];
        [[viewAppearDurationView viewAppearDurations] addObject:[NSString stringWithFormat:@"%lu、%@时，%@开始初始化",[[viewAppearDurationView viewAppearDurations] count],currentDate,NSStringFromClass([self class])]];
        [viewAppearDurationView trimUserTrackPaths];

    }
    return self;

}


-(void)KSDebug_ViewDidAppearDuration:(BOOL)animated{
    [self KSDebug_ViewDidAppearDuration:animated];
    KSDebugViewAppearDurationView *viewAppearDurationView = [self ks_debug_viewAppearDurationView];
    if (viewAppearDurationView && [viewAppearDurationView viewAppearDurations]) {
        NSDate *vcInitDate = [self ks_debug_vcInitDate];
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        NSTimeInterval timerBucket = [localeDate timeIntervalSinceDate:vcInitDate];
        [[viewAppearDurationView viewAppearDurations] addObject:[NSString stringWithFormat:@"%lu、%@ 从初始化到页面展现共用时 %f" ,[[viewAppearDurationView viewAppearDurations] count],NSStringFromClass([self class]),timerBucket]];
        [viewAppearDurationView trimUserTrackPaths];
    }
}


-(void)setks_debug_viewAppearDurationView:(KSDebugViewAppearDurationView*)viewAppearDurationView{
    objc_setAssociatedObject(self, &KSDebug_ViewAppareDurationViewKey, viewAppearDurationView, OBJC_ASSOCIATION_ASSIGN);
}

-(KSDebugViewAppearDurationView*)ks_debug_viewAppearDurationView{
    KSDebugViewAppearDurationView* ks_debug_viewAppearDurationView = objc_getAssociatedObject(self, &KSDebug_ViewAppareDurationViewKey);
    if (ks_debug_viewAppearDurationView == nil) {
        ks_debug_viewAppearDurationView = [KSDebugViewAppearDurationView shareViewAppearDuration];
    }
    return ks_debug_viewAppearDurationView;
}



-(void)setks_debug_vcInitDate:(NSDate*)vcInitDate{
    objc_setAssociatedObject(self, &KSDebug_ViewAppearDurationKey, vcInitDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDate*)ks_debug_vcInitDate{
    return objc_getAssociatedObject(self, &KSDebug_ViewAppearDurationKey);
}


@end

@interface KSDebugViewAppearDurationView ()

@end

@implementation KSDebugViewAppearDurationView

//+(void)load{
//    NSMutableArray* array = [KSDebugOperationView getDebugViews];
//    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"页面初始化用时",@"title",NSStringFromClass([self class]), @"className", nil]];
//}

+(void)initialize{
    [self configTouch];
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_debug_swizzleSelector([UIViewController class], @selector(initWithNibName:bundle:), @selector(KSDebug_InitWithNibName:bundle:));
        
        ks_debug_swizzleSelector([UIViewController class], @selector(initWithCoder:), @selector(KSDebug_InitWithCoder:));
        
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidAppear:), @selector(KSDebug_ViewDidAppearDuration:));
    });
}


static __weak KSDebugViewAppearDurationView* viewAppearDurationView = nil;

+(KSDebugViewAppearDurationView*)shareViewAppearDuration{
    return viewAppearDurationView;
}



+(void)setShareViewAppearDuration:(KSDebugViewAppearDurationView*)shareViewAppearDuration{
    viewAppearDurationView = shareViewAppearDuration;
}


-(void)setupView{
    [super setupView];
    [self setTitleInfoText:@"页面初始化时间"];
    [self.debugTextView setFont:[UIFont boldSystemFontOfSize:15]];
    _viewAppearDurations = [NSMutableArray array];
    [KSDebugViewAppearDurationView setShareViewAppearDuration:self];
//    [self setupExceptionHandler];
}

-(void)trimUserTrackPaths{
    // 主线程做清理操作
    if (self.viewAppearDurations && [self.viewAppearDurations count] >= KSDebug_ViewAppearDurations_MaxCount) {
        if ([NSThread isMainThread]) {
            [self saveKSDebugUserTrackPaths];
            [self.viewAppearDurations removeAllObjects];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveKSDebugUserTrackPaths];
                [self.viewAppearDurations removeAllObjects];
            });
        }
    }
}

-(void)saveKSDebugUserTrackPaths{
    if (self.viewAppearDurations) {
        [self saveArrayToKSDebugDiskWithArray:self.viewAppearDurations keyPath:[NSString stringWithFormat:@"%@_%@",KSDebug_ViewAppearDurations_Key,[NSDate date]]];
    }
}



-(void)dealloc{
    [KSDebugViewAppearDurationView setShareViewAppearDuration:nil];
    //    [self saveKSDebugUserTrackPaths];
//    [self resetExceptionHandler];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
