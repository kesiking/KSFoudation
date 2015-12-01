//
//  KSDebugSelectorBasicView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugSelectorBasicView.h"
#import "KSDebugBasicMenuItemView.h"
#import "KSDebugButtonWidthAlgorithm.h"

@interface KSDebugSelectorBasicView ()

@property (nonatomic,assign) CGFloat        selectViewWidth;
@property (nonatomic,assign) NSTimeInterval time;

@end

@implementation KSDebugSelectorBasicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, defaultHeight)];
        [self setupView];
    }
    return self;
}

- (void)dealloc
{
    //add dealloc code
    _scrollView.delegate = nil;
    _scrollView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark setupView method

- (void) setupView {
    
    CGSize newSize = CGSizeMake(self.frame.size.width * 1.1,  self.frame.size.height);
    self.selectViewWidth = newSize.width;
    self.startIndex = 0;
    self.endIndex = 0;
    
    _btnArray = [[NSMutableArray alloc] initWithCapacity:15];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setContentSize:newSize];
    [self addSubview:_scrollView];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 设置selector method

-(void)setButtonWidth:(CGFloat)buttonWidth{
    if (buttonWidth < BUTTON_MIN_WIDTH) {
        _buttonWidth = BUTTON_MIN_WIDTH;
    }else{
        _buttonWidth = buttonWidth;
    }
}

- (void)setPluginCnt:(NSUInteger)pluginCnt defaultIndex:(NSUInteger)defaultIndex{
    // test
    _pluginCnt = pluginCnt;
    _defaultIndex = defaultIndex;
    
    for (UIView * subview in self.subviews) {
        if ([subview isKindOfClass:[KSDebugBasicMenuItemView class]]) {
            [subview removeFromSuperview];
        }
    }
    for (UIView * subview in _scrollView.subviews) {
        if ([subview isKindOfClass:[KSDebugBasicMenuItemView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self.btnArray removeAllObjects];
    
    if (_pluginCnt <= 1) {
        //插件数量小于等于1个不显示插件
        self.hidden = YES;
        return;
    }else{
        self.hidden = NO;
    }
    if (_defaultIndex > _pluginCnt) {
        _defaultIndex = 0;
    }
    
    [self setSelectorFrame:_pluginCnt defaultIndex:_defaultIndex];
    
    //button之间的间距
    self.selectViewWidth = self.sctBorderWidth;
    
    NSInteger i = 0;
    NSInteger end = _pluginCnt;
    //用于特殊需求，主要是账号主页详情里头的pluginSelector需要过滤掉第一个元素
    if (self.startIndex > 0) {
        i = self.startIndex;
    }
    if (self.endIndex > 0) {
        end = self.endIndex;
    }
    
    for (; i < end; i++) {
        KSDebugBasicMenuItemView * btn = nil;
        if (self.itemViewClass) {
            btn = [[self.itemViewClass alloc] init];
        }else{
            btn = [[KSDebugBasicMenuItemView alloc] init];
        }
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnClickedDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnClickedTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [btn addTarget:self action:@selector(btnClickedTouchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [btn setTag:(i - self.startIndex)];
        //设置Selector的属性
        
        [btn setFrame:CGRectMake(self.selectViewWidth, self.sctBorderHeight, self.buttonWidth, self.buttonHeight - 2*self.sctBorderHeight)];
        
        if ((i - self.startIndex) == _defaultIndex) {
            [self setSelectorProperty:btn withIndex:i isSelect:YES];
        }else{
            [self setSelectorProperty:btn withIndex:i isSelect:NO];
        }
        
        [self.btnArray addObject:btn];
        [_scrollView addSubview:btn];
        self.selectViewWidth = self.selectViewWidth + btn.frame.size.width + borderWidth;
    }
    [_scrollView setContentSize:CGSizeMake(self.selectViewWidth , self.frame.size.height)];
    [self didSelectorScrollViewFinished:_scrollView];
}

- (void)setSelectorWithItemArray:(NSArray*)array{
    [self setSelectorWithItemArray:array defaultIndex:0];
}

- (void)setSelectorWithItemArray:(NSArray*)array defaultIndex:(NSUInteger)index{
    if (array == nil || [array count] <= 0 || index >= [array count]) {
        return;
    }
    if (![self needReloadSelector:array]) {
        return;
    }
    self.dataSource = array;
    [self setPluginCnt:[array count] defaultIndex:index];
}

-(BOOL)needReloadSelector:(NSArray*)array{
    if (array == nil) {
        return NO;
    }
    if (self.dataSource == nil) {
        return YES;
    }
    if (self.dataSource == array) {
        return NO;
    }
    return YES;
}

- (void)reloadData{
    for (KSDebugBasicMenuItemView *btn in self.btnArray) {
        NSUInteger index = [self.btnArray indexOfObject:btn];
        if (index == _defaultIndex) {
            [self setSelectorProperty:btn withIndex:index isSelect:YES];
        }else{
            [self setSelectorProperty:btn withIndex:index isSelect:NO];
        }
    }
    [self didSelectorScrollViewFinished:_scrollView];
}

-(void)reloadFrame{
    //重算高度、宽度
    [self setSelectorFrame:_pluginCnt defaultIndex:_defaultIndex];
    self.selectViewWidth = self.sctBorderWidth;
    for (KSDebugBasicMenuItemView *btn in self.btnArray) {
        [btn setFrame:CGRectMake(self.selectViewWidth, self.sctBorderHeight, self.buttonWidth, self.buttonHeight - 2*self.sctBorderHeight)];
        self.selectViewWidth = self.selectViewWidth + btn.frame.size.width + borderWidth;
    }
    [_scrollView setContentSize:CGSizeMake(self.selectViewWidth , self.frame.size.height)];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark btn响应函数
- (void)btnClicked:(id)sender {
    @try {
        if (![sender isKindOfClass:[UIButton class]]) {
            return;
        }
        UIView *view = [sender superview];
        
        if (![view isKindOfClass:[KSDebugBasicMenuItemView class]]) {
            return;
        }
        
        if (!self.btnArray || [self.btnArray count] <= _defaultIndex) {
            return;
        }
        
        KSDebugBasicMenuItemView * btn = (KSDebugBasicMenuItemView * )view;
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 0) animated:YES];
        
        /*******************
         屏蔽点击过快的情况，避免bug
         *******************/
        KSDebugBasicMenuItemView *oldBtn = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:_defaultIndex];
        
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] * 1000;
        if (nowTime - _time <= 300) {
            //避免快速点击切换button
            return;
        }
        self.userInteractionEnabled = NO;
        _time = nowTime;
        
        NSUInteger tag = btn.tag;
        _defaultIndex = tag;
        
        /*******************
         选中新Selector后scrollView控件的表现形式，如露出下一个selector，提升体验
         *******************/
        [self scrollViewActionWithNewItemView:btn withOldItemView:oldBtn];
        
        /*******************
         选中新Selector后的属性更改操作，如改变button的颜色状态
         *******************/
        if ([self itemViewSelected:btn withOldItemView:oldBtn]) {
            /*******************
             选中新Selector后的操作，如调用delegate通知等
             *******************/
            [self itemViewSelected:btn atIndex:(tag + self.startIndex)];
        }
        self.userInteractionEnabled = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"btnClicked crashed");
    }
}

- (void)btnClickedDown:(id)sender{
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIView *view = [sender superview];
    
    if (![view isKindOfClass:[KSDebugBasicMenuItemView class]]) {
        return;
    }
    [self itemViewClickedDown:(KSDebugBasicMenuItemView *)view];
}

- (void)btnClickedTouchCancel:(id)sender{
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIView *view = [sender superview];
    
    if (![view isKindOfClass:[KSDebugBasicMenuItemView class]]) {
        return;
    }
    [self itemViewClickedCancel:(KSDebugBasicMenuItemView *)view];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark pulic method

- (void)setPluginSelectBtn:(NSUInteger)index{
    if (!self.btnArray || [self.btnArray count] <= index || [self.btnArray count] <= _defaultIndex) {
        return;
    }
    KSDebugBasicMenuItemView * btn = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:index];
    KSDebugBasicMenuItemView *oldBtn = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:_defaultIndex];
    
    NSUInteger tag = btn.tag;
    _defaultIndex = tag;
    
    /*******************
     选中新Selector后scrollView控件的表现形式，如露出下一个selector，提升体验
     *******************/
    [self scrollViewActionWithNewItemView:btn withOldItemView:oldBtn];
    
    //新旧btn的操作,由子类完成
    [self itemViewSelected:btn withOldItemView:oldBtn];
}

- (KSDebugBasicMenuItemView*)getSelectorWithIndex:(NSUInteger)index{
    if (!self.btnArray || [self.btnArray count] <= 0 || [self.btnArray count] <= index) {
        return nil;
    }
    return [self.btnArray objectAtIndex:index];
}

- (NSInteger)getIndexWithSelector:(KSDebugBasicMenuItemView*)itemView{
    if (!self.btnArray || [self.btnArray count] <= _defaultIndex) {
        return -1;
    }
    if (itemView && [itemView isKindOfClass:[KSDebugBasicMenuItemView class]] && [self.btnArray containsObject:itemView]) {
        return [self.btnArray indexOfObject:itemView];
    }
    return -1;
}

- (void)reloadSelecorPosition{
    if (!self.btnArray || [self.btnArray count] <= _defaultIndex) {
        return;
    }
    
    KSDebugBasicMenuItemView *nowBtn = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:_defaultIndex];
    
    if (_defaultIndex < [self.btnArray count] - 1 && _defaultIndex > 0) {
        KSDebugBasicMenuItemView *nextItemView = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:(_defaultIndex + 1)];
        [_scrollView scrollRectToVisible:nextItemView.frame animated:NO];
    }else{
        [_scrollView scrollRectToVisible:nowBtn.frame animated:NO];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScollViewDelegate method

//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
}
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    
}
//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
}
//将开始降速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    
}

//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    
}
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCABasicSelectorProtocol method

-(void)setSelectorProperty:(KSDebugBasicMenuItemView*)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    //没有传入过array的话什么也不操作
    return;
}

//设置Selector的长宽属性
-(void)setSelectorFrame:(NSUInteger)pluginCnt defaultIndex:(NSUInteger)defaultIndex{
    self.sctBorderWidth = borderWidth;
    self.sctBorderHeight = borderWidth;
    //button宽与高，默认是算计计算出来的，可以重新设置
    self.buttonWidth = [KSDebugButtonWidthAlgorithm viewDynamicWidthWithNum:(pluginCnt)];
    self.buttonHeight = [KSDebugButtonWidthAlgorithm viewDynamicHeightWithNum:(pluginCnt)];
}

//Selector被选中时触发的事件，返回新选中的itemView与之前的itemView，如果需要做变化就继承该函数
-(BOOL)itemViewSelected:(KSDebugBasicMenuItemView*)itemView withOldItemView:(KSDebugBasicMenuItemView*)oldItemView{
    return YES;
}

//Selector被选中时触发的事件，返回新选中的itemView以及index值
-(void)itemViewSelected:(KSDebugBasicMenuItemView*)itemView atIndex:(NSUInteger)index{
    
}


//Selector被按下时的操作,用于改变按下时的样式
-(void)itemViewClickedDown:(KSDebugBasicMenuItemView*)itemView{
    
}

//Selector被放弃选中时的操作,用于改变放弃时的样式
-(void)itemViewClickedCancel:(KSDebugBasicMenuItemView*)itemView{
    
}

//当Selector的容器SelectorScrollView完成配置后会调用
-(void)didSelectorScrollViewFinished:(UIScrollView*)scrollView{
    
}

-(void)scrollViewActionWithNewItemView:(KSDebugBasicMenuItemView*)itemView withOldItemView:(KSDebugBasicMenuItemView*)oldItemView{
    NSUInteger oldBtnInteger = [self.btnArray indexOfObject:oldItemView];
    NSUInteger newBtnInteger = [self.btnArray indexOfObject:itemView];
    
    CGRect visibleRect = _scrollView.bounds;
    BOOL isSubviewInScrollView = YES;
    if (!CGRectContainsRect(visibleRect, itemView.frame)){
        isSubviewInScrollView = NO;
    }
    if (newBtnInteger >= oldBtnInteger) {
        //如果新按下的selector比之前的selector计数大则露出newBtnInteger后一个selector
        
        if (newBtnInteger < [self.btnArray count] - 1 && isSubviewInScrollView) {
            KSDebugBasicMenuItemView *nextItemView = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:(newBtnInteger + 1)];
            [_scrollView scrollRectToVisible:nextItemView.frame animated:YES];
        }else{
            [_scrollView scrollRectToVisible:itemView.frame animated:YES];
        }
    }else{
        //如果新按下的selector比之前的selector计数小则露出newBtnInteger前一个selector
        if (newBtnInteger > 0 && isSubviewInScrollView) {
            KSDebugBasicMenuItemView *nextItemView = (KSDebugBasicMenuItemView*)[self.btnArray objectAtIndex:(newBtnInteger - 1)];
            [_scrollView scrollRectToVisible:nextItemView.frame animated:YES];
        }else{
            [_scrollView scrollRectToVisible:itemView.frame animated:YES];
        }
    }
}

@end
