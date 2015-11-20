//
//  KSCollectionViewController.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-24.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSCollectionViewController.h"
#import "KSCollectionViewCell.h"

@interface KSCollectionViewController ()

@property (nonatomic, strong) UICollectionView*    collectionView;

@property (nonatomic, strong) Class                viewCellClass;

@property (nonatomic, assign) CGSize               colletionFooterSize;

@property (nonatomic, assign) CGSize               colletionHeaderSize;

@end

@implementation KSCollectionViewController

@synthesize collectionView = _collectionView;

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
        self.colletionFooterSize = CGSizeZero;
        self.colletionHeaderSize = CGSizeZero;
    }
    return self;
}

-(UIView *)createView {
    if (!_collectionView) {
        [self measureCollectionCellSize];
        //初始化布局类(UICollectionViewLayout的子类)
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = ((KSCollectionViewConfigObject*)self.configObject).minimumLineSpacing;
        flowLayout.minimumInteritemSpacing = ((KSCollectionViewConfigObject*)self.configObject).minimumInteritemSpacing;
        flowLayout.itemSize = ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        [_collectionView registerClass:[KSCollectionViewCell class] forCellWithReuseIdentifier:[KSCollectionViewCell reuseIdentifier]];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KSHeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KSFooterView"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self configPullToRefresh:_collectionView];
        self.canImageRefreshed = YES;
    }
    return _collectionView;
}

-(void)dealloc {
    if (_collectionView) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
        _collectionView = nil;
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self measureCollectionCellSize];
}

-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject{
    if (self.configObject != configObject) {
        self.configObject = configObject;
    }
    [self measureCollectionCellSize];
}

-(void)registerClass:(Class)viewCellClass{
    self.viewCellClass = viewCellClass;
    if (![viewCellClass isSubclassOfClass:[KSViewCell class]]) {
        [WeAppToast toast:[NSString stringWithFormat:@"%s selector %@ must register %@", __func__, NSStringFromClass([self class]), NSStringFromClass([KSViewCell class])]];
    }
}

-(UICollectionView*)getCollectionView{
    return self.collectionView;
}

-(NSMutableArray *)collectionDeleteItems{
    if (_collectionDeleteItems == nil) {
        _collectionDeleteItems = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _collectionDeleteItems;
}

-(void)deleteCollectionCellProccessBlock:(void(^)(NSArray* collectionDeleteItems,KSDataSource* dataSource))proccessBlock completeBolck:(void(^)(void))completeBlock{
    
    if ([self.collectionDeleteItems count] > 0) {
        __block BOOL isCollectionDeleteItemValuable = YES;
        [self.collectionDeleteItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj == nil || ![obj isKindOfClass:[NSIndexPath class]]) {
                *stop = YES;
                isCollectionDeleteItemValuable = NO;
            }
        }];
        if (isCollectionDeleteItemValuable) {
            [self.collectionView performBatchUpdates:^{
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
                [self.collectionView deleteItemsAtIndexPaths:self.collectionDeleteItems];
                
                
            } completion:^(BOOL finished) {
                if (completeBlock) {
                    completeBlock();
                }
            }];
        }
        [self.collectionDeleteItems removeAllObjects];
    }else{
        if (completeBlock) {
            completeBlock();
        }
    }
}

-(void)releaseConstrutView{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    _collectionView = nil;
    [super releaseConstrutView];
}

-(void)refreshData {
    if (self.collectionView == nil) {
        return;
    }
    // 防止grid中出现gridcell没有被设值问题，cellSize有可能会没有被设置正确的宽高，需要加上判断防止crash，多次频繁调用可能crash
    if(CGSizeEqualToSize(CGSizeZero, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize)){
        [self measureCollectionCellSize];
        [((UICollectionViewFlowLayout*)(self.collectionView.collectionViewLayout)) setItemSize:((KSCollectionViewConfigObject*)self.configObject).collectionCellSize];
    }
    [super refreshData];
}

-(void)deleteItemAtIndexs:(NSIndexSet*)indexs{
    [super deleteItemAtIndexs:indexs];
}

-(void)reloadData{
    if (((KSCollectionViewConfigObject*)self.configObject).autoAdjustFrameSize) {
        [self sizeToFit];
    }
    if (!((KSCollectionViewConfigObject*)self.configObject).isEditModel) {
        [self.collectionDeleteItems removeAllObjects];
    }
    [self.collectionView reloadData];
}

-(void)showErrorView:(UIView*)view{
    [self setFootView:view];
}

-(void)hideErrorView:(UIView*)view{
    // 如果当前footView是errorView则清除errorView
    if (view && view == self.colletionFooterView) {
        [self setFootView:nil];
    }
}

-(void)setFootView:(UIView*)view{
    if (view == nil) {
        self.colletionFooterSize = CGSizeZero;
        return;
    }
    if (self.colletionFooterView != view) {
        self.colletionFooterView = view;
        self.colletionFooterSize = self.colletionFooterView.size;
        [self.collectionView reloadData];
    }
}

- (void)loadImagesForOnscreenCells{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *visibleIndexPath in indexPaths) {
        if (visibleIndexPath.row >= 0) {
            KSCollectionViewCell *cell = (KSCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:visibleIndexPath];
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

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return  [self.dataSourceRead count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KSCollectionViewCell *cell = (KSCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[KSCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    //获取cell模板数据
    WeAppComponentBaseItem *componentItem = [self.dataSourceRead getComponentItemWithIndex:[indexPath row]];
    KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
    modelInfoItem.configObject = self.configObject;
    modelInfoItem.cellIndexPath = indexPath;
    
    CGRect rect = CGRectMake(0, 0, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.width, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.height);
    
    if (!cell) {
        cell = [[KSCollectionViewCell alloc] init];
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
        if (collectionView.dragging == NO
            && collectionView.decelerating == NO
            && !modelInfoItem.imageHasLoaded)
        {
            [cell refreshCellImagesWithComponentItem:componentItem extroParams:modelInfoItem];
            modelInfoItem.imageHasLoaded = YES;
        }
        /**/
    }
    
    [self configCollectionView:collectionView withCollectionViewCell:cell cellForItemAtIndexPath:indexPath];
    
    return cell;
}

-(void)configCollectionView:(UICollectionView *)collectionView withCollectionViewCell:(UICollectionViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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

// 4
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.colletionFooterSize;
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.colletionHeaderView?self.colletionHeaderView.size:CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KSHeaderView" forIndexPath:indexPath];
        if (self.colletionHeaderView) {
            if (self.colletionHeaderView.superview == nil) {
                [headerview addSubview:self.colletionHeaderView];
            }else if (self.colletionHeaderView.superview != headerview){
                [self.colletionHeaderView removeFromSuperview];
                [headerview addSubview:self.colletionHeaderView];
            }
        }
        
        reusableview = headerview;
    }else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KSFooterView" forIndexPath:indexPath];
        if (self.colletionFooterView) {
            if (self.colletionFooterView.superview == nil) {
                [footerview addSubview:self.colletionFooterView];
            }else if (self.colletionFooterView.superview != footerview){
                [self.colletionFooterView removeFromSuperview];
                [footerview addSubview:self.colletionFooterView];
            }
        }
        
        reusableview = footerview;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    KSCollectionViewCell *cell = (KSCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
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
    if (self.collectionViewDidSelectedBlock) {
        self.collectionViewDidSelectedBlock(collectionView,indexPath,self.dataSourceRead,(KSCollectionViewConfigObject*)self.configObject);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

//1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(CGSizeEqualToSize(CGSizeZero, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize)){
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        return CGSizeMake(modelInfoItem.frame.size.width * SCREEN_SCALE, modelInfoItem.frame.size.height * SCREEN_SCALE);
    }else if(((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.height == 0){
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        return CGSizeMake(((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.width, modelInfoItem.frame.size.height * SCREEN_SCALE);
    }else if(((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.width == 0){
        KSCellModelInfoItem* modelInfoItem = [self.dataSourceRead getComponentModelInfoItemWithIndex:[indexPath row]];
        return CGSizeMake(modelInfoItem.frame.size.width * SCREEN_SCALE, ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize.height);
    }
    return ((KSCollectionViewConfigObject*)self.configObject).collectionCellSize;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)measureCollectionCellSize{
    KSCollectionViewConfigObject* configObject = ((KSCollectionViewConfigObject*)self.configObject);
    if (configObject.collectionColumn > 0
        && !CGRectEqualToRect(CGRectZero, self.frame)
        && self.frame.size.width > 0) {
        CGFloat width = 0;
        if(self.frame.size.width > 0)
            width = self.frame.size.width / configObject.collectionColumn;
        else
            width = SCREEN_WIDTH / configObject.collectionColumn;
        
        if (width > 0) {
            configObject.collectionCellSize = CGSizeMake(width - (configObject.collectionColumn - 1) * configObject.minimumInteritemSpacing / configObject.collectionColumn, configObject.collectionCellSize.height);
        }
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
        [self measureCollectionCellSize];
        if (configObject.collectionColumn >= 1) {
            NSUInteger gridNum = [self.dataSourceRead count]/configObject.collectionColumn + (NSUInteger)(([self.dataSourceRead count]%configObject.collectionColumn) == 0?0:1);
            totleHeight = gridNum * configObject.collectionCellSize.height;
        }else{
            CGFloat width = configObject.collectionCellSize.width > 0 ? configObject.collectionCellSize.width: self.collectionView.width;
            if (width == 0) {
                width = SCREEN_WIDTH;
            }
            CGFloat collectionColumn = self.collectionView.width / width;
            if (collectionColumn == 0) {
                collectionColumn = 1;
            }
            NSUInteger gridNum = [self.dataSourceRead count] / collectionColumn;
            totleHeight = gridNum * configObject.collectionCellSize.height;
        }
        
        if (totleHeight > 0) {
            CGRect rect = self.collectionView.frame;
            CGRect oldFrame = rect;
            rect.size.height = totleHeight;
            [self setFrame:rect];
            
            if (self.scrollViewFrameSizeToFitDidFinished) {
                self.scrollViewFrameSizeToFitDidFinished(self, rect, oldFrame);
            }
        }
    }
}

@end
