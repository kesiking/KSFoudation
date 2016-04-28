//
//  KSScrollViewServiceController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-23.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewController.h"
#import "KSScrollViewConfigObject.h"

@class KSScrollViewServiceController;
@class KSViewCell;

/*!
 *  @author 孟希羲, 15-11-19 09:11:14
 *
 *  @brief scrollViewOnRefreshEvent及scrollViewOnNextEvnet，用于下拉刷新及翻页时回调的block
 *
 *  @param scrollViewController 当前KSScrollViewServiceController实例
 *
 *  @since 1.0
 */
typedef void (^ scrollViewOnRefreshEvent)(KSScrollViewServiceController* scrollViewController);
typedef void (^ scrollViewOnNextEvnet)(KSScrollViewServiceController* scrollViewController);

/*!
 *  @author 孟希羲, 15-11-19 09:11:56
 *
 *  @brief scrollViewConfigPullToRefreshView用于自定义下拉刷新的pullToRefreshView样式
 *
 *  @param scrollView        当前拥有的scrollView
 *  @param pullToRefreshView 当前scrollView的pullToRefreshView
 *
 *  @since 1.0
 */
typedef void (^ scrollViewConfigPullToRefreshView)(UIScrollView* scrollView, SVPullToRefreshView* pullToRefreshView);

/*!
 *  @author 孟希羲, 15-11-18 14:11:35
 *
 *  @brief  viewCellConfigBlock 当viewCell生成或是重用时需要重新设置时被调用，例如tableView的tableView:cellForRowAtIndexPath:方法调用时会调用该block，使用者可以利用该block自定义viewCell的属性及样式
 *
 *  @param viewCell      当前indexPath对应的viewCell
 *  @param componentItem 当前indexPath对应的componentItem
 *  @param modelInfoItem 当前indexPath对应的modelInfoItem
 *  @param indexPath     当前indexPath
 *  @param dataSource    当前KSScrollViewServiceController的dataSource
 *
 *  @since 1.0
 */
typedef void(^viewCellConfigBlock) (KSViewCell* viewCell, WeAppComponentBaseItem *componentItem, KSCellModelInfoItem* modelInfoItem, NSIndexPath* indexPath,KSDataSource* dataSource);

/*!
 *  @author 孟希羲, 15-11-18 14:11:14
 *
 *  @brief scrollViewFrameSizeToFitDidFinished 当KSScrollViewServiceController被调用sizeToFit时会触发其计算宽高，当宽高计算完成后会回调该block，表示计算并更新frame完毕，使用者可以利用该block动态改变自身的高度
 *
 *  @param scrollViewController 当前的KSScrollViewController
 *  @param newFrame             新的frame大小
 *  @param oldFrame             老的frame大小
 *
 *  @since 1.0
 */
typedef void(^scrollViewFrameSizeToFitDidFinished)(KSScrollViewServiceController* scrollViewController, CGRect newFrame, CGRect oldFrame);

@interface KSScrollViewServiceController : KSScrollViewController<WeAppBasicServiceDelegate>

// 属性配置实例，用于初始化KSScrollViewServiceController。-initWithConfigObject:
@property (nonatomic, strong) KSScrollViewConfigObject*     configObject;
// service用于下拉刷新及翻页操作
@property (nonatomic, strong) WeAppBasicService*            service;
// 错误页面errorView的文案描述
@property (nonatomic, strong) NSString*                     errorViewTitle;
// 翻页nextFootView的文案描述
@property (nonatomic, strong) NSString*                     nextFootViewTitle;
// 没有下一页view的文案描述
@property (nonatomic, strong) NSString*                     hasNoDataFootViewTitle;
// 翻页展示
@property (nonatomic, strong) UIView*                       nextFootView;
// 错误页面
@property (nonatomic, strong) UIView*                       errorView;
// 上下文，用于scrollViewController传递给viewCell之间数据的沟通桥梁
@property (nonatomic, strong) id                            scrollViewControllerContext;

@property (nonatomic, copy)   scrollViewOnRefreshEvent      onRefreshEvent;

@property (nonatomic, copy)   scrollViewOnNextEvnet         onNextEvent;

@property (nonatomic, copy)   viewCellConfigBlock           viewCellConfigBlock;

@property (nonatomic, copy)   scrollViewConfigPullToRefreshView         scrollViewConfigPullToRefreshView;

@property (nonatomic, copy)   scrollViewFrameSizeToFitDidFinished       scrollViewFrameSizeToFitDidFinished;

-(instancetype)initWithConfigObject:(KSScrollViewConfigObject*)configObject;

// 配置下拉刷新
-(void)configPullToRefresh:(UIScrollView*)scrollView;

// override subclass 下拉刷新service
-(void)refresh;

// override subclass 翻页service
-(void)nextPage;

// override subclass 是否需要翻页
-(BOOL)needNextPage;

// override subclass 根据service状态判断是否可以翻页
-(BOOL)canNextPage;

// override subclass 设置footView 翻页时提醒
-(void)setFootView:(UIView*)view;

// override subclass 设置errorView 翻页时提醒
-(void)showErrorView:(UIView*)view;

-(void)hideErrorView:(UIView*)view;

// override subclass 设置errorView 错误时展示
-(UIView*)getErrorView;

// override subclass 是否需要footView
-(BOOL)needFootView;

// override subclass 数据返回后回调用refreshData，最后会调用reloadData接口
-(void)refreshData;

// override subclass 删除数据dataSource中的数据，调用dataSource的deleteItemAtIndexs接口
-(void)deleteItemAtIndexs:(NSIndexSet*)indexs;

// override subclass 用于配置scrollView的pullToRefreshView
-(void)configPullToRefreshViewStatus:(UIScrollView *)scrollView;

@end
