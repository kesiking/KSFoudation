//
//  KSCollectionViewController.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-24.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewServiceController.h"
#import "KSCollectionViewConfigObject.h"

/*!
 *  @author 孟希羲, 15-11-19 09:11:15
 *
 *  @brief  collectionViewDidSelectedBlock，列表中的某个cell被选中时回调
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *  @param dataSource     dataSource description
 *  @param configObject   configObject description
 *
 *  @since 1.0
 */
typedef void(^collectionViewDidSelectedBlock) (UICollectionView* collectionView,NSIndexPath* indexPath,KSDataSource* dataSource,KSCollectionViewConfigObject*configObject);


@interface KSCollectionViewController : KSScrollViewServiceController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    UICollectionView*               _collectionView;
}

@property (nonatomic, strong) UIView*           colletionHeaderView;
@property (nonatomic, strong) UIView*           colletionFooterView;

// 点击cell事件触发时回调
@property (nonatomic, strong) collectionViewDidSelectedBlock  collectionViewDidSelectedBlock;

// collection的删除操作时使用
@property (nonatomic, strong) NSMutableArray*   collectionDeleteItems;

// init method
-(instancetype)initWithFrame:(CGRect)frame withConfigObject:(KSCollectionViewConfigObject*)configObject;

// 设置KSViewCell的类型，用于反射viewCell，在KSCollectionViewCell中使用
-(void)registerClass:(Class)viewCellClass;

// 获取collectionView
-(UICollectionView*)getCollectionView;

// 更新configObject
-(void)updateCollectionConfigObject:(KSCollectionViewConfigObject*)configObject;

// 删除collectionViewCell
-(void)deleteCollectionCellProccessBlock:(void(^)(NSArray* collectionDeleteItems,KSDataSource* dataSource))proccessBlock completeBolck:(void(^)(void))completeBlock;

// method used by subclass
// 公用函数 在子类的- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath中调用
-(void)configCollectionView:(UICollectionView *)collectionView withCollectionViewCell:(UICollectionViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath;

// 自使用高度，配合autoAdjustFrameSize使用，autoAdjustFrameSize为YES时表示高度由cell的个数决定，目前sizeToFit只支持collectionSize为一样宽高的情况
-(void)sizeToFit;

@end
