//
//  KSTableViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-26.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSTableViewController.h"
#import "WeAppTableViewCell.h"

@interface KSTableViewController ()

@property (nonatomic, strong) UITableView*         tableView;

@property (nonatomic, strong) Class                viewCellClass;

@end

@implementation KSTableViewController

@synthesize tableView = _tableView;

-(instancetype)initWithFrame:(CGRect)frame withConfigObject:(KSCollectionViewConfigObject*)configObject{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.configObject = configObject;
        self.scrollView = (UIScrollView*)[self createView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
    [configObject setupStandConfig];
    self = [self initWithFrame:frame withConfigObject:configObject];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithConfigObject:(KSScrollViewConfigObject *)configObject{
    self = [super initWithConfigObject:configObject];
    if (self) {
        self.configObject = configObject;
        self.scrollView = (UIScrollView*)[self createView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.scrollView = (UIScrollView*)[self createView];
    }
    return self;
}

-(UIView *)createView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self configPullToRefresh:_tableView];
        
        self.canImageRefreshed = YES;
    }
    return _tableView;
}

-(void)dealloc {
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableView = nil;
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject{
    if (self.configObject != configObject) {
        self.configObject = configObject;
    }
}

-(void)registerClass:(Class)viewCellClass{
    self.viewCellClass = viewCellClass;
    if (![viewCellClass isSubclassOfClass:[KSViewCell class]]) {
        [WeAppToast toast:[NSString stringWithFormat:@"%s selector %@ must register %@", __func__, NSStringFromClass([self class]), NSStringFromClass([KSViewCell class])]];
    }
}

-(UITableView*)getTableView{
    return self.tableView;
}

-(NSMutableArray *)collectionDeleteItems{
    if (_collectionDeleteItems == nil) {
        _collectionDeleteItems = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _collectionDeleteItems;
}

-(void)deleteCollectionCellProccessBlock:(tableViewDeleteProgressBlock)proccessBlock completeBolck:(tableViewDeleteCompleteBlock)completeBlock{
    
    if ([self.collectionDeleteItems count] > 0) {
        __block BOOL isCollectionDeleteItemValuable = YES;
        [self.collectionDeleteItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj == nil || ![obj isKindOfClass:[NSIndexPath class]]) {
                *stop = YES;
                isCollectionDeleteItemValuable = NO;
            }
        }];
        if (isCollectionDeleteItemValuable) {
            [self.tableView beginUpdates];
            // Delete the items with proccessBlock.
            if (proccessBlock) {
                proccessBlock(self.collectionDeleteItems,self.dataSourceRead);
            }
            // Delete the items from the data source.
            NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
            [self.collectionDeleteItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath* indexPath = obj;
                [indexSet addIndex:[indexPath row]];
            }];
            [self deleteItemAtIndexs:indexSet];
            // Now delete the items from the collection view.
            [self.tableView deleteRowsAtIndexPaths:self.collectionDeleteItems withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            if (completeBlock) {
                completeBlock();
            }
        }
        [self.collectionDeleteItems removeAllObjects];
    }else{
        if (completeBlock) {
            completeBlock();
        }
    }
}

-(void)refreshData {
    if (self.tableView == nil) {
        return;
    }
    [super refreshData];
}

-(void)reloadData{
    if (((KSCollectionViewConfigObject*)self.configObject).autoAdjustFrameSize) {
        [self sizeToFit];
    }
    if (!((KSCollectionViewConfigObject*)self.configObject).isEditModel) {
        [self.collectionDeleteItems removeAllObjects];
    }
    [self.tableView reloadData];
}

-(void)showErrorView:(UIView*)view{
    [self setTableFooterView:view];
}

-(void)hideErrorView:(UIView*)view{
    // 如果当前footView是errorView则清除errorView
    if (view && view == self.tableView.tableFooterView) {
        [self setTableFooterView:nil];
    }
}

-(void)setFootView:(UIView*)view{
    [self setTableFooterView:view];
}

-(void)setTableFooterView:(UIView *)tableFooterView{
    if (tableFooterView != self.tableView.tableFooterView) {
        self.tableView.tableFooterView = nil;
    }
    self.tableView.tableFooterView = tableFooterView;
}

-(void)setTableHeaderView:(UIView *)tableHeaderView{
    if (tableHeaderView != self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = nil;
    }
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)loadImagesForOnscreenCells{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleIndexPath in indexPaths) {
        if (visibleIndexPath.row >= 0) {
            WeAppTableViewCell *cell = (WeAppTableViewCell *)[self.tableView cellForRowAtIndexPath:visibleIndexPath];
            BOOL imageLoaded = [self.dataSourceRead getImageDidLoadedWithIndex:[visibleIndexPath row]];
            //如果imageLoaded标志位不存在或是为NO则刷新，如果canImageRefreshed被设为NO，表示速度过快优化后不再加载图片，因此也需要刷新
            if(!imageLoaded || self.canImageRefreshed){
                WeAppComponentBaseItem* componentItem = [self.dataSourceRead getComponentItemWithIndex:[visibleIndexPath row]];
                KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[visibleIndexPath row]];
                [cell refreshCellImagesWithComponentItem:componentItem extroParams:modelInfoItem];
                modelInfoItem.imageHasLoaded = YES;
            }
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceRead count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeAppTableViewCell *cell = (WeAppTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WeAppTableViewCell reuseIdentifier]];
    
    //获取cell模板数据
    WeAppComponentBaseItem *componentItem = [self.dataSourceRead getComponentItemWithIndex:[indexPath row]];
    KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
    modelInfoItem.configObject = self.configObject;
    modelInfoItem.cellIndexPath = indexPath;
    
    CGRect rect = CGRectZero;
    if(CGSizeEqualToSize(CGSizeZero, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize)){
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        rect = CGRectMake(0, 0, self.tableView.width, (modelInfoItem.frame.size.height));
    }else{
        rect = CGRectMake(0, 0, self.tableView.width, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.height);
    }
    
    if (!cell) {
        cell = [WeAppTableViewCell createCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    //保证cell中的可以重用
    if (componentItem) {
        [cell setViewCellClass:self.viewCellClass];
        [cell setScrollViewCtl:self];
        [cell configCellWithFrame:rect componentItem:componentItem extroParams:modelInfoItem];
        if (self.viewCellConfigBlock) {
            self.viewCellConfigBlock(cell.cellView, componentItem, modelInfoItem, indexPath, self.dataSourceRead);
        }
    }
    
    if (self.canImageRefreshed && [self needQueueLoadData]) {
        //当UItableViewCell还没有图像信息的时候
        //table停止不再滑动的时候下载图片（先用默认的图片来代替Cell的image）
        /**/
        // 因为性能问题先注释
        if (tableView.dragging == NO
            && tableView.decelerating == NO
            && !modelInfoItem.imageHasLoaded)
        {
            [cell refreshCellImagesWithComponentItem:componentItem extroParams:modelInfoItem];
            modelInfoItem.imageHasLoaded = YES;
        }
        /**/
    }
    
    [self configTableView:tableView withCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
    
    
    return cell;
}

-(void)configTableView:(UITableView *)tableView withCollectionViewCell:(UITableViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 结束reload
    /**********************************************************************
     翻页逻辑，grid的scroll滑动导致一下子会翻页多屏幕数据
     **********************************************************************/
    /**************************/
    if ([indexPath row] >= [self.dataSourceRead count] - 1) {
        if ([self canNextPage]) {
            [self nextPage];
        }
    }
    /**************************/
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource editTableView
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((KSCollectionViewConfigObject*)self.configObject).isTableViewCellEditingStyleDelete;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray* collectionDeleteItems = [NSArray arrayWithObject:indexPath];
        // Delete the items with proccessBlock.
        if (self.tableViewDeleteProgressBlock) {
            self.tableViewDeleteProgressBlock(collectionDeleteItems,self.dataSourceRead);
        }
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[indexPath row]];
        [self deleteItemAtIndexs:indexSet];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.tableViewDeleteCompleteBlock) {
            self.tableViewDeleteCompleteBlock();
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(CGSizeEqualToSize(CGSizeZero, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize)){
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        return (modelInfoItem.frame.size.height);
    }
    return ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.height;
}

// 用于展示加载动画
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeAppTableViewCell *cell = (WeAppTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        //获取cell模板数据
        WeAppComponentBaseItem *componentItem = [self.dataSourceRead getComponentItemWithIndex:[indexPath row]];
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.configObject);
        if (configObject.isEditModel) {
            [cell configDeleteCellAtIndexPath:indexPath componentItem:componentItem extroParams:modelInfoItem];
        }else{
            [cell didSelectItemWithComponentItem:componentItem extroParams:modelInfoItem];
        }
    }
    if (self.tableViewDidSelectedBlock) {
        self.tableViewDidSelectedBlock(tableView,indexPath,self.dataSourceRead,(KSCollectionViewConfigObject*)self.configObject);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - sizeToFit
// 自使用高度，配合autoAdjustFrameSize使用，autoAdjustFrameSize为YES时表示高度由cell的个数决定，目前sizeToFit只支持collectionSize为一样宽高的情况
-(void)sizeToFit{
    KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.configObject);
    
    if (configObject.autoAdjustFrameSize == YES
        && configObject.needNextPage == NO
        && configObject.needQueueLoadData == NO) {
        CGFloat totleHeight = 0;
        
        if (self.tableHeaderView) {
            totleHeight += self.tableHeaderView.height;
        }
        
        for (NSUInteger index = 0; index < [self.dataSourceRead count] ; index++ ) {
            KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:index];
            if (modelInfoItem.frame.size.height > 0) {
                totleHeight += modelInfoItem.frame.size.height;
            }else{
                totleHeight += configObject.collectionCellSize.height;
            }
        }
        
        if (self.tableFooterView) {
            totleHeight += self.tableFooterView.height;
        }
        
        CGRect rect = self.tableView.frame;
        CGRect oldFrame = rect;
        rect.size.height = totleHeight;
        [self setFrame:rect];
        if (self.scrollViewFrameSizeToFitDidFinished) {
            self.scrollViewFrameSizeToFitDidFinished(self, rect, oldFrame);
        }
    }
}

@end
