//
//  WeAppDebugOperationView.m
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "KSDebugOperationView.h"
#import "KSDebugSimpleSelectorScrollView.h"
#import "KSDebugSelectorButton.h"
#import "KSDebugGridView.h"
#import "KSDebugPropertyButton.h"
#import "KSDebugMaroc.h"

#define button_width (44)
#define button_height button_width

@interface KSDebugOperationView() <KSDebugSelectorDelegate, KSDebugSelectorSourceData>

@property (nonatomic, retain) KSDebugPropertyButton             *showAndHideButton;
@property (nonatomic, retain) KSDebugSimpleSelectorScrollView   *selectorView;
@property (nonatomic, retain) NSMutableArray                    *pageButtpns;
@property (nonatomic, retain) NSMutableArray                    *pageViews;

@end

static NSMutableArray *debugViews;

@implementation KSDebugOperationView

+(NSMutableArray*)getDebugViews{
    if (debugViews == nil) {
        debugViews = [[NSMutableArray alloc] init];
    }
    return debugViews;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setupView{
    [self setClipsToBounds:NO];
    
    _pageButtpns = [NSMutableArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"工具介绍",@"title",@"KSDebugEngineInfoTextView",@"className", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"栅格",@"title",@"KSDebugGridView",@"className", nil],nil];
    if ([KSDebugOperationView getDebugViews]) {
        [[KSDebugOperationView getDebugViews] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 isKindOfClass:[NSDictionary class]] && [obj2 isKindOfClass:[NSDictionary class]]) {
                NSString* objClassName1 = [(NSDictionary*)obj1 objectForKey:@"className"];
                NSString* objClassName2 = [(NSDictionary*)obj2 objectForKey:@"className"];
                return [objClassName1 compare:objClassName2];
            }
            return NSOrderedSame;
        }];
        [_pageButtpns addObjectsFromArray:[KSDebugOperationView getDebugViews]];
    }
    
    [_pageButtpns addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"关闭工具",@"title",@"KSDebugCloseView",@"className", nil]];
    
    _pageViews   = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < [_pageButtpns count]; index++) {
        NSDictionary* dic = [_pageButtpns objectAtIndex:index];
        NSString* className = [dic objectForKey:@"className"];
        Class viewClass = NSClassFromString(className);
        if (viewClass) {
            KSDebugBasicView *view = [[viewClass alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            [_pageViews addObject:view];
        }
    }
    [self.showAndHideButton setHidden:NO];
    [self.selectorView setSelectorWithItemArray:_pageButtpns defaultIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugBasicViewDidClosedNotification:) name:KSDebugBasicViewDidClosedNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_pageViews removeAllObjects];
}

-(void)setDebugEnviromeng:(KSDebugEnviroment *)debugEnviromeng{
    [super setDebugEnviromeng:debugEnviromeng];
    for (KSDebugBasicView *basicView in self.pageViews) {
        basicView.debugEnviromeng = debugEnviromeng;
    }
}

-(void)setDebugViewReference:(UIView *)debugViewReference{
    [super setDebugViewReference:debugViewReference];
    for (KSDebugBasicView *basicView in self.pageViews) {
        basicView.debugViewReference = debugViewReference;
    }
    [self.showAndHideButton setReferenceView:debugViewReference];
}

-(KSDebugPropertyButton *)showAndHideButton{
    if (_showAndHideButton == nil) {
        _showAndHideButton = [[KSDebugPropertyButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - button_width, 0, button_width, button_width)];
        [_showAndHideButton setDragEnable:YES];
        [_showAndHideButton setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00,0.4)];
        _showAndHideButton.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
        _showAndHideButton.layer.borderWidth = 1.0;
        _showAndHideButton.layer.masksToBounds = YES;
        _showAndHideButton.layer.cornerRadius = _showAndHideButton.frame.size.width / 2;
        [_showAndHideButton setTitle:@"点" forState:UIControlStateNormal];
        [_showAndHideButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_showAndHideButton addTarget:self action:@selector(showAndHideButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showAndHideButton];
    }
    return _showAndHideButton;
}

-(KSDebugSimpleSelectorScrollView *)selectorView{
    if (!_selectorView) {
        _selectorView = [[KSDebugSimpleSelectorScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - button_width, button_width)];
        _selectorView.backgroundColor = [UIColor clearColor];
        [(UIView*)[_selectorView valueForKey:@"_scrollView"] setBackgroundColor:[UIColor clearColor]];
        _selectorView.sourceDelegate = self;
        _selectorView.delegate = self;
        _selectorView.alpha = 0;
        [self addSubview:_selectorView];
    }
    return _selectorView;
}

-(void)showAndHideButtonClickEvent{
    static BOOL showDebugViews = NO;
    if (showDebugViews) {
        [_showAndHideButton setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00,0.4)];
        _showAndHideButton.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
        [self.showAndHideButton setTitle:@"点" forState:UIControlStateNormal];
        [self.showAndHideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectorView setAlpha:0];
            [self.selectorView setFrame:CGRectMake(CGRectGetMaxX(self.frame), self.selectorView.frame.origin.y, self.selectorView.frame.size.width, self.selectorView.frame.size.height)];
        }];
        showDebugViews = NO;
    }else{
        [_showAndHideButton setBackgroundColor:KSDebugRGB_A(0xff, 0xff, 0xff,0.4)];
        _showAndHideButton.layer.borderColor = KSDebugRGB_A(0x00, 0x00, 0x00, 1.0).CGColor;
        [self.showAndHideButton setTitle:@"点" forState:UIControlStateNormal];
        [self.showAndHideButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.selectorView setAlpha:1];
            [self.selectorView setFrame:CGRectMake(0, self.selectorView.frame.origin.y, self.selectorView.frame.size.width, self.selectorView.frame.size.height)];
        }];
        showDebugViews = YES;
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCASelectorDelegate
//选择一个selector触发事件
-(void)selectorView:(UIView*)selectView didSelectRowAtIndex:(NSUInteger)index{
    NSLog(@"Selected index at %lu",(unsigned long)index);
    if (index >= [self.pageViews count]) {
        return;
    }
    
    for (KSDebugBasicView *basicView in self.pageViews) {
        NSUInteger viewIndex = [self.pageViews indexOfObject:basicView];
        if (viewIndex == index) {
            [basicView startDebug];
        }else{
            [basicView endDebug];
        }
    }
}

//如果选择的是同一个selector
-(void)selectorView:(UIView*)selectView didSelectSameRowAtIndex:(NSUInteger)index{
    NSLog(@"Selected same index at %lu", (unsigned long)index);
    if (index >= [self.pageViews count]) {
        return;
    }
    
    KSDebugSelectorButton * selectorView = (KSDebugSelectorButton*)[self.selectorView getSelectorWithIndex:index];
    if (selectorView && [selectorView isKindOfClass:[KSDebugSelectorButton class]]) {
        if (selectorView.isSelected) {
            [selectorView.imageButton setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.4)];
            selectorView.imageButton.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
            [selectorView.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            selectorView.isSelected = NO;
        }else{
            [selectorView.imageButton setBackgroundColor:KSDebugRGB_A(0xff, 0xff, 0xff, 0.4)];
            selectorView.imageButton.layer.borderColor = KSDebugRGB_A(0x00, 0x00, 0x00, 1.0).CGColor;
            [selectorView.imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            selectorView.isSelected = YES;
        }
    }
    
    KSDebugBasicView *basicView = [self.pageViews objectAtIndex:index];
    
    if (basicView.isDebuging) {
        [basicView endDebug];
    }else{
        [basicView startDebug];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCASelectorSourceData

//设置selector的样式，index是在selectView中第index位置的itemView，isSelect为是否选中

/******************************************************
 该方法主要是初始化时调用的，用于初始化按钮控件的样式
 ******************************************************/
-(void)setSelectorViewProperty:(UIView*)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    if (index >= [self.pageButtpns count]) {
        return;
    }
    if ([itemView isKindOfClass:[UIView class]]) {
        KSDebugSelectorButton * selectorView = (KSDebugSelectorButton*)itemView;
        [selectorView setBackgroundColor:[UIColor clearColor]];
        [selectorView.imageButton setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.4)];
        selectorView.imageButton.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
        [selectorView.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectorView.imageButton.layer.masksToBounds = YES;
        selectorView.imageButton.layer.cornerRadius = 10;
        selectorView.imageButton.layer.borderWidth = 1;
        [selectorView.textLabel setBackgroundColor:[UIColor clearColor]];
        NSDictionary* dic = [self.pageButtpns objectAtIndex:index];
        NSString* title = [dic objectForKey:@"title"];
        [selectorView setTitle:title forState:UIControlStateNormal];
    }
}

-(void)changeSelectorViewProperty:(UIView *)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect{
    if ([itemView isKindOfClass:[UIView class]]) {
        KSDebugSelectorButton * selectorView = (KSDebugSelectorButton*)itemView;
        if (!isSelect) {
            [selectorView.imageButton setBackgroundColor:KSDebugRGB_A(0x00, 0x00, 0x00, 0.4)];
            selectorView.imageButton.layer.borderColor = KSDebugRGB_A(0xff, 0xff, 0xff, 1.0).CGColor;
            [selectorView.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            selectorView.isSelected = NO;
        }else{
            [selectorView.imageButton setBackgroundColor:KSDebugRGB_A(0xff, 0xff, 0xff, 0.4)];
            selectorView.imageButton.layer.borderColor = KSDebugRGB_A(0x00, 0x00, 0x00, 1.0).CGColor;
            [selectorView.imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            selectorView.isSelected = YES;
        }
    }
}

-(void)setSelectorFrame:(UIView*)selectView{
    KSDebugSimpleSelectorScrollView* simpleSelectorScrollView = (KSDebugSimpleSelectorScrollView*)selectView;
    // 设置tabHeadView的每个tabItem的css
    simpleSelectorScrollView.buttonWidth = simpleSelectorScrollView.frame.size.width / 3.5;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint hitPoint = [self convertPoint:point fromView:self];
    BOOL isTextViewInsideHitPoint = CGRectContainsPoint(self.selectorView.frame, hitPoint);
    if (isTextViewInsideHitPoint && [self.selectorView alpha] == 1) {
        return [self.selectorView hitTest:point withEvent:event];
    }
    CGPoint buttonhHitPoint = [self.showAndHideButton convertPoint:point fromView:self];
    if ([self.showAndHideButton pointInside:buttonhHitPoint withEvent:event]) {
        return self.showAndHideButton;
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark observer method

-(void)debugBasicViewDidClosedNotification:(NSNotification*)notification{
    id object = notification.object;
    if ([object isKindOfClass:[KSDebugBasicView class]]) {
        KSDebugBasicView* view = (KSDebugBasicView*)object;
        if (view.isDebuging == NO) {
            NSUInteger index = [self.pageViews indexOfObject:view];
            if (index != NSNotFound) {
                id itemView = [self.selectorView getSelectorWithIndex:index];
                [self changeSelectorViewProperty:self.selectorView itemView:itemView withIndex:index isSelect:NO];
            }
        }
    }
}

@end
