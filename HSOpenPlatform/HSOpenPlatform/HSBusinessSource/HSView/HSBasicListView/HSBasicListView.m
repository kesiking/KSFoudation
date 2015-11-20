//
//  HSBasicListView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/24.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSBasicListView.h"

@interface HSBasicListView()

@property (nonatomic,strong) KSDataSource*                  dataSourceRead;

@property (nonatomic,strong) KSDataSource*                  dataSourceWrite;

@property (nonatomic,assign) HSBasicListViewType            basicListViewType;

@end

@implementation HSBasicListView

-(instancetype)initWithFrame:(CGRect)frame withBasicListViewType:(HSBasicListViewType)basicListViewType{
    self = [super initWithFrame:frame];
    if (self) {
        self.basicListViewType = basicListViewType;
        [self configBasicListView];
    }
    return self;
}

-(instancetype)initWithBasicListViewType:(HSBasicListViewType)basicListViewType{
    self = [super init];
    if (self) {
        self.basicListViewType = basicListViewType;
        [self configBasicListView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.basicListViewType = HSBasicListViewTypeASTableView;
        [self configBasicListView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.basicListViewType = HSBasicListViewTypeASTableView;
        [self configBasicListView];
    }
    return self;
}

-(void)setupView{
    [super setupView];
}

-(void)configBasicListView{
    switch (self.basicListViewType) {
        case HSBasicListViewTypeTableView:{
            [self addSubview:self.tableViewCtl.scrollView];
        }
            break;
        case HSBasicListViewTypeCollectionView:{
            [self addSubview:self.collectionViewCtl.scrollView];
        }
            break;
#ifdef USE_AsyncDisplayKit
        case HSBasicListViewTypeASTableView:{
            [self addSubview:self.KSAStableViewCtl.scrollView];
        }
            break;
        case HSBasicListViewTypeASCollectionView:{
            [self addSubview:self.KSASCollectionViewCtl.scrollView];
        }
            break;
#endif
        default:{
            [self addSubview:self.tableViewCtl.scrollView];
        }
            break;
    }
    [self refreshDataRequest];
}

-(void)refreshDataRequest{
    [self.basicListService refreshDataRequest];
}

-(void)dealloc{
    _tableViewCtl = nil;
    _collectionViewCtl = nil;
#ifdef USE_AsyncDisplayKit
    _KSAStableViewCtl = nil;
    _KSASCollectionViewCtl = nil;
#endif
    _basicListService.delegate = nil;
    _basicListService = nil;
}

-(KSTableViewController *)tableViewCtl{
    if (_tableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _tableViewCtl = [[KSTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [self setupScrollViewServiceController:_tableViewCtl];
    }
    return _tableViewCtl;
}

-(KSCollectionViewController *)collectionViewCtl{
    if (_collectionViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _collectionViewCtl = [[KSCollectionViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [self setupScrollViewServiceController:_collectionViewCtl];

    }
    return _collectionViewCtl;
}

#ifdef USE_AsyncDisplayKit

-(KSASTableViewController *)KSAStableViewCtl{
    if (_KSAStableViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _KSAStableViewCtl = [[KSASTableViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [self setupScrollViewServiceController:_KSAStableViewCtl];
    }
    return _KSAStableViewCtl;
}

-(KSASCollectionViewController *)KSASCollectionViewCtl{
    if (_KSASCollectionViewCtl == nil) {
        KSCollectionViewConfigObject* configObject = [[KSCollectionViewConfigObject alloc] init];
        [configObject setupStandConfig];
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width;
        _KSASCollectionViewCtl = [[KSASCollectionViewController alloc] initWithFrame:frame withConfigObject:configObject];
        [self setupScrollViewServiceController:_KSASCollectionViewCtl];
    }
    return _KSASCollectionViewCtl;
}

#endif

-(KSScrollViewServiceController*)getBasicListView{
    switch (self.basicListViewType) {
        case HSBasicListViewTypeTableView:{
            return self.tableViewCtl;
        }
            break;
        case HSBasicListViewTypeCollectionView:{
            return self.collectionViewCtl;
        }
            break;
#ifdef USE_AsyncDisplayKit
        case HSBasicListViewTypeASTableView:{
            return self.KSAStableViewCtl;
        }
            break;
        case HSBasicListViewTypeASCollectionView:{
            return self.KSASCollectionViewCtl;
        }
            break;
#endif
        default:{
            return self.tableViewCtl;
        }
            break;
    }
    return self.tableViewCtl;
}

-(void)setupScrollViewServiceController:(KSScrollViewServiceController*)scrollViewServiceController{
    if (scrollViewServiceController == nil
        || ![scrollViewServiceController isKindOfClass:[KSScrollViewServiceController class]]) {
        return;
    }
    [scrollViewServiceController setErrorViewTitle:@"暂无信息"];
    [scrollViewServiceController setHasNoDataFootViewTitle:@"已无信息可同步"];
    [scrollViewServiceController setNextFootViewTitle:@""];
    [scrollViewServiceController setDataSourceRead:self.dataSourceRead];
    [scrollViewServiceController setDataSourceWrite:self.dataSourceWrite];
}

-(void)setBasicListService:(KSAdapterService *)basicListService{
    if (_basicListService != basicListService) {
        _basicListService = nil;
        _basicListService = basicListService;
        WEAKSELF
        _basicListService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf showLoadingView];
        };
        _basicListService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
        _basicListService.serviceDidFailLoadBlock = ^(WeAppBasicService* service, NSError* error){
            STRONGSELF
            [strongSelf hideLoadingView];
        };
        [_tableViewCtl setService:_basicListService];
        [_collectionViewCtl setService:_basicListService];
#ifdef USE_AsyncDisplayKit
        [_KSAStableViewCtl setService:_basicListService];
        [_KSASCollectionViewCtl setService:_basicListService];
#endif
    }
}

-(void)setModelInfoItemClass:(Class)modelInfoItemClass{
    _modelInfoItemClass = modelInfoItemClass;
    [self.dataSourceRead  setModelInfoItemClass:modelInfoItemClass];
    [self.dataSourceWrite setModelInfoItemClass:modelInfoItemClass];
}

-(void)setViewCellClass:(Class)viewCellClass{
    _viewCellClass = viewCellClass;
    [_tableViewCtl registerClass:_viewCellClass];
    [_collectionViewCtl registerClass:_viewCellClass];
#ifdef USE_AsyncDisplayKit
    [_KSAStableViewCtl registerClass:_viewCellClass];
    [_KSASCollectionViewCtl registerClass:_viewCellClass];
#endif
}

-(KSDataSource *)dataSourceRead {
    if (!_dataSourceRead) {
        _dataSourceRead = [[KSDataSource alloc] init];
    }
    return _dataSourceRead;
}

-(KSDataSource *)dataSourceWrite {
    if (!_dataSourceWrite) {
        _dataSourceWrite = [[KSDataSource alloc] init];
    }
    return _dataSourceWrite;
}

-(CGSize)sizeThatFits:(CGSize)size{
    KSScrollViewConfigObject* config = [self getBasicListView].configObject;
    if ([config isKindOfClass:[KSCollectionViewConfigObject class]]) {
        KSCollectionViewConfigObject* collectionViewConfigObject = (KSCollectionViewConfigObject*)config;
        if (collectionViewConfigObject.autoAdjustFrameSize) {
            KSScrollViewServiceController* viewController = [self getBasicListView];
            if ([viewController respondsToSelector:@selector(sizeToFit)]) {
                [viewController performSelector:@selector(sizeToFit) withObject:nil];
            }
            return [self getBasicListView].scrollView.size;
        }
    }
    return size;
}

@end
