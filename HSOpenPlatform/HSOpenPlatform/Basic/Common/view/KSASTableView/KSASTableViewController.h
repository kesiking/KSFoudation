//
//  KSASTableViewController.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_AsyncDisplayKit

#import "KSScrollViewServiceController.h"
#import "KSCollectionViewConfigObject.h"
#import "KSASTableViewCellNode.h"

typedef void(^tableViewDidSelectedBlock) (UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject);
typedef void(^tableViewDeleteProgressBlock)(NSArray* collectionDeleteItems,KSDataSource* dataSource);
typedef void(^tableViewDeleteCompleteBlock)(void);

@interface KSASTableViewController : KSScrollViewServiceController<ASTableViewDataSource, ASTableViewDelegate>{
    ASTableView*                 _tableView;
}

@property (nonatomic, strong) UIView*           tableHeaderView;
@property (nonatomic, strong) UIView*           tableFooterView;

@property (nonatomic, strong) tableViewDidSelectedBlock     tableViewDidSelectedBlock;
@property (nonatomic, strong) tableViewDeleteProgressBlock  tableViewDeleteProgressBlock;
@property (nonatomic, strong) tableViewDeleteCompleteBlock  tableViewDeleteCompleteBlock;

// tableView的删除操作时使用
@property (nonatomic, strong) NSMutableArray*   collectionDeleteItems;

// init method
-(instancetype)initWithFrame:(CGRect)frame withConfigObject:(KSCollectionViewConfigObject*)configObject;

// 设置KSViewCell的类型，用于反射viewCell，在KSCollectionViewCell中使用
-(void)registerClass:(Class)viewCellClass;

// 获取collectionView
-(ASTableView*)getTableView;

// 更新configObject
-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject;

// 删除tableViewCell
-(void)deleteCollectionCellProccessBlock:(tableViewDeleteProgressBlock)proccessBlock completeBolck:(tableViewDeleteCompleteBlock)completeBlock;

// method used by subclass
// 公用函数 在子类的- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath中调用
-(void)configTableView:(ASTableView *)tableView withCollectionViewCell:(KSASTableViewCellNode*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath;

// 自使用高度，配合autoAdjustFrameSize使用，autoAdjustFrameSize为YES时表示高度由cell的个数决定
-(void)sizeToFit;

@end

#endif
