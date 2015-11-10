//
//  KSScrollViewServiceController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewServiceController.h"
#import "WeAppLoadingView.h"
#import "KSAdapterService.h"
#import "UIImage+GIF.h"

#define errorViewTag 1001

#define labelViewTag 1002

@interface KSScrollViewServiceController()

@property (nonatomic, assign) BOOL                   isLoading;

@property (nonatomic, assign) BOOL                   isNextPage;

@property (nonatomic, assign) BOOL                   isRefreshDataSignal;

@property (nonatomic, assign) BOOL                   isFirstLoadingView;

@property (nonatomic, strong) WeAppLoadingView       *refreshPageLoadingView;

@property (nonatomic, strong) WeAppLoadingView       *nextPageLoadingView;

@property (nonatomic, strong) MBProgressHUD          *hud;

#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic) dispatch_queue_t serialQueue;
#else
@property (assign, nonatomic) dispatch_queue_t serialQueue;
#endif

@end

@implementation KSScrollViewServiceController

-(instancetype)initWithConfigObject:(KSScrollViewConfigObject*)configObject{
    if (self = [self init]) {
        self.configObject = configObject;
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        NSString *serialQueueName = [NSString stringWithFormat:@"com.taobao.WeApp.tableview.%@",[NSNumber numberWithUnsignedInteger:[self hash]]];
        _serialQueue = dispatch_queue_create([serialQueueName UTF8String], DISPATCH_QUEUE_SERIAL);
        self.isFirstLoadingView = YES;
    }
    return self;
}

-(void)setService:(WeAppBasicService *)service{
    if (_service != service) {
        _service.delegate = nil;
        _service = nil;
        _service = service;
        _service.delegate = self;
    }
}

-(void)dealloc {
    if (_nextPageLoadingView) {
        _nextPageLoadingView = nil;
    }
    [self releaseScrollView];
    if (self.onRefreshEvent) {
        self.onRefreshEvent = nil;
    }
    if (self.onNextEvent) {
        self.onNextEvent = nil;
    }
    if ([self needQueueLoadData]) {
        dispatch_sync(_serialQueue, ^{
            @try {
                [self.dataSourceWrite removeAllCellitems];
                self.dataSourceWrite = nil;
            }
            @catch (NSException *exception) {
                NSLog(@"------>dispatch %s list crashed for %@",__FUNCTION__,exception.reason);
            }
        });
    }
    self.dataSourceRead = nil;
    self.errorViewTitle = nil;
    self.service.delegate = nil;
    self.service = nil;
    WeAppDispatchQueueRelease(_serialQueue);
}

-(void)releaseConstrutView{
    [super releaseConstrutView];
    [self releaseScrollView];
}

-(void)releaseScrollView{
    if (self.scrollView && [self.scrollView isKindOfClass:[UIScrollView class]]) {
        @try {
            if ([NSThread isMainThread])
            {
                [self.scrollView setShowsPullToRefresh:NO];
                self.scrollView.delegate = nil;
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.scrollView setShowsPullToRefresh:NO];
                    self.scrollView.delegate = nil;
                });
            }
        }
        @catch (NSException *exception) {
            NSLog(@"setWeAppShowsPullToRefresh crashed");
        }
    }
    self.scrollView = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark errorView
//统一到基类中去以后
-(void)setErrerView{
    //如果当前list为空并且unScroll为假，即能滑动，且无headerview或是footerview
    BOOL isRfresh = self.service && [self.service.pagedList isRefresh];
    if ([self needErrerView]) {
        UIView *view = [self.scrollView viewWithTag:errorViewTag];
        if (!view) {
            view = [self getErrorView];
            view.tag = errorViewTag;
        }
        [self showErrorView:view];
    }else if([self needFootView] && [self needNextPage] && !isRfresh){
        [self updateFootView];
    }else if(self.configObject.needErrorView){
        UIView *view = [self.scrollView viewWithTag:errorViewTag];
        [view removeFromSuperview];
        [self hideErrorView:view];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setErrerView) object:nil];
}

-(UIView*)getErrorView{
    if (self.errorView) {
        return self.errorView;
    }
    UIView* view = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    view.backgroundColor = RGB(0xf5, 0xf5, 0xf9);
    
    CGFloat oringeY = (view.frame.size.height - (100.0 + 40.0 + 18.0 + 24.0 + 14.0))/2;
    
    UIImage *image = [UIImage imageNamed:@"icon_nonews"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.origin.x + (view.width - 110)/2, view.origin.y + oringeY, 110, 85)];
    imageView.image = image;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.origin.y + imageView.height + 40, view.width, 18)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(0x33, 0x33, 0x33);
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    label.textAlignment =  NSTextAlignmentCenter;

    if (self.errorViewTitle && self.errorViewTitle.length > 0) {
        label.text = self.errorViewTitle;
        CGSize labelInfoSize = [self.errorViewTitle boundingRectWithSize:CGSizeMake(label.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil].size;
        [label setHeight:labelInfoSize.height];
    }

    [view addSubview:label];
    
    UILabel *labelSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, label.origin.y + label.height + 12, view.width, 14)];
    labelSubTitle.textColor = RGB(0x99, 0x99, 0x99);
    labelSubTitle.backgroundColor = [UIColor clearColor];
    labelSubTitle.textAlignment =  NSTextAlignmentCenter;
    labelSubTitle.font = [UIFont systemFontOfSize:14];
    labelSubTitle.text = @"暂时没有相关数据";
    [view addSubview:labelSubTitle];
    
    [view addSubview:imageView];
    return view;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark nextFootView

-(void)updateFootView{
    UILabel* label = (UILabel*)[self.nextFootView viewWithTag:labelViewTag];
    if (label != nil && [label isMemberOfClass:[UILabel class]]) {
        BOOL hasMore = self.service && [self.service.pagedList hasMore] && self.service.serviceSuccess;
        if (hasMore) {
            if (![self isNetReachable]) {
                label.text = self.nextFootViewTitle?:@"网络异常，请稍候再试";
            }else{
                label.text = self.nextFootViewTitle?:@"正在加载，请稍候";
            }
            [self.nextPageLoadingView startAnimating];
            [self.nextPageLoadingView setHidden:NO];
            self.nextFootView.height = 30;
        }else{
            label.text = self.hasNoDataFootViewTitle?:nil;
            [self.nextPageLoadingView stopAnimating];
            [self.nextPageLoadingView setHidden:YES];
            self.nextFootView.height = self.hasNoDataFootViewTitle?76:0;
        }
        if([self needFootView] && [self needNextPage]){
            [self setFootView:self.nextFootView];
        }
    }
}

-(UIView *)nextFootView{
    if (_nextFootView == nil) {
        _nextFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 76)];
        _nextFootView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:_nextFootView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UINAVIGATIONBAR_COMMON_COLOR;
        label.tag = labelViewTag;
        label.backgroundColor = [UIColor clearColor];
        [_nextFootView addSubview:label];
        [_nextFootView addSubview:self.nextPageLoadingView];
    }
    return _nextFootView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MBProgressHUD method

-(MBProgressHUD *)hud{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithFrame:self.frame];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"请稍等···";
        [self.scrollView addSubview:_hud];
    }
    return _hud;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark loadingView method

-(WeAppLoadingView *)refreshPageLoadingView{
    if (_refreshPageLoadingView == nil) {
        _refreshPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _refreshPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _refreshPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
    }
    return _refreshPageLoadingView;
}

-(WeAppLoadingView *)nextPageLoadingView {
    if (_nextPageLoadingView == nil) {
        _nextPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(([self.scrollView width] - 28)/2, 1, 28, 28)];
        _nextPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _nextPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
    }
    return _nextPageLoadingView;
}

-(void)showLodingView{
    if (self.isFirstLoadingView && self.configObject.needLoadingView) {
        [self.hud show:YES];
        self.isFirstLoadingView = NO;
    }
    if (!self.service) {
        return;
    }
    if (self.service.requestModel.pagedList.isRefresh) {
        [self showRefreshPageLoadingView];
    }else{
        [self showNextPageLoadingView];
    }

}

-(void)hideLodingView {
    self.isLoading = NO;
    [self updateFootView];
    self.nextPageLoadingView.hidden = YES;
    [self.nextPageLoadingView stopAnimating];
    [self.refreshPageLoadingView stopAnimating];
    if (self.configObject.needLoadingView) {
        [self.hud hide:YES];
    }
}

-(void)showRefreshPageLoadingView {
    if (!self.isLoading) {
        self.isLoading = YES;
        [self.refreshPageLoadingView startAnimating];
    }
}

-(void)showNextPageLoadingView {
    if (!self.isLoading || self.nextPageLoadingView.hidden) {
        self.isLoading = YES;
        [self updateFootView];
        self.nextPageLoadingView.hidden = NO;
        [self.nextPageLoadingView startAnimating];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark table config

-(void)configPullToRefresh:(UIScrollView*)scrollView{
    //刷新逻辑
    if ([self needRefresh] && [scrollView isKindOfClass:[UIScrollView class]]) {
        __block __weak __typeof(self) tempSelf = self;
        [scrollView addPullToRefreshWithActionHandler:^{
            __strong __typeof(self) strongSelf = tempSelf;
            
            int64_t delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([strongSelf.scrollView showsPullToRefresh]) {
                    //判断是否已经被取消刷新，避免出现crash
                    [strongSelf refresh];
                    [strongSelf.scrollView.pullToRefreshView stopAnimating];
                }
            });
        }];
        [self configPullToRefreshViewStatus:scrollView];
    }
    
}

-(void)configPullToRefreshViewStatus:(UIScrollView *)scrollView{
    if (self.scrollViewConfigPullToRefreshView) {
        self.scrollViewConfigPullToRefreshView(scrollView,scrollView.pullToRefreshView);
    }else{
        [scrollView.pullToRefreshView setTitle:@"" forState:SVInfiniteScrollingStateAll];
        [scrollView.pullToRefreshView setCustomView:self.refreshPageLoadingView forState:SVInfiniteScrollingStateAll];
        [self.refreshPageLoadingView startAnimating];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark override method

-(void)setFootView:(UIView*)view{
    
}

-(void)showErrorView:(UIView*)view{
    
}

-(void)hideErrorView:(UIView*)view{
    
}

-(void)refresh {
    // refresh
    if (self.configObject.serviceCanLoadData) {
        self.isNextPage = NO;
        [self.service refreshPagedList];
    }
    if (self.onRefreshEvent) {
        self.onRefreshEvent(self);
    }
}

-(void)nextPage {
    // nextPage
    if (self.configObject.serviceCanLoadData) {
        self.isNextPage = YES;
        [self performSelector:@selector(changeNextPage) withObject:nil afterDelay:5.0];
        [self showNextPageLoadingView];
        [self.service nextPage];
    }
    if (self.onNextEvent) {
        self.onNextEvent(self);
    }
}

// override subclass 是否需要翻页
-(BOOL)needNextPage {
    return self.configObject.needNextPage;
}

-(BOOL)needRefresh {
    return self.configObject.needRefreshView;
}

-(BOOL)isNetReachable{
#ifdef _KSAppConfiguration_
    return (KSNetworkReachabilityStatusNotReachable != [[KSAppConfiguration sharedCenter] networkReachabilityStatus]) && (KSNetworkReachabilityStatusUnknown != [[KSAppConfiguration sharedCenter] networkReachabilityStatus]);
#else
    return YES;
#endif
}

-(BOOL)canNextPage{
    if (![self needNextPage] || self.isLoading || self.isNextPage) {
        return NO;
    }
    
    if (!self.configObject.serviceCanLoadData) {
        return NO;
    }
    
    if (![self isNetReachable]) {
        return NO;
    }
    
    if (self.service != nil) {
        if (self.service.pagedList == nil) {
            return NO;
        }
        
        BOOL isServiceLoading = self.service.requestModel.isLoading;
        if (isServiceLoading) {
            return NO;
        }
        
        BOOL hasMore = [self.service.pagedList hasMore];
        if (!hasMore) {
            return NO;
        }
    }
    return YES;
}

-(void)changeNextPage{
    self.isNextPage = NO;
}

-(BOOL)needFootView{
    return self.configObject.needFootView;
}

-(BOOL)needErrerView{
    return (self.service == nil || [self.dataSourceRead count] == 0) && self.configObject.needErrorView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark private method
-(void)refreshData{
    if (self.scrollView == nil) {
        return;
    }
    // refresh cell
    if ([self needQueueLoadData]) {
        __block __weak __typeof(self) wself = self;
        // 设置信号量，refreshData异步线程开始时设置为YES，在此阶段中调用reloadData都会被无视
        self.isRefreshDataSignal = YES;
        BOOL isRefresh = self.service && [self.service.pagedList isRefresh];
        dispatch_async(_serialQueue, ^{
            @try {
                __strong __typeof(self) sself = wself;
                if (wself == nil) {
                    return;
                }
                
                // copy data from read buff
                if (isRefresh) {
                    // clear
                    [sself.dataSourceWrite removeAllCellitems];
                }
                
                for (NSInteger i = 0; i < [sself.dataSourceWrite count]; i++) {
                    [sself.dataSourceWrite setupComponentItemWithIndex:i];
                }
                if (wself == nil) {
                    return;
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // change the write to read
                    if (isRefresh ) {
                        // clear
                        [sself.dataSourceRead removeAllCellitems];
                    }
                    id temp = sself.dataSourceRead;
                    sself.dataSourceRead = sself.dataSourceWrite;
                    sself.dataSourceWrite = temp;
                    
                    // 设置信号量，refreshData异步线程结束时设置为NO，reloadData可以执行
                    sself.isRefreshDataSignal = NO;
                    if (wself == nil) {
                        return;
                    }
                    [sself reloadData];
                    [sself performSelector:@selector(setErrerView) withObject:nil afterDelay:0];
                    if (sself.listComponentDidRelease){
                        sself.listComponentDidRelease = NO;
                    }
                    sself.isNextPage = NO;
                });
            }
            @catch (NSException *exception) {
                NSLog(@"dispatch list crashed");
            }
        });
    }else{
        [self reloadData];
        self.isNextPage = NO;
    }
}

#pragma mark deleteItemAtIndexs

-(void)deleteItemAtIndexs:(NSIndexSet*)indexs{
    // 必须要先删除引用中的数据，再删除源头数据
    if ([self needQueueLoadData]) {
        __block __weak __typeof(self) wself = self;
        dispatch_sync(_serialQueue, ^{
            @try {
                __strong __typeof(self) sself = wself;
                if (wself == nil) {
                    return;
                }
                [sself.dataSourceWrite deleteItemAtIndexs:indexs];
            }
            @catch (NSException *exception) {
                NSLog(@"------>dispatch %s list crashed for %@",__FUNCTION__,exception.reason);
            }
        });
        [self.dataSourceRead deleteItemAtIndexs:indexs];
    }else{
        [self.dataSourceRead deleteItemAtIndexs:indexs];
    }
    if (self.service && self.service.pagedList) {
        [self.service.pagedList removeObjectsAtIndexes:indexs];
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark subclass override method

-(void)reloadData{
    [super reloadData];
}

// 默认返回YES，需要异步线程渲染数据
-(BOOL)needQueueLoadData{
    return self.configObject.needQueueLoadData;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark WeAppBasicServiceDelegate method

- (void)serviceDidStartLoad:(WeAppBasicService *)service{
    if (service && service.apiName) {
        [self requestDidStart];
    }
}

- (void)serviceDidFinishLoad:(WeAppBasicService *)service{
    if (service && service.apiName) {
        if (service.pagedList) {
            [self setupDataList:[service.pagedList getItemList]];
        }else if(service.dataList){
            [self setupDataList:service.dataList];
        }else{
            [self setupDataList:@[]];
        }
    }
    [self requestDidLoad];
}

-(void)serviceCacheDidLoad:(WeAppBasicService *)service cacheData:(NSArray*)cacheData{
    switch (self.configObject.scrollViewCacheType) {
        case KSScrollViewConfigCacheType_default:
        {
            if (service && service.apiName && cacheData && [cacheData count] > 0) {
                [self setupDataList:cacheData];
                [self requestDidLoad];
            }
        }
            break;
        default:
            break;
    }
}

-(void)setupDataList:(NSArray*)array{
    if ([self needQueueLoadData]) {
        // 如果首次进入页面或是页面一直没有数据则主线程更新
        if ([self.dataSourceRead count] == 0) {
            [self.dataSourceRead setDataWithPageList:array extraDataSource:nil];
        }
        dispatch_async(_serialQueue, ^{
            [self.dataSourceWrite setDataWithPageList:array extraDataSource:nil];
        });
    }else{
        [self.dataSourceRead setDataWithPageList:array extraDataSource:nil];
    }
}

- (void)service:(WeAppBasicService *)service didFailLoadWithError:(NSError*)error{
    if (service && service.apiName) {
        switch (self.configObject.scrollViewCacheType) {
            case KSScrollViewConfigCacheType_default:
            {
                if (service.pagedList) {
                    [self setupDataList:[service.pagedList getItemList]];
                }else if(service.dataList){
                    [self setupDataList:service.dataList];
                }else{
                    [self setupDataList:@[]];
                }
            }
                break;
            case KSScrollViewConfigCacheType_afterFail:
            {
                if (service.cacheComponentItems && [service.cacheComponentItems count] > 0) {
                    [self setupDataList:service.cacheComponentItems];
                }else{
                    [self setupDataList:@[]];
                }
            }
                break;
            default:
                break;
        }
    }
    [self apiRequestDidFail];
}

- (void)requestDidStart{
    [self showLodingView];
}

- (void)requestDidLoad{
    [self refreshData];
    [self hideLodingView];
    [self performSelector:@selector(setErrerView) withObject:nil afterDelay:0];
}

-(void)apiRequestDidFail{
    if (![self.service.pagedList isRefresh] && [self.dataSourceRead count] > 0) {
        NSLog(@"---> 翻页失败");
    }else{
        [self refreshData];
    }
    [self hideLodingView];
    [self performSelector:@selector(setErrerView) withObject:nil afterDelay:0];
}

@end
