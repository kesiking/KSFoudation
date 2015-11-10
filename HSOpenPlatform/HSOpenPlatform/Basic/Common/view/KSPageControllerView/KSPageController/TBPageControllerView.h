//
//  TBPageControllerView.h
//  TBWeApp
//
//  Created by 逸行 on 14-3-21.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBPageControl.h"

@class TBPageControllerView;

@protocol TBPageControlViewDelegate <NSObject>

- (NSUInteger)numberOfSectionsInPageControlView:(UIView*)pageControlView;
- (UIControl*)TBPageControlView:(UIView*)pageControlView atIndex:(NSUInteger)itemIndex;
@optional

-(void)TBPageControlView:(UIView*)pageControlView willShowViewAtIndex:(NSUInteger)itemIndex;

-(void)TBPageControlView:(UIView*)pageControlView didShowViewAtIndex:(NSUInteger)itemIndex;

-(void)TBPageControlView:(UIView*)pageControlView scrollViewDidScroll:(UIScrollView *)scrollView withScollViewPage:(NSUInteger)page;

-(void)TBPageControlView:(UIView*)pageControlView refreshPage:(int)index;

@end


@interface TBPageControllerView : UIView<UIScrollViewDelegate,WeAppPageControlProtocol>
@property (nonatomic,retain) UIScrollView                  *scrollView;
@property (nonatomic,weak)   id<TBPageControlViewDelegate>  delegate;
@property (nonatomic,assign) BOOL                           showPageControl;
@property (nonatomic,assign) BOOL                           autoScroll;
@property (nonatomic,assign) BOOL                           isLazyLoadOpen;
//是否为水平方向翻页，默认为YES，置为NO则表示竖直方向翻页
@property (nonatomic,assign) BOOL                    isScrollViewHorizontal;

-(void)reloadData;

-(NSUInteger)getNumberOfPages;

-(void)setCurrentPage:(NSUInteger)page;
-(NSUInteger)getCuttentPage;

-(void)resetPageControlView;

-(void)refreshPage:(int)index;
-(void)refreshAllPages;

//滚图的动画效果
-(void)pageTurn:(NSUInteger)index withAnimated:(BOOL)animated;
-(void)pageTurnNextPageWithAnimated:(BOOL)animated;

@end

#pragma mark -
#pragma mark WeAppPointPageControllerView

@interface WeAppPointPageControllerView : TBPageControllerView

-(CGRect)getPageControlPosition;

-(void)setPageControlPosition:(CGRect)position;

-(void)setPageControlPointColor:(UIColor*)normal andSelectedColor:(UIColor*)current;

@end

//-----------------------------------

#pragma mark -
#pragma mark WeAppAutoPointPageControllerView

@interface WeAppAutoPointPageControllerView : WeAppPointPageControllerView

-(void)setTimeInterval:(long)seconds;

-(void)cancelTimer;

@end
