//
//  AMPageControlView.m
//  AlibabaMobile
//
//  Created by cloud ma on 12-9-3.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "TBPageControllerView.h"
#import "WeAppColorPageControl.h"

@interface TBPageControllerView ()

@property (nonatomic,strong) TBPageControl                 *pageControl;
@property (nonatomic,assign) BOOL                           pageControlUsed;
@property (nonatomic,assign) BOOL                           isPageArray;
@property (nonatomic,assign) NSUInteger                     pageNumber;
@property (nonatomic,strong) NSArray                       *pageArray;

-(void)pageTurn:(NSUInteger)page;
-(void)pageTurnWithSystemAnimated:(NSUInteger)page;
-(void)setScollViewFrame:(CGRect)frame;
-(void)setPageScrollViewArray:(NSArray*)viewArray withPage:(NSUInteger)page;

@end

@implementation TBPageControllerView
@synthesize delegate=_delegate;
@synthesize scrollView=_scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageControlUsed =_pageControlUsed;
@synthesize showPageControl=_showPageControl;
@synthesize autoScroll=_autoScroll;

-(id)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    _showPageControl = NO;
    _isScrollViewHorizontal = YES;
    _isLazyLoadOpen = NO;
    _isPageArray = NO;
    _pageNumber = 0;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

-(void)dealloc
{
    self.delegate = nil;
    self.scrollView.delegate = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(TBPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl = [[TBPageControl alloc]init];
        _pageControl.frame = CGRectMake(0.0, self.frame.size.height - 20, self.frame.size.width, 20);
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.pageControl setOrigin:CGPointMake(0.0, self.frame.size.height - 20)];
}

-(void)setScollViewFrame:(CGRect)frame{
    self.scrollView.frame = frame;
    self.scrollView.clipsToBounds = NO;
    [self.pageControl setOrigin:CGPointMake(frame.origin.x, self.frame.size.height - 20)];
    [self reloadData];
}

#pragma mark -
#pragma mark public meathod

-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = YES;
}

-(void)setIsScrollViewHorizontal:(BOOL)isScrollViewHorizontal{
    _isScrollViewHorizontal = isScrollViewHorizontal;
}

-(void)reloadData
{
    if (!self.isPageArray) {
        if ([self.delegate respondsToSelector:@selector(numberOfSectionsInPageControlView:)]) {
            NSUInteger number = [self.delegate numberOfSectionsInPageControlView:self];
            CGFloat width = 0.0;
            CGFloat height = 0.0;
            if (self.isScrollViewHorizontal) {
                width = self.scrollView.frame.size.width * number;
                height = self.scrollView.frame.size.height;
            }else{
                width = self.scrollView.frame.size.width;
                height = self.scrollView.frame.size.height * number;
            }
            self.scrollView.contentSize = CGSizeMake(width , height);
            [self setPageControlNumberOfPages:[self.delegate numberOfSectionsInPageControlView:self]];
            [self loadScrollViewWithPage:[self getPageControlCurrentPage]];
        }
    }
}

-(void)refreshPage:(int)index{
    if ([self.delegate respondsToSelector:@selector(TBPageControlView:refreshPage:)]){
         [self.delegate TBPageControlView:self refreshPage:index];
    }
}

-(void)refreshAllPages{
    if (![self.delegate respondsToSelector:@selector(TBPageControlView:refreshPage:)])
        return;
    
    int index = 0;
    
    for (; index < [self.delegate numberOfSectionsInPageControlView:self]; index++){
        [self refreshPage:index];
    }

}

-(void)resetPageControlView{
    [self setPageControlCurrentPage:0];
    [self setPageControlPreDisplayedPage:0];
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

-(void)setCurrentPage:(NSUInteger)page{
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInPageControlView:)]) {
        NSUInteger number = [self.delegate numberOfSectionsInPageControlView:self];
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        if (self.isScrollViewHorizontal) {
            width = self.scrollView.frame.size.width * number;
            height = self.scrollView.frame.size.height;
        }else{
            width = self.scrollView.frame.size.width;
            height = self.scrollView.frame.size.height * number;
        }
        self.scrollView.contentSize = CGSizeMake(width , height);
        [self setPageControlNumberOfPages:[self.delegate numberOfSectionsInPageControlView:self]];
        [self setPageControlCurrentPage:page];
        [self setPageControlPreDisplayedPage:page];
        if (self.isScrollViewHorizontal) {
            if (self.scrollView.frame.size.width * page <= self.scrollView.contentSize.width) {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * page, 0);
            }else{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }
            
        }else{
            if (self.scrollView.frame.size.height * page <= self.scrollView.contentSize.height) {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height * page);
            }else{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }
        }
        
        [self loadScrollViewWithPage:page];
    }
}

-(NSUInteger)getCuttentPage{
    return [self getPageControlCurrentPage];
}

-(NSUInteger)getNumberOfPages{
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInPageControlView:)]) {
        return [self.delegate numberOfSectionsInPageControlView:self];
    }
    return 0;
}

#pragma mark -
#pragma mark private meathod

-(void)setPageScrollViewArray:(NSArray*)viewArray withPage:(NSUInteger)page{
    if (viewArray && [viewArray count] > 0) {
        _isPageArray = YES;
        NSUInteger number = [viewArray count];
        self.pageArray = viewArray;
        self.pageNumber = number;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        if (self.isScrollViewHorizontal) {
            width = self.frame.size.width * number;
            height = self.frame.size.height;
        }else{
            width = self.frame.size.width;
            height = self.frame.size.height * number;
        }
        self.scrollView.contentSize = CGSizeMake(width , height);
        [self setPageControlNumberOfPages:number];
        [self setPageControlCurrentPage:page];
        [self setPageControlPreDisplayedPage:page];
        if (self.isScrollViewHorizontal) {
            if (self.scrollView.frame.size.width * page <= self.scrollView.contentSize.width) {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * page, 0);
            }else{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }
            
        }else{
            if (self.scrollView.frame.size.height * page <= self.scrollView.contentSize.height) {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height * page);
            }else{
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }
        }
        
        [self loadScrollViewWithPage:page];
    }
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (!self.isPageArray) {
        if (page >= [self.delegate numberOfSectionsInPageControlView:self])
        return;
        if (![self.delegate respondsToSelector:@selector(TBPageControlView:atIndex:)]) {
            return;
        }
        UIControl *view = [self.delegate TBPageControlView:self atIndex:page];
        if (view == nil) {
            return;
        }
        
        if (view.superview == nil)
        {
            CGFloat XOrigin = 0.0;
            CGFloat YOrigin = 0.0;
            if (self.isScrollViewHorizontal) {
                XOrigin = self.scrollView.frame.size.width * page;
                YOrigin = 0.0;
                [view setFrame:CGRectMake(XOrigin + (self.scrollView.frame.size.width -view.frame.size.width)/2, YOrigin + view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            }else{
                XOrigin = 0.0;
                YOrigin = self.scrollView.frame.size.height * page;
                [view setFrame:CGRectMake(XOrigin + view.frame.origin.x, YOrigin + (self.scrollView.frame.size.height -view.frame.size.height)/2, view.frame.size.width, view.frame.size.height)];
            }
            
            view.tag = page;
            [self.scrollView addSubview:view];
        }else if(view.superview == self.scrollView){
            CGFloat XOrigin = 0.0;
            CGFloat YOrigin = 0.0;
            if (self.isScrollViewHorizontal) {
                XOrigin = self.scrollView.frame.size.width * page;
                YOrigin = 0.0;
                [view setFrame:CGRectMake(XOrigin + (self.scrollView.frame.size.width -view.frame.size.width)/2, YOrigin + view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            }else{
                XOrigin = 0.0;
                YOrigin = self.scrollView.frame.size.height * page;
                [view setFrame:CGRectMake(XOrigin + view.frame.origin.x, YOrigin + (self.scrollView.frame.size.height -view.frame.size.height)/2, view.frame.size.width, view.frame.size.height)];
            }
            
            
            view.tag = page;
        }
    }else{
        if (page >= self.pageNumber)
        return;
        if (self.pageArray == nil || page >= [self.pageArray count]) {
            return;
        }
        UIControl *view = [self.pageArray objectAtIndex:page];
        if (view == nil) {
            return;
        }
        
        if (view.superview == nil)
        {
            CGFloat XOrigin = 0.0;
            CGFloat YOrigin = 0.0;
            if (self.isScrollViewHorizontal) {
                XOrigin = self.scrollView.frame.size.width * page;
                YOrigin = 0.0;
            }else{
                XOrigin = 0.0;
                YOrigin = self.scrollView.frame.size.height * page;
            }
            [view setFrame:CGRectMake(XOrigin + (self.scrollView.frame.size.width -view.frame.size.width)/2, YOrigin + view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            view.tag = page;
            [self.scrollView addSubview:view];
        }else if(view.superview == self.scrollView){
            CGFloat XOrigin = 0.0;
            CGFloat YOrigin = 0.0;
            if (self.isScrollViewHorizontal) {
                XOrigin = self.scrollView.frame.size.width * page;
                YOrigin = 0.0;
            }else{
                XOrigin = 0.0;
                YOrigin = self.scrollView.frame.size.height * page;
            }
            [view setFrame:CGRectMake(XOrigin + (self.scrollView.frame.size.width -view.frame.size.width)/2, YOrigin + view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            
            view.tag = page;
        }
    }
    
    
}

-(NSUInteger)caculateCurrentPage{
    CGPoint offset = [self.scrollView contentOffset];
    return [self caculateCurrentPageWithContentOffset:offset];
}

-(NSUInteger)caculateNextPage{
    CGPoint offset = [self.scrollView contentOffset];
    if (self.isScrollViewHorizontal) {
        offset.x += self.scrollView.bounds.size.width;
    }else{
        offset.y += self.scrollView.bounds.size.width;
    }
    
    if (offset.x >= self.scrollView.contentSize.width) {
        offset.x = 0;
    }
    
    if (offset.y >= self.scrollView.contentSize.height) {
        offset.y = 0;
    }
    return [self caculateCurrentPageWithContentOffset:offset];
}

-(NSUInteger)caculateCurrentPageWithContentOffset:(CGPoint)contentOffset{
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    int page = 0;
    if (self.isScrollViewHorizontal) {
        page = floor((contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }else{
        page = floor((contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    }
    return page;
}

/*
 DELEGATE
 */

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (self.pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    
    NSUInteger page = [self caculateCurrentPage];
    
    if ([self.delegate respondsToSelector:@selector(TBPageControlView:scrollViewDidScroll:withScollViewPage:)]) {
        [self.delegate TBPageControlView:self scrollViewDidScroll:self.scrollView withScollViewPage:page];
    }
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling
    [self setPageControlCurrentPage:page];
    
    if ([self.delegate respondsToSelector:@selector(TBPageControlView:willShowViewAtIndex:)]) {
        [self.delegate TBPageControlView:self willShowViewAtIndex:page];
    }
    
    if (self.isLazyLoadOpen) {
        [self loadScrollViewWithPage:page];
    }else{
        [self loadScrollViewWithPage:page-1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page+1];
    }
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
    scrollView.decelerationRate = 0.0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
    
    NSUInteger page = [self caculateCurrentPage];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling
    [self setPageControlCurrentPage:page];
    if (self.pageControl.preDisplayedPage != page) {
        [self setPageControlPreDisplayedPage:page];
        if ([self.delegate respondsToSelector:@selector(TBPageControlView:didShowViewAtIndex:)]) {
            [self.delegate TBPageControlView:self didShowViewAtIndex:page];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.pageControlUsed = NO;
    
    NSUInteger page = [self caculateCurrentPage];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling
    [self setPageControlCurrentPage:page];
    if (self.pageControl.preDisplayedPage != page) {
        [self setPageControlPreDisplayedPage:page];
        if ([self.delegate respondsToSelector:@selector(TBPageControlView:didShowViewAtIndex:)]) {
            [self.delegate TBPageControlView:self didShowViewAtIndex:page];
        }
    }
}

#pragma mark -
#pragma mark WeAppPageControlProtocol

-(void)setPageControlNumberOfPages:(NSUInteger)numberOfPages{
    self.pageControl.numberOfPages = numberOfPages;
}

-(NSUInteger)getPageControlNumberOfPages{
    return self.pageControl.numberOfPages;
}

-(void)setPageControlCurrentPage:(NSUInteger)currentPage{
    self.pageControl.currentPage = currentPage;
}

-(NSUInteger)getPageControlCurrentPage{
    return self.pageControl.currentPage;
}

-(void)setPageControlPreDisplayedPage:(NSUInteger)preDisplayedPage{
    self.pageControl.preDisplayedPage = preDisplayedPage;
}

-(NSUInteger)getPageControlPreDisplayedPage{
    return self.pageControl.preDisplayedPage;
}

#pragma mark -
#pragma mark 翻页动画 method

//滚图的动画效果
-(void)pageTurn:(NSUInteger)page{
    NSUInteger whichPage = page;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (self.isScrollViewHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * whichPage, self.scrollView.origin.y) animated:NO];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.origin.x, self.scrollView.height * whichPage) animated:NO];
        
    }
    [UIView commitAnimations];
    
}

//滚图的动画效果
-(void)pageTurnWithSystemAnimated:(NSUInteger)page{
    NSUInteger whichPage = page;
    if (self.isScrollViewHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * whichPage, self.scrollView.origin.y) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.origin.x, self.scrollView.height * whichPage) animated:YES];
    }
}

-(void)pageTurn:(NSUInteger)page withAnimated:(BOOL)animated{
    NSUInteger whichPage = page;
    if (self.isScrollViewHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * whichPage, self.scrollView.origin.y) animated:animated];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.origin.x, self.scrollView.height * whichPage) animated:animated];
    }
}

- (void)pageTurnNextPageWithAnimated:(BOOL)animated
{
    NSUInteger page = [self caculateNextPage];

    if (!animated)
    {
        [self pageTurn:page withAnimated:NO];
        return;
    }
    
    [self pageTurn:page withAnimated:YES];
}

@end


#pragma mark -
#pragma mark WeAppPointPageControllerView

@interface WeAppPointPageControllerView ()

@property (nonatomic, strong) WeAppColorPageControl*       colorPageControl;
@property (nonatomic, assign) CGRect                       pageControlRect;

@end

@implementation WeAppPointPageControllerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float pageControlH = 10 + 10;
        self.colorPageControl = [[WeAppColorPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlH, frame.size.width, 10)];
        self.pageControlRect = self.colorPageControl.frame;
        self.colorPageControl.userInteractionEnabled = NO;
        
        self.colorPageControl.gap = 8;
        self.colorPageControl.normalPageColor = [UIColor colorWithWhite:255/255.0f alpha:0.4f];
        self.colorPageControl.currentPageColor = [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0f];
        self.colorPageControl.borderColor = RGB(0xcc, 0xcc, 0xcc);
        self.colorPageControl.isSolid = YES;
        
        [self addSubview:self.colorPageControl];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.colorPageControl.frame = self.pageControlRect;
}

-(void)setShowPageControl:(BOOL)showPageControl{
    [super setShowPageControl:showPageControl];
    [self.colorPageControl setHidden:!showPageControl];
    [self bringSubviewToFront:self.colorPageControl];
}

-(CGRect)getPageControlPosition{
    return self.colorPageControl.frame;
}

-(void)setPageControlPosition:(CGRect)position{
    [self.colorPageControl setFrame:position];
    [self bringSubviewToFront:self.colorPageControl];
    self.pageControlRect = position;
}

-(void) setPageControlPointColor:(UIColor*)normal andSelectedColor:(UIColor*)current
{
    self.colorPageControl.normalPageColor  = normal;
    self.colorPageControl.currentPageColor = current;
}

#pragma mark -
#pragma mark WeAppPageControlProtocol

-(void)setPageControlNumberOfPages:(NSUInteger)numberOfPages{
    [super setPageControlNumberOfPages:numberOfPages];
    self.colorPageControl.numberOfPages = numberOfPages;
}

-(NSUInteger)getPageControlNumberOfPages{
    return self.colorPageControl.numberOfPages;
}

-(void)setPageControlCurrentPage:(NSUInteger)currentPage{
    [super setPageControlCurrentPage:currentPage];
    [self.colorPageControl setCurrentPage:currentPage];
}

-(NSUInteger)getPageControlCurrentPage{
    return self.colorPageControl.currentPage;
}

-(void)dealloc{
    self.colorPageControl = nil;
}

@end

#pragma mark -
#pragma mark WeAppAutoPointPageControllerView

@interface WeAppAutoPointPageControllerView ()

@property (nonatomic, strong) NSTimer*   timer;
@property (nonatomic, assign) long       seconds;

@end

@implementation WeAppAutoPointPageControllerView

#pragma mark-

-(void) setTimeInterval:(long)seconds
{
    _seconds = seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [super scrollViewWillBeginDragging:scrollView];
    [self cancelTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self cancelTimer];
    [self setTimeInterval:self.seconds];
}

-(void)pageTurn:(NSUInteger)index withAnimated:(BOOL)animated{
    [self cancelTimer];
    [self setTimeInterval:self.seconds];
    [super pageTurn:index withAnimated:animated];
}

-(void)timerProc: (NSTimer*)t
{
    if ([self getNumberOfPages] > 1) {
        [self pageTurnNextPageWithAnimated:YES];
    }
}

-(void)cancelTimer{
    if (self.timer != nil) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

-(void)dealloc{
    [self cancelTimer];
}

@end
