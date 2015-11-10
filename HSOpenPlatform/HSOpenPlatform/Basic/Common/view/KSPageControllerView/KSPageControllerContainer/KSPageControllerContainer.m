//
//  KSPageControllerContainer.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/14.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSPageControllerContainer.h"
#import "WeAppButtonWidthAlgorithm.h"
#import "WeAppSelectorItem.h"

#define default_selector_height (60)

@interface KSPageControllerContainer()<WeAppSelectorDelegate, WeAppSelectorSourceData,TBPageControlViewDelegate>

@property (nonatomic, strong) NSMutableDictionary                   *pageViewContainerReuseDict;

@end

@implementation KSPageControllerContainer

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - init and dealloc method
-(instancetype)initWithFrame:(CGRect)frame selectorButtonRect:(CGRect)selectorButtonRect{
    self = [super initWithFrame:frame];
    if (self) {
        _selectorButtonRect = selectorButtonRect;
        [self configView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)setupView{
    [super setupView];
    [self initDataSource];
}

-(void)configView{
    [self addSubview:self.selectorView];
    [self addSubview:self.pageControllerView];
}

-(void)initDataSource{
    self.selectorDataSource = [[NSMutableArray alloc] initWithCapacity:5];
    self.pageViewContainerReuseDict = [NSMutableDictionary dictionary];
}

-(void)dealloc{
    if ([self.pageControllerView isKindOfClass:[WeAppAutoPointPageControllerView class]]) {
        [(WeAppAutoPointPageControllerView*)self.pageControllerView cancelTimer];
    }
    self.pageControllerView.delegate = nil;
    self.pageControllerView = nil;
    self.selectorView.delegate = nil;
    self.selectorView = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 懒加载 属性 method
-(TBPageControllerView *)pageControllerView{
    if (_pageControllerView == nil) {
        CGRect rect = self.bounds;
        rect.origin.y = self.selectorView.bottom;
        rect.size.height = rect.size.height - self.selectorView.height;
        _pageControllerView = [[TBPageControllerView alloc] initWithFrame:rect];
        _pageControllerView.backgroundColor = RGB(0xf0, 0xf0, 0xf0);
        _pageControllerView.showPageControl = NO;
        _pageControllerView.delegate = self;
        _pageControllerView.isScrollViewHorizontal = YES;
        _pageControllerView.scrollView.scrollsToTop = NO;
        _pageControllerView.scrollView.bounces = NO;
        _pageControllerView.scrollView.directionalLockEnabled = YES;
        _pageControllerView.isLazyLoadOpen = NO;
    }
    return _pageControllerView;
}

-(WeAppTSimpleSelectorScrollView *)selectorView{
    if (_selectorView == nil) {
        _selectorView = [[WeAppTSimpleSelectorScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.selectorButtonRect.size.height)];
        _selectorView.sourceDelegate = self;
        _selectorView.delegate = self;
        UIImageView* indicatorView = [_selectorView getIndicatorView];
        [indicatorView setBackgroundColor:[UIColor redColor]];
        [_selectorView setNeedIndicatorView:YES];
    }
    return _selectorView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark - 系统 method
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.selectorView setFrame:CGRectMake(0, 0, self.frame.size.width, self.selectorButtonRect.size.height)];
    CGRect rect = self.bounds;
    rect.origin.y = self.selectorView.bottom;
    rect.size.height = rect.size.height - self.selectorView.height;
    [self.pageControllerView setFrame:rect];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- public method
-(void)setSelectorButtonRect:(CGRect)selectorButtonRect{
    _selectorButtonRect = selectorButtonRect;
    [self layoutIfNeeded];
}

-(void)reloadData{
    [self.selectorView setSelectorWithItemArray:self.selectorDataSource defaultIndex:0];
    [self.selectorView reloadData];
    
    [self.pageControllerView reloadData];
}

-(id)dequeueReusableControlWithIdentifier:(NSString *)identifier withItemIndex:(NSUInteger)itemIndex{
    if ([EHUtils isEmptyString:identifier]) {
        [WeAppToast toast:@"-----> 不允许 identifier 为空"];
        return nil;
    }
    id pageViewContainerReuseControl = [self.pageViewContainerReuseDict objectForKey:[NSString stringWithFormat:@"%@_%lu",identifier,itemIndex]];
    return pageViewContainerReuseControl;
}

-(void)setControlWithControl:(UIControl*)control reuseIdentifier:(NSString *)identifier withItemIndex:(NSUInteger)itemIndex{
    if ([EHUtils isEmptyString:identifier]) {
        [WeAppToast toast:@"-----> 不允许 identifier 为空"];
        return;
    }
    if (control == nil) {
        [WeAppToast toast:@"-----> control 不可为空"];
        return;
    }
    [self.pageViewContainerReuseDict setObject:control forKey:[NSString stringWithFormat:@"%@_%lu",identifier,itemIndex]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- containerView or selectorView scroll to page
-(void)scrollToPage:(NSUInteger)index withAnimated:(BOOL)animated
{
    NSUInteger totlePageCount = [self numberOfSectionsInPageControlView:self.pageControllerView];
    if (index >= totlePageCount) {
        [WeAppToast toast:@"-----> selector选择栏数量不能多于pageView数量"];
        return;
    }
    if ([self.pageControllerView respondsToSelector:@selector(pageTurn:withAnimated:)])
        [self.pageControllerView pageTurn:index withAnimated:animated];
}

- (void)setSelectBtn:(NSUInteger)index{
    if (self.selectorView && self.selectorView.defaultIndex != index) {
        [self.selectorView setPluginSelectBtn:index];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TBSNSPageControllView delegate method start
- (NSUInteger)numberOfSectionsInPageControlView:(UIView*)pageControlView{
    if (self.pageControllerViewDelegate && [self.pageControllerViewDelegate respondsToSelector:@selector(numberOfSectionsInPageControllerView:)] && [pageControlView isKindOfClass:[TBPageControllerView class]]) {
        return [self.pageControllerViewDelegate numberOfSectionsInPageControllerView:(TBPageControllerView*)pageControlView];
    }
    return 0;
}

- (UIControl*)TBPageControlView:(UIView*)pageControlView atIndex:(NSUInteger)itemIndex{
    
    if (itemIndex >= [self numberOfSectionsInPageControlView:pageControlView]) {
        return [[UIControl alloc] init];
    }
    
    if (self.pageControllerViewDelegate && [self.pageControllerViewDelegate respondsToSelector:@selector(pageControllerView:atIndex:)] && [pageControlView isKindOfClass:[TBPageControllerView class]]) {
        return [self.pageControllerViewDelegate pageControllerView:(TBPageControllerView*)pageControlView atIndex:itemIndex];
    }
    
    return [[UIControl alloc] init];
}

-(void)TBPageControlView:(UIView*)pageControlView refreshPage:(int)itemIndex{
    if (itemIndex >= [self numberOfSectionsInPageControlView:pageControlView]) {
        return;
    }
}

-(void)TBPageControlView:(UIView *)pageControlView scrollViewDidScroll:(UIScrollView *)scrollView withScollViewPage:(NSUInteger)page{
    CGFloat rate = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.selectorView setScrollIndicatorViewRate:rate];
}

-(void)TBPageControlView:(UIView *)pageControlView willShowViewAtIndex:(NSUInteger)itemIndex{
    if (itemIndex >= [self numberOfSectionsInPageControlView:pageControlView]) {
        return;
    }
    [self setSelectBtn:itemIndex];
    if (self.pageControllerViewDelegate && [self.pageControllerViewDelegate respondsToSelector:@selector(pageControllerView:willShowViewAtIndex:)] && [pageControlView isKindOfClass:[TBPageControllerView class]]) {
        [self.pageControllerViewDelegate pageControllerView:(TBPageControllerView*)pageControlView willShowViewAtIndex:itemIndex];
    }
}

-(void)TBPageControlView:(UIView *)pageControlView didShowViewAtIndex:(NSUInteger)itemIndex{
    if (itemIndex >= [self numberOfSectionsInPageControlView:pageControlView]) {
        return;
    }
    if (self.pageControllerViewDelegate && [self.pageControllerViewDelegate respondsToSelector:@selector(pageControllerView:didShowViewAtIndex:)] && [pageControlView isKindOfClass:[TBPageControllerView class]]) {
        [self.pageControllerViewDelegate pageControllerView:(TBPageControllerView*)pageControlView didShowViewAtIndex:itemIndex];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCASelectorDelegate
//选择一个selector触发事件
-(void)selectorView:(UIView*)selectView didSelectRowAtIndex:(NSUInteger)index{
    EHLogInfo(@"Selected index at %lu",(unsigned long)index);
    [self scrollToPage:index withAnimated:NO];
    if (self.selectorViewDelegate && [self.selectorViewDelegate respondsToSelector:@selector(pageControllerSelectorView:didSelectRowAtIndex:)] && [selectView isKindOfClass:[WeAppTSimpleSelectorScrollView class]]) {
        [self.selectorViewDelegate pageControllerSelectorView:(WeAppTSimpleSelectorScrollView*)selectView didSelectRowAtIndex:index];
    }
}

//如果选择的是同一个selector
-(void)selectorView:(UIView*)selectView didSelectSameRowAtIndex:(NSUInteger)index{
    EHLogInfo(@"Selected same index at %lu", index);
    if (self.selectorViewDelegate && [self.selectorViewDelegate respondsToSelector:@selector(pageControllerSelectorView:didSelectSameRowAtIndex:)] && [selectView isKindOfClass:[WeAppTSimpleSelectorScrollView class]]) {
        [self.selectorViewDelegate pageControllerSelectorView:(WeAppTSimpleSelectorScrollView*)selectView didSelectSameRowAtIndex:index];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCASelectorSourceData
//设置selector的样式，index是在selectView中第index位置的itemView，isSelect为是否选中

/******************************************************
 该方法主要是初始化时调用的，用于初始化按钮控件的样式
 ******************************************************/
-(void)setSelectorViewProperty:(UIView*)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    if (self.selectorDataSource && [self.selectorDataSource count] > 0 && index < [self.selectorDataSource count]) {
        id selectorItem =[self.selectorDataSource objectAtIndex:index];
        if (selectorItem && itemView && [itemView isKindOfClass:[WeAppSelectorButton class]]) {
            WeAppSelectorButton * selectorView = (WeAppSelectorButton*)itemView;
            if (self.selectorViewDelegate && [self.selectorViewDelegate respondsToSelector:@selector(pageControllerSelectorProperty:selectorItem:withIndex:isSelect:isFirstConfig:)]) {
                [self.selectorViewDelegate pageControllerSelectorProperty:selectorView selectorItem:selectorItem withIndex:index isSelect:isSelect isFirstConfig:YES];
            }else if([selectorItem isKindOfClass:[WeAppSelectorItem class]]){
                WeAppSelectorItem *weappSelectorItem = (WeAppSelectorItem*)selectorItem;
                
                [self setSelectorView:selectorView selectorItem:weappSelectorItem isSelect:isSelect];
                
                //文案填充
                if (weappSelectorItem.title && weappSelectorItem.title.length > 0) {
                    [selectorView setTitle:weappSelectorItem.title forState:UIControlStateNormal];
                }
                
                //icon图片
                [selectorView setSelectorIcon:weappSelectorItem.iconUrl forState:UIControlStateNormal];
                
                //小红点
                [selectorView setNumber:weappSelectorItem.newMsgNum formatType:weappSelectorItem.formatType precision:weappSelectorItem.precision andNeedPoint:weappSelectorItem.isShowRedDot];
            }
        }
    }
}

/******************************************************
 该方法在选择按钮时调用，用于改变当前选中与之前选中按钮的状态
 ******************************************************/
-(void)changeSelectorViewProperty:(UIView*)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    if (self.selectorDataSource && [self.selectorDataSource count] > 0 && index < [self.selectorDataSource count]) {
        id selectorItem =[self.selectorDataSource objectAtIndex:index];
        if (selectorItem && itemView && [itemView isKindOfClass:[WeAppSelectorButton class]]) {
            WeAppSelectorButton * selectorView = (WeAppSelectorButton*)itemView;
            //改变样式
            if (self.selectorViewDelegate && [self.selectorViewDelegate respondsToSelector:@selector(pageControllerSelectorProperty:selectorItem:withIndex:isSelect:isFirstConfig:)]) {
                [self.selectorViewDelegate pageControllerSelectorProperty:selectorView selectorItem:selectorItem withIndex:index isSelect:isSelect isFirstConfig:NO];
            }else if([selectorItem isKindOfClass:[WeAppSelectorItem class]]){
                WeAppSelectorItem *weappSelectorItem = (WeAppSelectorItem*)selectorItem;
                [self setSelectorView:selectorView selectorItem:weappSelectorItem isSelect:isSelect];
            }
        }
    }
}

//改变
-(void)setSelectorView:(WeAppSelectorButton*)selectorView selectorItem:(WeAppSelectorItem*)selectorItem isSelect:(BOOL)isSelect{
    //选中样式
    if (isSelect) {
        [selectorView setBackgroundImage:selectorItem.selectedBackgroundUrl forState:UIControlStateNormal forParam:nil];
    }else{
        //不选中的样式
        if (selectorItem.backgroundUrl  && selectorItem.backgroundUrl.length > 0) {
            [selectorView setBackgroundImage:selectorItem.backgroundUrl forState:UIControlStateNormal forParam:nil];
        }else{
            [selectorView.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

/******************************************************
 该方法在按钮初始化调用，用于改变选择栏的每个按钮的宽高
 ******************************************************/
-(void)setSelectorFrame:(UIView*)selectView{
    if (selectView == nil || ![selectView isKindOfClass:[WeAppTSimpleSelectorScrollView class]]) {
        return;
    }
    WeAppTSimpleSelectorScrollView* simpleSelectorScrollView = (WeAppTSimpleSelectorScrollView*)selectView;
    // 设置tabHeadView的每个tabItem的css
    if (self.selectorButtonRect.size.width > 0) {
        simpleSelectorScrollView.buttonWidth = self.selectorButtonRect.size.width;
    }else if (self.selectorView.frame.size.width > 0){
        simpleSelectorScrollView.buttonWidth = [WeAppButtonWidthAlgorithm viewDynamicWidthWithNum:simpleSelectorScrollView.pluginCnt andParentWidth:self.selectorView.frame.size.width];
    }
    if (self.selectorButtonRect.size.height > 0) {
        simpleSelectorScrollView.buttonHeight = self.selectorButtonRect.size.height;
    }else{
        simpleSelectorScrollView.buttonHeight = default_selector_height;
    }
    
    [simpleSelectorScrollView getIndicatorView].frame = CGRectMake(4, simpleSelectorScrollView.buttonHeight - 6, simpleSelectorScrollView.buttonWidth - 8, 2);

}

@end
