//
//  HSBaseTableView.m
//  HSOpenPlatform
//
//  Created by xtq on 15/10/16.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSBaseTableView.h"
#import "WeAppLoadingView.h"

@interface HSBaseTableView ()

@property (nonatomic, strong) WeAppLoadingView                  *refreshPageLoadingView;

@property (nonatomic, assign) NSInteger       previousPage;        //!< 记录reload之前的页码，为reloadFail的情况作还原

@property (nonatomic, assign) BOOL            isFirstReloading;    //!< 是否第一次的默认加载

@property (nonatomic, strong) NSString       *emptyDataTitle;      //!< 空数据的提示文案

@property (nonatomic, strong) NSString       *noMoreDataTitle;     //!< 全部数据加载完毕的提示文案

@property (nonatomic, strong) NSString       *loadFialTitle;       //!< 空数据的提示文案

@end

@implementation HSBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.currentPage        = 1;
        self.previousPage       = 1;
        self.offset             = 10;
        
        self.dataSource         = self;
        self.delegate           = self;
        
        self.needRefreshHeader  = NO;
        self.needLoadMoreFooter = NO;
        self.isFirstReloading   = YES;
        
        self.emptyDataTitle     = @"暂无数据";
        self.noMoreDataTitle    = @"已经全部加载完毕";
        self.loadFialTitle      = @"下拉加载";

        self.backgroundColor = EH_bgcor1;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc]init];

        self.dataArray = [[NSMutableArray alloc]init];
        self.cellClass = [UITableViewCell class];
        self.cellFillStyle = UICellFillStyleInRows;
    }
    return self;
}

- (void)reloadData {
    [super reloadData];
    [self updateTableViewState];
}

#pragma mark - Common Methods
- (void)refreshData {
    self.currentPage = 1;
}

- (void)loadMoreData {
    self.currentPage++;
}

- (void)reloadFail {
    if (self.header.isRefreshing) {
        [self.header endRefreshing];
        if (self.dataArray.count == 0) {
            //为空数据时加载失败添加提示
            [(MJRefreshAutoNormalFooter *)self.footer setTitle:self.loadFialTitle forState:MJRefreshStateNoMoreData];
        }
    }
    if (self.footer.isRefreshing) {
        [self.footer endRefreshing];
    }
    self.currentPage = self.previousPage;
}

- (void)beginRefreshing {
    [self.header beginRefreshing];
}

/**
 *  更新tableView状态
 */
- (void)updateTableViewState{
    if (!self.footer) {
        return;
    }
    //由于重载了tableView的reloadData方法，对默认的第一次初始化操作简略化
    if (self.isFirstReloading) {
        self.isFirstReloading = NO;
        [(MJRefreshAutoNormalFooter *)self.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [self.footer noticeNoMoreData];
        return;
    }
    
    if ([self.header isRefreshing]) {
        [self.header endRefreshing];
        self.currentPage = 1;
        
        [self updateFooterStateAfterRefreshing];
    }
    
    else if ([self.footer isRefreshing]) {
        [self updateFooterStateAfterLoadingMore];
    }
    self.previousPage = self.currentPage;
}

- (void)updateFooterStateAfterRefreshing {
    if (self.dataArray.count == 0) {
        [(MJRefreshAutoNormalFooter *)self.footer setTitle:self.emptyDataTitle forState:MJRefreshStateNoMoreData];
        [self.footer noticeNoMoreData];
    }
    else {
        if (self.dataArray.count % self.offset == 0) {
            if (self.needLoadMoreFooter) {
                [self.footer endRefreshing];
            }
        }
        else {
            if (self.needLoadMoreFooter) {
                [(MJRefreshAutoNormalFooter *)self.footer setTitle:self.noMoreDataTitle forState:MJRefreshStateNoMoreData];
            }
            else {
                [(MJRefreshAutoNormalFooter *)self.footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            }
            [self.footer noticeNoMoreData];
        }
    }
}

- (void)updateFooterStateAfterLoadingMore {
    if (self.dataArray.count == self.offset || self.dataArray.count % self.offset != 0) {
        [(MJRefreshAutoNormalFooter *)self.footer setTitle:self.noMoreDataTitle forState:MJRefreshStateNoMoreData];
        [self.footer noticeNoMoreData];
    }
    else {
        [self.footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = (self.cellFillStyle == UICellFillStyleInRows?1:self.dataArray.count);
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = (self.cellFillStyle == UICellFillStyleInRows?self.dataArray.count:1);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self.cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *selectorName = @"setModel:";
    NSInteger index = (self.cellFillStyle == UICellFillStyleInRows?indexPath.row:indexPath.section);
    NSObject *model = self.dataArray[index];
    if ([cell respondsToSelector:NSSelectorFromString(selectorName)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:NSSelectorFromString(selectorName) withObject:model];
#pragma clang diagnostic pop
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?0.01:caculateNumber(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Gettres And Setters
- (void)setNeedRefreshHeader:(BOOL)needRefreshHeader {
    _needRefreshHeader = needRefreshHeader;
    if (needRefreshHeader) {
        [self setRefreshHeaderOnTableView:self];
    }
    else {
        self.header = nil;
        if (!self.needLoadMoreFooter) {
            self.footer = nil;
        }
    }
}

- (void)setNeedLoadMoreFooter:(BOOL)needLoadMoreFooter {
    _needLoadMoreFooter = needLoadMoreFooter;
    if (needLoadMoreFooter) {
        [self setLoadMoreFooterOnTableView:self];
    }
}

- (void)setRefreshHeaderOnTableView:(UITableView *)tableview {
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    // 设置文字
//    [header setTitle:@"下拉加载更多" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在加载数据中 ..." forState:MJRefreshStateRefreshing];
//    header.lastUpdatedTimeLabel.hidden = YES;
    self.refreshPageLoadingView.center = CGPointMake(tableview.width/2.0, self.refreshPageLoadingView.height / 2.0 + 5);
    [header addSubview:self.refreshPageLoadingView];
    
    tableview.header = header;
    
    //当只有下拉时，也添加footer作为提示文案载体
    if (!self.footer) {
        tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil];
    }
}

- (void)setLoadMoreFooterOnTableView:(UITableView *)tableview {
    tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(WeAppLoadingView *)refreshPageLoadingView{
    if (_refreshPageLoadingView == nil) {
        _refreshPageLoadingView = [[WeAppLoadingView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        _refreshPageLoadingView.loadingView.circleColor = [UIColor blackColor];
        _refreshPageLoadingView.loadingViewType = WeAppLoadingViewTypeCircel;
    }
    return _refreshPageLoadingView;
}

@end
