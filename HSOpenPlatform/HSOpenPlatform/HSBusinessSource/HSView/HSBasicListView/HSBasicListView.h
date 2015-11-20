//
//  HSBasicListView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/24.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"
#import "KSCollectionViewController.h"
#ifdef USE_AsyncDisplayKit
#import "KSASTableViewController.h"
#import "KSASCollectionViewController.h"
#endif
#import "KSAdapterService.h"

typedef NS_ENUM(NSInteger, HSBasicListViewType) {
    HSBasicListViewTypeTableView           = 0,    //  普通tableView
    HSBasicListViewTypeCollectionView      = 1,    //  普通collectionView
    HSBasicListViewTypeASTableView         = 2,    //  ASTableView 封装了asyncDisplayKit的ASTableView，内存使用比较多，且cellNode与普通的不一样，需要使用asyncDisplayKit的ASTextNode机ASNetworkImageNode等
    HSBasicListViewTypeASCollectionView    = 3,    //  ASCollectionView 封装了asyncDisplayKit的ASCollectionView，内存使用比较多，且cellNode与普通的不一样，需要使用asyncDisplayKit的ASTextNode机ASNetworkImageNode等
} NS_ENUM_AVAILABLE_IOS(6_0);

NS_CLASS_AVAILABLE_IOS(6_0) @interface HSBasicListView : KSView{
    KSTableViewController*          _tableViewCtl;
    KSCollectionViewController*     _collectionViewCtl;
#ifdef USE_AsyncDisplayKit
    KSASTableViewController*        _KSAStableViewCtl;
    KSASCollectionViewController*   _KSASCollectionViewCtl;
#endif
}

@property (nonatomic,strong) KSTableViewController*         tableViewCtl;
@property (nonatomic,strong) KSCollectionViewController*    collectionViewCtl;
#ifdef USE_AsyncDisplayKit
@property (nonatomic,strong) KSASTableViewController*       KSAStableViewCtl;
@property (nonatomic,strong) KSASCollectionViewController*  KSASCollectionViewCtl;
#endif

@property (nonatomic,strong) KSAdapterService*              basicListService;

@property (nonatomic,strong) Class                          modelInfoItemClass;
@property (nonatomic,strong) Class                          viewCellClass;

- (instancetype)initWithFrame:(CGRect)frame withBasicListViewType:(HSBasicListViewType)basicListViewType;

- (instancetype)initWithBasicListViewType:(HSBasicListViewType)basicListViewType;

- (KSScrollViewServiceController*)getBasicListView;

@end
