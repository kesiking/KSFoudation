//
//  WeAppCycleScrollView.h
//  Taobao2013
//
//  Created by christ.yuj on 13-8-22.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppColorPageControl.h"

@protocol WeAppCycleScrollViewDelegate;
@protocol WeAppCycleScrollViewDatasource;

@interface WeAppCycleScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic,readonly)              UIScrollView*                   scrollView;
@property (nonatomic,readonly)              WeAppColorPageControl*             pageControl;
@property (nonatomic,assign)                NSInteger                       curPage;
@property (nonatomic,assign)                id<WeAppCycleScrollViewDatasource> datasource;
@property (nonatomic,assign)                id<WeAppCycleScrollViewDelegate>   delegate;
@property (nonatomic,assign)                BOOL                            autoScrollEnabled;
@property (nonatomic,assign)                BOOL                            stopScroll;
@property (nonatomic,assign)                BOOL                            isPageControlCenter;
@property (nonatomic,assign)                BOOL                            disablePageClick;
@property (nonatomic,assign)                BOOL                            isPageControlHide;
@property (nonatomic,assign)                NSUInteger                      pagegap;
//只支持奇数扩展
@property (nonatomic, assign)               NSInteger                       curViewCount;
@property (nonatomic, readonly)             NSArray*                        curViews;

- (void)reloadData;

- (void)pageTurn:(NSUInteger)page withAnimated:(BOOL)animated;

@end

@protocol WeAppCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(WeAppCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol WeAppCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages:(WeAppCycleScrollView *)csView;
- (UIView *)csView:(WeAppCycleScrollView *)csView pageAtIndex:(NSInteger)index;

@end
