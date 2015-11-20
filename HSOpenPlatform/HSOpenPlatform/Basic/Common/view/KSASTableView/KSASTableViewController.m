//
//  KSASTableViewController.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_AsyncDisplayKit

#import "KSASTableViewController.h"
#import "KSASTableViewCellNode.h"

@interface KSASTableViewController ()

@property (nonatomic, strong) ASTableView*         tableView;

@property (nonatomic, strong) Class                viewCellClass;

@end

@implementation KSASTableViewController

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
        _tableView = [[ASTableView alloc] initWithFrame:self.frame];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self configPullToRefresh:_tableView];
        
        self.canImageRefreshed = YES;
    }
    return _tableView;
}

-(void)dealloc {
    if (_tableView) {
        _tableView.asyncDelegate = nil;
        _tableView.asyncDataSource = nil;
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
    if (![viewCellClass isSubclassOfClass:[KSViewCellNode class]]) {
        [WeAppToast toast:[NSString stringWithFormat:@"%s selector %@ must register %@", __func__, NSStringFromClass([self class]), NSStringFromClass([KSViewCellNode class])]];
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
            [self.tableView deleteRowsAtIndexPaths:self.collectionDeleteItems withRowAnimation:UITableViewRowAnimationAutomatic];
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
    NSArray *visibleNodes = [self.tableView visibleNodes];
    for (KSASTableViewCellNode *visibleNode in visibleNodes) {
        if (visibleNode.cellView.indexPath != nil) {
            WeAppComponentBaseItem* componentItem = [self.dataSourceRead getComponentItemWithIndex:[visibleNode.cellView.indexPath row]];
            KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[visibleNode.cellView.indexPath row]];
            [visibleNode refreshCellImagesWithComponentItem:componentItem extroParams:modelInfoItem];
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

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSASTableViewCellNode *tableViewCellcellNode = [KSASTableViewCellNode new];
    tableViewCellcellNode.backgroundColor = [UIColor clearColor];
    
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
    
    //保证cell中的可以重用
    if (componentItem) {
        [tableViewCellcellNode setViewCellClass:self.viewCellClass];
        [tableViewCellcellNode setScrollViewCtl:self];
        [tableViewCellcellNode configCellWithFrame:rect componentItem:componentItem extroParams:modelInfoItem];
    }
    
    return tableViewCellcellNode;
}

- (void)tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath{
    KSASTableViewCellNode* tableViewCellcellNode = (KSASTableViewCellNode*)[tableView nodeForRowAtIndexPath:indexPath];
    [self configTableView:tableView withCollectionViewCell:tableViewCellcellNode cellForItemAtIndexPath:indexPath];
}

-(void)configTableView:(ASTableView *)tableView withCollectionViewCell:(KSASTableViewCellNode*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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

// 用于展示加载动画
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![tableView isKindOfClass:[ASTableView class]]) {
        return;
    }
    ASTableView* KSASTableView = (ASTableView*)tableView;
    KSASTableViewCellNode* tableViewCellNode = (KSASTableViewCellNode*)[KSASTableView nodeForRowAtIndexPath:indexPath];
    if (tableViewCellNode) {
        //获取cell模板数据
        WeAppComponentBaseItem *componentItem = [self.dataSourceRead getComponentItemWithIndex:[indexPath row]];
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.configObject);
        if (configObject.isEditModel) {
            [tableViewCellNode configDeleteCellAtIndexPath:indexPath componentItem:componentItem extroParams:modelInfoItem];
        }else{
            [tableViewCellNode didSelectItemWithComponentItem:componentItem extroParams:modelInfoItem];
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
        && configObject.needQueueLoadData == NO
        && [self.dataSourceRead count] > 0) {
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
        
        if (totleHeight > 0) {
            CGRect rect = self.tableView.frame;
            rect.size.height = totleHeight;
            [self setFrame:rect];
        }
    }
}

@end

#endif
