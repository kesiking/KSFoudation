//
//  WeAppCycleScrollView.m
//  Taobao2013
//
//  Created by christ.yuj on 13-8-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppCycleScrollView.h"
#import "WeAppColorStyleSheet.h"

#define TIMER_INTERVAL   (4.0)
#define MAX_TIMER_BUCKET (TIMER_INTERVAL - 1.0)

@interface WeAppCycleScrollView (){
    NSTimer*                        _timer;
    UIScrollView*                   _scrollView;
    WeAppColorPageControl*             _pageControl;
    NSInteger                       _totalPages;
    NSInteger                       _curPage;
    NSMutableArray*                 _curViews;
    NSDate*                         _autoScrollDate;
    
    __unsafe_unretained id<WeAppCycleScrollViewDelegate>   _delegate;
    __unsafe_unretained id<WeAppCycleScrollViewDatasource> _datasource;
}

@end

@implementation WeAppCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _curViewCount = 3;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViewCount, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.x = 0;
        rect.size.width = self.bounds.size.width/4;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[WeAppColorPageControl alloc] initWithFrame:rect];
        _pageControl.normalPageColor = [WeAppColorStyleSheet colorWithColorType:TBColorBG_G];
        _pageControl.currentPageColor = [WeAppColorStyleSheet orangeColor];
        _pageControl.gap = 6;
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
        _disablePageClick = NO;
        _curPage = 0;
        _pagegap = 0;
    }
    return self;
}

-(void)setCurViewCount:(NSInteger)curViewCount{
    _curViewCount = curViewCount;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViewCount, self.bounds.size.height);
}

-(NSArray *)curViews{
    return _curViews;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    if (_autoScrollEnabled) {
        if (!newWindow) {
            self.stopScroll = YES;
        }else{
            self.stopScroll = NO;
        }
    }
}

-(void)setIsPageControlHide:(BOOL)isPageControlHide{
    if (isPageControlHide) {
        self.pageControl.alpha = 0;
    }else{
        self.pageControl.alpha = 1;
    }
}

-(void)setAutoScrollEnabled:(BOOL)autoScrollEnabled{
    _autoScrollEnabled = autoScrollEnabled;
    if (!_autoScrollEnabled) {
        self.stopScroll = YES;
    }else{
        self.stopScroll = NO;
    }
}

- (void)setStopScroll:(BOOL)stopScroll{
    _stopScroll = stopScroll;
    if (stopScroll) {
        [self cancelTimer];
    }else{
        [self cancelTimer];
        if (_totalPages>1) {
            _timer = [NSTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
            _autoScrollDate = [NSDate date];
//            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
    }
}

-(void)dealloc{
    [self cancelTimer];
    _scrollView.delegate = nil;
    self.delegate = nil;
    self.datasource = nil;
}

- (void)cancelTimer{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

-(void)autoScroll{
    NSDate* currentTime = [NSDate date];
    NSTimeInterval timerBucket = [currentTime timeIntervalSinceDate:_autoScrollDate];
    if (timerBucket <= MAX_TIMER_BUCKET) {
        return;
    }
    _autoScrollDate = currentTime;
    UIView* preView = [_curViews objectAtIndex: [self curViewMiddleIndex] - 1];
    UIView* centerView = [_curViews objectAtIndex:[self curViewMiddleIndex]];
    if (_scrollView.contentOffset.x != preView.frame.origin.x + preView.frame.size.width) {
        [_scrollView setContentOffset:CGPointMake(preView.frame.origin.x + preView.frame.size.width, 0)];
    }
    [_scrollView setContentOffset:CGPointMake(centerView.frame.origin.x + centerView.frame.size.width, 0) animated:YES];
    [self loadData];
}


- (void)setDatasource:(id<WeAppCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    [self cancelTimer];
    _totalPages = [_datasource numberOfPages:self];
    _curPage = 0;
    
    CGRect frame = _pageControl.frame;
    frame.size.width = _totalPages * MAX((_pageControl.width + _pageControl.gap), 15) ;
    
    if (self.isPageControlCenter) {
        _pageControl.frame = CGRectMake((self.frame.size.width - frame.size.width)/2, frame.origin.y, frame.size.width, frame.size.height);
    }else{
        _pageControl.frame = frame;
        
    }
    
    if (_totalPages == 0) {
        return;
    }
    if (_totalPages == 1) {
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    if (self.autoScrollEnabled || _totalPages ==1 ) {
        self.stopScroll = NO;
    }
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    while (_scrollView.subviews.count) {
        UIView* child = _scrollView.subviews.lastObject;
        [child removeFromSuperview];
    }
    
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    //一页的情况
    if (_totalPages <= 1) {
        _scrollView.scrollEnabled = NO;
        UIView* v = [_curViews objectAtIndex:0];
        v.userInteractionEnabled = YES;
        
        if (!self.disablePageClick) {
            for (UIGestureRecognizer* gesture in v.gestureRecognizers) {
                [v removeGestureRecognizer:gesture];
            }
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
        }
        
        
        v.frame = v.bounds;
        v.frame = CGRectOffset(v.frame, self.pagegap, 0);
        [_scrollView addSubview:v];
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        
        return;
    }else{
        _scrollView.scrollEnabled = YES;
        
        for (int i = 0; i < self.curViewCount; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            
            if (!self.disablePageClick) {
                for (UIGestureRecognizer* gesture in v.gestureRecognizers) {
                    [v removeGestureRecognizer:gesture];
                }
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleTap:)];
                [v addGestureRecognizer:singleTap];
            }
            
            v.frame = v.bounds;
            v.frame = CGRectOffset(v.frame, self.pagegap* (i+1)+ v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
        
        UIView* preView = [_curViews objectAtIndex: [self curViewMiddleIndex] - 1];
        [_scrollView setContentOffset:CGPointMake(preView.frame.origin.x + preView.frame.size.width, 0)];
        
    }
    
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    for (NSInteger i = _curPage - self.curViewCount/2; i <= _curPage + self.curViewCount/2; i ++) {
        UIView* viewItem = [_datasource csView:self pageAtIndex:[self validPageValue:i]]?:[[UIView alloc] init];
        if ([_curViews containsObject:viewItem]) {
            if ((([viewItem respondsToSelector:@selector(encodeWithCoder:)]
                  &&[viewItem respondsToSelector:@selector(initWithCoder:)])
                 ||(([viewItem isMemberOfClass:[UIButton class]]
                     ||[viewItem isMemberOfClass:[UIImageView class]])))
                &&[[UIDevice currentDevice].systemVersion floatValue] >= 5.0f) {
                NSData* archivedData = [NSKeyedArchiver archivedDataWithRootObject:viewItem];
                UIView* viewCopy = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
                [_curViews addObject:viewCopy?:[[UIView alloc] init]];
            }else{
                [_curViews addObject:[[UIView alloc] init]];
            }
        }else{
            [_curViews addObject:viewItem];
        }
    }
    
    
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value <= 0){
        value = _totalPages + value;
    }
    if(value >= _totalPages){
        value = value - _totalPages;
    }
    
    return value;
    
}

-(NSInteger)curViewMiddleIndex{
    return (self.curViewCount/2 + self.curViewCount%2 - 1)>0?self.curViewCount/2 + self.curViewCount%2 - 1:0;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
}

-(void)pageTurn:(NSUInteger)page withAnimated:(BOOL)animated{
    NSUInteger whichPage = page;
    if (whichPage >= _totalPages) {
        whichPage = _totalPages - 1;
    }
    _curPage = whichPage;
    [self loadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (self.frame.size.width * ([self curViewMiddleIndex] + 1))) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    else if(x <= self.frame.size.width * ([self curViewMiddleIndex] - 1)) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    UIView* preView = [_curViews objectAtIndex: [self curViewMiddleIndex] - 1];
    [_scrollView setContentOffset:CGPointMake(preView.frame.origin.x + preView.frame.size.width, 0)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_autoScrollEnabled) {
        self.stopScroll = YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoScrollEnabled) {
        self.stopScroll = NO;
    }
}

@end
