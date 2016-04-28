//
//  HSHomeBannerView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSHomeBannerView.h"
#import "WeAppBasicBannerView.h"
#import "HSActivityInfoModel.h"
#import "HSActivityAdvertisementListService.h"
#import "HSActivityInfoDetailViewController.h"

//#define needCFRunLoopObserverRefObserver

@interface HSHomeBannerView()

@property (nonatomic, strong) WeAppBasicBannerView                  *bannerView;

@property (nonatomic, strong) HSActivityAdvertisementListService    *activityAdvertisementListService;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 观察 method
static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    if (![NSThread isMainThread]) {
        return;
    }
    HSHomeBannerView *homeBannerView = (__bridge HSHomeBannerView *)info;
    if (!homeBannerView.bannerView.bannerCycleScrollView.autoScrollEnabled) {
        [homeBannerView.bannerView setAutoScrollEnabled:YES];
    }
}

@implementation HSHomeBannerView

-(void)setupView{
    [super setupView];
    [self addSubview:self.bannerView];
    [self refreshDataRequest];
    [self reloadData];
#ifdef needCFRunLoopObserverRefObserver
    [self registerTransactionGroupAsMainRunloopObserver:self];
#endif
}

-(void)refreshDataRequest{
    [self.activityAdvertisementListService loadActivityAdvertisementListDataWithUserPhone:[KSAuthenticationCenter userPhone]];
}

-(void)setAutoScrollEnabled:(BOOL)stopScroll{
    [self.bannerView setAutoScrollEnabled:stopScroll];
}

-(void)dealloc{
    _bannerView.delegate = nil;
    _bannerView = nil;
#ifdef needCFRunLoopObserverRefObserver
    [self unrRegisterTransactionGroupAsMainRunloopObserver:self];
#endif
}

-(void)reloadData{
    [self sizeToFit];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 观察 runloop method
static CFRunLoopObserverRef observer;

- (void)registerTransactionGroupAsMainRunloopObserver:(HSHomeBannerView *)homeBannerView
{
    if (![NSThread isMainThread]) {
        return;
    }
    if (observer != NULL) {
        return;
    }
    // defer the commit of the transaction so we can add more during the current runloop iteration
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
                                kCFRunLoopExit); // before exiting a runloop run
    
    CFRunLoopObserverContext context = {
        0,           // version
        (__bridge void *)homeBannerView,  // info
        &CFRetain,   // retain
        &CFRelease,  // release
        NULL         // copyDescription
    };
    
    observer = CFRunLoopObserverCreate(NULL,        // allocator
                                       activities,  // activities
                                       YES,         // repeats
                                       INT_MAX,     // order after CA transaction commits
                                       &_transactionGroupRunLoopObserverCallback,  // callback
                                       &context);   // context
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (void)unrRegisterTransactionGroupAsMainRunloopObserver:(HSHomeBannerView *)homeBannerView{
    if (![NSThread isMainThread]) {
        return;
    }
    if (observer == NULL) {
        return;
    }
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveObserver(runLoop, observer, kCFRunLoopCommonModes);
    observer = NULL;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - bannerView method
-(WeAppBasicBannerView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[WeAppBasicBannerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, home_banner_height)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        [_bannerView.bannerCloseButton removeFromSuperview];
        _bannerView.clipsToBounds = YES;
        _bannerView.bannerBackgroundImage.image = [UIImage imageNamed:@"gz_image_loading.png"];
        _bannerView.delegate = (id)self;
        _bannerView.isRounded = NO;
        _bannerView.bannerCycleScrollView.isPageControlCenter = YES;
        _bannerView.didBannerViewNeedReloadData = ^(NSArray* newData, NSArray* oldData){
            if ([newData count] != [oldData count]) {
                return YES;
            }
            int i = 0;
            for (; i < newData.count; i++) {
                HSActivityInfoModel *newItem = [newData objectAtIndex:i];
                if (![newItem isKindOfClass:[HSActivityInfoModel class]]) {
                    continue;
                }
                id oldItem = [oldData objectAtIndex:i];
                if (![oldItem isKindOfClass:[HSActivityInfoModel class]]) {
                    continue;
                }
                
                if (![((HSActivityInfoModel *)oldItem).activityBanner isEqualToString:newItem.activityBanner]) {
                    break;
                }
            }
            if (i == newData.count) {
                return NO;
            }
            return YES;
        };
        _bannerView.getURLForImageViewForBannerViewBlock =  ^NSString*(WeAppBasicBannerView * bannerView, id obj, NSInteger pageIndex){
            if ([obj isKindOfClass:[HSActivityInfoModel class]]) {
                HSActivityInfoModel* activityInfoModel = (HSActivityInfoModel*)obj;
                return activityInfoModel.activityBanner;
            }
            return nil;
        };
    }
    return _bannerView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - bannerView Delegate
- (void)BannerView:(UIView*)aBannerView didSelectPageWithURL:(NSURL*) url withComponentItem:(id)componentItem atPageIndex:(NSUInteger)pageIndex{
    if (aBannerView == _bannerView) {
        if (componentItem && [componentItem isKindOfClass:[HSActivityInfoModel class]]) {
            HSActivityInfoModel* activityInfoModel = (HSActivityInfoModel*)componentItem;
            NSDictionary* params = @{@"activityInfoModel":activityInfoModel};
            HSActivityInfoDetailOpenURLFromTargetWithNativeParams(self, nil, params,activityInfoModel);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - service method 
-(HSActivityAdvertisementListService *)activityAdvertisementListService{
    if (_activityAdvertisementListService == nil) {
        _activityAdvertisementListService = [[HSActivityAdvertisementListService alloc] init];
        WEAKSELF
        _activityAdvertisementListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            if (service && service.dataList) {
                [strongSelf setupBannerViewWithDataList:service.dataList];
            }
        };
        _activityAdvertisementListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service , NSError* error){
            STRONGSELF
            EHLogInfo(@"-----> HSHomeBannerView activityAdvertisementListService failed cause of %@",error.userInfo[@"NSLocalizedDescription"]);
            [strongSelf setupBannerViewWithDataList:nil];
        };
    }
    return _activityAdvertisementListService;
}

-(void)setupBannerViewWithDataList:(NSArray *)array{
    if (array == nil || array.count == 0) {
        if ([self didBannerViewHasData]) {// 本地内置数据
            NSArray* nativeDictArray = @[HSDefaultPlaceHoldImage];
            [self.bannerView setLocalData:nativeDictArray];
        }
    }else{
        [self.bannerView setLocalData:array];
    }
    [self reloadData];
    [self.bannerView setAutoScrollEnabled:YES];
}

-(BOOL)didBannerViewHasData{
    return self.bannerView.dataArray && [self.bannerView.dataArray count] > 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = size;
    
    CGRect rect = self.bounds;
    
    rect.size.height = self.bannerView.height;
    
    /*Bug,会以中点，上下缩的，不能直接设置Bound*/
    newSize = CGSizeMake(newSize.width, rect.size.height);
    
    return newSize;
}

@end
