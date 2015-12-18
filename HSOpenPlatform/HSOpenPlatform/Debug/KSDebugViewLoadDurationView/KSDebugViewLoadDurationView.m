//
//  KSDebugViewLoadDurationView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/11.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugViewLoadDurationView.h"
#import "KSDebugOperationView.h"
#import "KSDebugViewLoadModel.h"
#import "KSDebugUtils.h"
#import <objc/runtime.h>

static char KSDebug_ViewLoadDurationViewKey;
static char KSDebug_ViewLoadModelKey;

@interface UIViewController (KSDebug_ViewLoadDuration)

- (instancetype)KSDebug_ViewLoadDuration_InitWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil;

- (nullable instancetype)KSDebug_ViewLoadDuration_InitWithCoder:(NSCoder *)aDecoder;

-(void)KSDebug_ViewLoadDuration_ViewDidLoad;

- (void)KSDebug_ViewLoadDuration_ViewWillAppear:(BOOL)animate;

-(void)setks_debug_viewLoadDurationView:(KSDebugViewLoadDurationView *)viewLoadDurationView;

-(KSDebugViewLoadDurationView*)ks_debug_viewLoadDurationView;

-(void)setks_debug_viewLoadModel:(KSDebugViewLoadModel*)viewLoadModel;

-(KSDebugViewLoadModel *)ks_debug_viewLoadModel;



@end

@implementation UIViewController (KSDebug_ViewLoadDuration)

- (instancetype)KSDebug_ViewLoadDuration_InitWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil{
    [self KSDebug_ViewLoadDuration_InitWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    KSDebugViewLoadDurationView *viewLoadDurationView = [self ks_debug_viewLoadDurationView];
    
    if (viewLoadDurationView) {
        KSDebugViewLoadModel *model = [[KSDebugViewLoadModel alloc]init];
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        model.vcInitTime = localeDate;
        model.vcName = NSStringFromClass([self class]);
        
        [self setks_debug_viewLoadModel:model];

    }
    return self;
    
}

- (nullable instancetype)KSDebug_ViewLoadDuration_InitWithCoder:(NSCoder *)aDecoder{
    [self KSDebug_ViewLoadDuration_InitWithCoder:aDecoder];
    
    KSDebugViewLoadDurationView *viewLoadDurationView = [self ks_debug_viewLoadDurationView];
    
    if (viewLoadDurationView) {
        KSDebugViewLoadModel *model = [[KSDebugViewLoadModel alloc]init];
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        model.vcInitTime = localeDate;
        model.vcName = NSStringFromClass([self class]);
        
        [self setks_debug_viewLoadModel:model];
        
    }
    return self;
    
}

-(void)KSDebug_ViewLoadDuration_ViewDidLoad{
    KSDebugViewLoadDurationView *viewLoadDurationView = [self ks_debug_viewLoadDurationView];
    if (viewLoadDurationView) {
        KSDebugViewLoadModel *model = [self ks_debug_viewLoadModel];
        NSDate* currentDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: currentDate];
        NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
        model.viewDidLoadTime = localeDate;
    }
    [self KSDebug_ViewLoadDuration_ViewDidLoad];
}

- (void)KSDebug_ViewLoadDuration_ViewWillAppear:(BOOL)animate{
    [self KSDebug_ViewLoadDuration_ViewWillAppear:animate];
    KSDebugViewLoadDurationView *viewLoadDurationView = [self ks_debug_viewLoadDurationView];
    KSDebugViewLoadModel *model = [self ks_debug_viewLoadModel];
    if (viewLoadDurationView && model && model.timeSpent == 0) {
        model.timeSpent = [model.viewDidLoadTime timeIntervalSinceDate:model.vcInitTime];
    }
    viewLoadDurationView.viewLoadDurationLabel.text = [NSString stringWithFormat:@"%@\n%@ start initialisation\n%@ view did load\n%fs spent",model.vcName,model.vcInitTime,model.viewDidLoadTime,model.timeSpent];

}


-(void)setks_debug_viewLoadDurationView:(KSDebugViewLoadDurationView *)viewLoadDurationView{
    objc_setAssociatedObject(self, &KSDebug_ViewLoadDurationViewKey, viewLoadDurationView, OBJC_ASSOCIATION_ASSIGN);
}


-(KSDebugViewLoadDurationView*)ks_debug_viewLoadDurationView{
    KSDebugViewLoadDurationView *ks_debug_viewLoadDurationView  = objc_getAssociatedObject(self, &KSDebug_ViewLoadDurationViewKey);
    if (ks_debug_viewLoadDurationView == nil) {
        ks_debug_viewLoadDurationView = [KSDebugViewLoadDurationView shareViewLoadDuration];
    }
    return ks_debug_viewLoadDurationView;
}

-(void)setks_debug_viewLoadModel:(KSDebugViewLoadModel*)viewLoadModel{
    objc_setAssociatedObject(self, &KSDebug_ViewLoadModelKey, viewLoadModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KSDebugViewLoadModel *)ks_debug_viewLoadModel{
    return objc_getAssociatedObject(self, &KSDebug_ViewLoadModelKey);
}



@end


@interface KSDebugViewLoadDurationView ()

@end

@implementation KSDebugViewLoadDurationView

+(void)load{
    NSMutableArray* array = [KSDebugOperationView getDebugViews];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"页面加载时长",@"title",NSStringFromClass([self class]),@"className", nil]];
}

+(void)initialize{
    [self configTouch];
}

+(void)configTouch{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ks_debug_swizzleSelector([UIViewController class], @selector(initWithNibName:bundle:), @selector(KSDebug_ViewLoadDuration_InitWithNibName:bundle:));
        
        ks_debug_swizzleSelector([UIViewController class], @selector(initWithCoder:), @selector(KSDebug_ViewLoadDuration_InitWithCoder:));
        
        ks_debug_swizzleSelector([UIViewController class], @selector(viewWillAppear:), @selector(KSDebug_ViewLoadDuration_ViewWillAppear:));
        
        ks_debug_swizzleSelector([UIViewController class], @selector(viewDidLoad), @selector(KSDebug_ViewLoadDuration_ViewDidLoad));
    });
}

static __weak KSDebugViewLoadDurationView* viewLoadDurationView = nil;

+(KSDebugViewLoadDurationView*)shareViewLoadDuration{
    return viewLoadDurationView;
}



+(void)setShareViewLoadDuration:(KSDebugViewLoadDurationView*)shareViewLoadDuration{
    viewLoadDurationView = shareViewLoadDuration;
}


-(void)setupView{
    [super setupView];
    
    self.needCancelBackgroundAction = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;

    _viewLoadDurations = [NSMutableArray array];
    [KSDebugViewLoadDurationView setShareViewLoadDuration:self];
    [self addNotification];

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
    self.hidden = NO;
    [self.debugViewReference addSubview:self];
    [self.viewLoadDurationLabel setHidden:NO];


}

-(void)endDebug{
    [super endDebug];
    self.hidden = YES;
    [self removeFromSuperview];

}

-(UILabel *)viewLoadDurationLabel{
    if (!_viewLoadDurationLabel) {
        _viewLoadDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width - 50, 90)];
        _viewLoadDurationLabel.layer.cornerRadius = 5;
        _viewLoadDurationLabel.clipsToBounds = YES;
        _viewLoadDurationLabel.userInteractionEnabled = NO;
        [_viewLoadDurationLabel setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.4)];
        _viewLoadDurationLabel.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
        _viewLoadDurationLabel.textColor = [UIColor whiteColor];
        _viewLoadDurationLabel.layer.borderWidth = 1;
        [_viewLoadDurationLabel setFont:[UIFont systemFontOfSize:15]];
        _viewLoadDurationLabel.numberOfLines = 0;
        [self addSubview:_viewLoadDurationLabel];
    }
    return _viewLoadDurationLabel;
}


-(void)dealloc{
    [self removeNotification];
    [KSDebugViewLoadDurationView setShareViewLoadDuration:nil];
    
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
