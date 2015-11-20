//
//  KSTableViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-26.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewServiceController.h"
#import "KSCollectionViewConfigObject.h"

/*!
 *  @author 孟希羲, 15-11-19 09:11:13
 *
 *  @brief  tableViewDidSelectedBlock 列表中的某个cell被选中时回调
 *
 *  @param tableView    tableView description
 *  @param indexPath    indexPath description
 *  @param dataSource   dataSource description
 *  @param configObject configObject description
 *
 *  @since 1.0
 */
typedef void(^tableViewDidSelectedBlock) (UITableView* tableView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject* configObject);

/*!
 *  @author 孟希羲, 15-11-19 09:11:44
 *
 *  @brief  tableViewDelete删除cell时用到，tableViewDeleteProgressBlock用于真正删除cell及数据之前调用
 *
 *  @param collectionDeleteItems collectionDeleteItems存储的是需要删除的cell的indexPath
 *  @param dataSource            dataSource description
 *
 *  @since 1.0
 */
typedef void(^tableViewDeleteProgressBlock)(NSArray* collectionDeleteItems,KSDataSource* dataSource);
/*!
 *  @author 孟希羲, 15-11-19 09:11:26
 *
 *  @brief  tableViewDelete删除cell时用到，tableViewDeleteCompleteBlock用于真正删除cell及数据之后调用。
 *
 *  @since 1.0
 */
typedef void(^tableViewDeleteCompleteBlock)(void);

@interface KSTableViewController : KSScrollViewServiceController<UITableViewDataSource, UITableViewDelegate>{
    UITableView*                 _tableView;
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
-(UITableView*)getTableView;

// 更新configObject
-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject;

// 删除tableViewCell
-(void)deleteCollectionCellProccessBlock:(tableViewDeleteProgressBlock)proccessBlock completeBolck:(tableViewDeleteCompleteBlock)completeBlock;

// method used by subclass
// 公用函数 在子类的- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath中调用
-(void)configTableView:(UITableView *)tableView withCollectionViewCell:(UITableViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath;

// 自使用高度，配合autoAdjustFrameSize使用，autoAdjustFrameSize为YES时表示高度由cell的个数决定
-(void)sizeToFit;

@end
