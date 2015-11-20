//
//  EHPopMenuLIstView.h
//  eHome
//
//  Created by 孟希羲 on 15/7/9.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSView.h"
#import "KSTableViewController.h"
#import "EHPopMenuModel.h"

typedef void(^menuListSelectedBlock) (NSUInteger index,   EHPopMenuModel* selectItem);
typedef void(^menuDidCancelBlock) (void);

@interface HSPopMenuListView : KSView{
    KSTableViewController*          _tableViewCtl;
}

/*!
 *  @brief  类方法，简展示menuview的最简单方式
 *
 *  @param titleTextArray    一个含有标题(NSString类型)的数组
 *  @param menuSelectedBlock 点击menu后的响应
 *
 *  @since 1.0
 */
+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock;

+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock onView:(UIView *)view atPoint:(CGPoint)point;

+(void)showMenuViewWithTitleTextArray:(NSArray*)titleTextArray menuSelectedBlock:(menuListSelectedBlock)menuSelectedBlock menuDidCancelBlock:(menuDidCancelBlock)menuDidCancelBlock onView:(UIView *)view atPoint:(CGPoint)point;

/*!
 *  @author 孟希羲, 15-11-13 14:11:18
 *
 *  @brief  控制popMenu的每个显示cell的宽高
 *
 *  @since  1.0
 */
@property(nonatomic,assign) CGSize                        menuCellSize;

/*!
 *  @brief  menuListSelectedBlock  选中某个菜单后的响应block
 *
 *  @since 1.0
 */
@property(nonatomic,copy) menuListSelectedBlock           menuListSelectedBlock;

/*!
 *  @brief  menuDidCancelBlock  用于隐藏menu
 *
 *  @since 1.0
 */
@property(nonatomic,copy) menuDidCancelBlock              menuDidCancelBlock;

/*!
 *  @brief  showMenu 显示menu在默认位置
 *
 *  @since 1.0
 */
-(void)showMenu;

/*!
 *  @brief  showMenuAtPoint 显示menu在指定位置
 *
 *  @param point 位置
 *
 *  @since 1.0
 */
-(void)showMenuAtPoint:(CGPoint)point;

/*!
 *  @brief  显示menu在指定view的指定位置
 *
 *  @param view
 *  @param point
 *
 *  @since
 */
-(void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;

/*!
 *  @author 孟希羲, 15-11-13 14:11:48
 *
 *  @brief  隐藏menuView
 *
 *  @param animated 是否需要动画
 *
 *  @since 1.0
 */
-(void)dissMissPopMenuWithAnimated:(BOOL)animated;

/*!
 *  @brief  setPopMenuCellSize 设置弹出menu的cell宽高,默认为CGSizeMake(128, 45)
 *
 *  @param menuCellSize  CGSize 属性
 *
 *  @since 1.0
 */
-(void)setPopMenuCellSize:(CGSize)menuCellSize;

/*!
 *  @brief  refreshMenuWithModel 用EHPopMenuModel类型的数组刷新菜单列表
 *
 *  @param popMenuModelArray 数组类型，其每个元素必须为EHPopMenuModel的子类
 *                           如需清空列表，请传入空array @[]，传入nil无效
 *
 *  @since 1.0
 */
-(void)refreshMenuWithModelArray:(NSArray*)popMenuModelArray;

@end
