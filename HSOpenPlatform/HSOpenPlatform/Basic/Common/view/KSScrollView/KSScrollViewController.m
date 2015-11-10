//
//  KSScrollViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewController.h"
#import "WeAppUIScrollViewSpeed.h"

#define Target_WeAPP_SingleImage_Speed 0.1

#define Target_WeAPP_LoadAllImage_Speed 0.1

#define Target_WeAPP_LoadNoImage_Speed (2.0)

@interface KSScrollViewController()

@property (nonatomic, assign) BOOL                   isScrollViewCannotRefreshImage;

@property (nonatomic, assign) CGPoint                 scrollViewOffset;

@property (nonatomic, strong) WeAppUIScrollViewSpeed *scrollViewSpeed;


@end

@implementation KSScrollViewController

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc {
    if (_scrollViewSpeed) {
        _scrollViewSpeed = nil;
    }
    self.scrollView.delegate = nil;
    self.scrollView = nil;
    self.dataSourceRead = nil;
    self.dataSourceWrite = nil;
}

-(void)setFrame:(CGRect)frame{
    _frame = frame;
    if (self.scrollView && !CGRectEqualToRect(self.scrollView.frame, frame)) {
        [self.scrollView setFrame:frame];
    }
}

-(void)releaseConstrutView{
    if (_scrollViewSpeed) {
        _scrollViewSpeed = nil;
    }
    self.listComponentDidRelease = YES;
}

#pragma mark- public method

-(void)setDataSourceRead:(KSDataSource *)dataSourceRead {
    if (_dataSourceRead != dataSourceRead) {
        _dataSourceRead = dataSourceRead;
    }
}

-(void )setDataSourceWrite:(KSDataSource *)dataSourceWrite {
    if (_dataSourceWrite != dataSourceWrite) {
        _dataSourceWrite = dataSourceWrite;
    }
}

-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc]init];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc]init];
    }
    return _dataSourceWrite;
}

-(void)scrollRectToOffsetWithAnimated:(BOOL)animated{
    if (self.scrollView == nil) {
        return;
    }
    if (![self.scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if (self.scrollViewOffset.x <= 0 && self.scrollViewOffset.y <= 0) {
        return;
    }
    [self.scrollView setContentOffset:self.scrollViewOffset animated:animated];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableScroll
-(WeAppUIScrollViewSpeed *)scrollViewSpeed{
    __weak __block __typeof(self) weakSelf = self;
    if (!_scrollViewSpeed) {
        _scrollViewSpeed= [[WeAppUIScrollViewSpeed alloc]init];
        _scrollViewSpeed.speedChanged=^(CGFloat currentSpeed){
//            static BOOL  isTriggerDownloadImages=NO;
            if (weakSelf == nil) {
                return ;
            }
            if (currentSpeed < Target_WeAPP_LoadAllImage_Speed
                && [weakSelf.scrollView isKindOfClass:[UIScrollView class]]
                && weakSelf.scrollView.decelerating) {
                [weakSelf loadImages];
            }else if(currentSpeed > Target_WeAPP_LoadNoImage_Speed){
                weakSelf.canImageRefreshed = NO;
            }
        };
    }
    return _scrollViewSpeed;
}

-(void)loadImages{
    if ([self needQueueLoadData]){
        if (self.isScrollViewCannotRefreshImage) {
            self.canImageRefreshed = YES;
            [self resumeAllOperations];
            [self loadImagesForOnscreenCells];
            self.isScrollViewCannotRefreshImage = NO;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark subclass override method

- (void)loadImagesForOnscreenCells {
    
}

-(void)reloadData{
    
}

// 默认返回YES，需要异步线程渲染数据
-(BOOL)needQueueLoadData{
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate method

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    self.scrollViewOffset = scroll.contentOffset;
    [self.scrollViewSpeed calculateSpeedWithScrollView:scroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1
    //scollview滑动则将图片下载的线程暂停下载
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 2
    if (!decelerate) {
        //scollview停止滑动则将图片下载的线程启动下载
        [self loadImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 3
    //scollview停止滑动则将图片下载的线程启动下载
    self.isScrollViewCannotRefreshImage = YES;
    [self loadImages];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Cancelling, suspending, resuming queues / operations

- (void)suspendAllOperations {
    if ([self needQueueLoadData]) {
        self.isScrollViewCannotRefreshImage = YES;
    }
}

- (void)resumeAllOperations {
    if ([self needQueueLoadData]){
        
    }
}

@end
