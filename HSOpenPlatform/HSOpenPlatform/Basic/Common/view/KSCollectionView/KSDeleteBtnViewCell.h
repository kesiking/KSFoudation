//
//  KSDeleteBtnViewCell.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/26.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSViewCell.h"
#import "KSCollectionViewConfigObject.h"
#import "KSTableViewController.h"
#import "KSCollectionViewController.h"

@interface KSDeleteBtnViewCell : KSViewCell

@property (nonatomic, strong) UIView                            *ks_deleteView;

@property (nonatomic, strong) IBOutlet UIView                   *ks_contentView;

/*!
 *  @author 孟希羲, 15-10-26 11:10:18
 *
 *  @brief  根据选中的删除items配置deleteView状态(选中与未选中的样式)，最终调用setupDeleteViewStatus函数改变状态
 *
 *  @param cell          cell description
 *  @param rect          rect description
 *  @param componentItem componentItem description
 *  @param extroParams   extroParams description
 *
 *  @since 1.0
 */
-(void)configCellDeleteViewWithCellView:(id<KSViewCellProtocol>)cell Frame:(CGRect)rect componentItem:(WeAppComponentBaseItem*)componentItem extroParams:(KSCellModelInfoItem*)extroParams;

/*!
 *  @author 孟希羲, 15-10-26 11:10:37
 *
 *  @brief  获取tableView或是collectionView的选中的删除items
 *
 *  @return 选中的删除items
 *
 *  @since 1.0
 */
-(NSMutableArray*)getCollectionDeleteItems;

/*!
 *  @author 孟希羲, 15-10-26 11:10:28
 *
 *  @brief 选中或是取消选中操作时会调用该函数，由基类重载后实现选中与未选中的样式
 *
 *  @param isSelect 是否选中
 *
 *  @since 1.0
 */
-(void)setupDeleteViewStatus:(BOOL)isSelect;

/*!
 *  @author 孟希羲, 15-10-26 11:10:38
 *
 *  @brief   当tableView或是collectionView进入编辑模式时，当前viewCell移动的X偏移量
 *
 *  @param isEditMode 是否在编辑状态
 *
 *  @return 默认在编辑状态下是返回-(ks_deleteView.width)偏移量，即向左移动
 *
 *  @since 1.0
 */
-(CGFloat)getOriginXWithEditModex:(BOOL)isEditMode;

/*!
 *  @author 孟希羲, 15-11-16 15:11:47
 *
 *  @brief  使用者可自由改变deleteView的位置
 *
 *  @param  frame 默认计算的位置，上下居中，左右居中
 *
 *  @return 新的frame位置
 *
 *  @since 1.0
 */
-(CGRect)getCustomDeleteViewFrameWithFrame:(CGRect)frame;

/*!
 *  @author 孟希羲, 15-10-26 11:10:37
 *
 *  @brief  当tableView或是collectionView进入编辑模式时是否需要移动当前viewCell，例如IOS的邮箱系统进入编辑模式会向右移动
 *
 *  @return 默认为YES，需要移动
 *
 *  @since 1.0
 */
-(BOOL)needMoveViewCellOringeXForShowDeleteView;

@end
