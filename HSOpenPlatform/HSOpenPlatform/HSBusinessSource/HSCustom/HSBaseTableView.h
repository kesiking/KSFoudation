//
//  HSBaseTableView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/16.
//  Copyright © 2015年 孟希羲. All rights reserved.
//  封装了下拉刷新和上拉加载翻页的UITableView

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICellFillStyle) {
    UICellFillStyleInRows = 0,  //!< 填充在一列row中,默认
    UICellFillStyleInSections,  //!< 填充在一列section中
};


@interface HSBaseTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;            //!< 数据源


@property (nonatomic, strong) Class           cellClass;            //!< 可用来注册cell的类型，cell配置model的模式为设置“model”属性，在setModel:方法中配置。


@property (nonatomic, assign)UICellFillStyle cellFillStyle;         //cell填充样式

#pragma mark - 配置下拉刷新和下拉加载
@property (nonatomic, assign) BOOL            needRefreshHeader;    //!< 是否需要下拉刷新控件

@property (nonatomic, assign) BOOL            needLoadMoreFooter;   //!< 是否需要上拉加载控件

@property (nonatomic, assign) NSInteger       currentPage;          //!< 当前页

@property (nonatomic, assign) NSInteger       offset;               //!< 每页数据数量，默认10

- (void)refreshData;                                                //!< 下拉刷新操作

- (void)loadMoreData;                                               //!< 上拉加载操作

- (void)reloadFail;                                                 //!< 刷新或加载失败

- (void)beginRefreshing;                                            //!< 自动开始刷新

- (void)updateTableViewState;                                       //!< 更新刷新、加载状态，reloadData会自动调用

@end
