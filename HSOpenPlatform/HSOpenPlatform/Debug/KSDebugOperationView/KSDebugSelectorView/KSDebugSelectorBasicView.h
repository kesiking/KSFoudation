//
//  KSDebugSelectorBasicView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSDebugBasicMenuItemView;

@protocol KSDebugBasicSelectorProtocol <NSObject>

@required

//设置Selector的长宽属性，只会被调用一次
-(void)setSelectorFrame:(NSUInteger)pluginCnt defaultIndex:(NSUInteger)defaultIndex;

//设置Selector的属性，可以根据是第几个位置的以及是否为选中按钮，如果需要设置样式就继承该函数
-(void)setSelectorProperty:(KSDebugBasicMenuItemView*)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect;

//Selector被选中时触发的事件，返回新选中的itemView与之前的itemView，如果需要做变化就继承该函数,返回YES则表示继续执行否则就跳过
-(BOOL)itemViewSelected:(KSDebugBasicMenuItemView*)itemView withOldItemView:(KSDebugBasicMenuItemView*)oldItemView;

//Selector被选中时触发的事件，返回新选中的itemView以及index值
-(void)itemViewSelected:(KSDebugBasicMenuItemView*)itemView atIndex:(NSUInteger)index;

//Selector被按下时的操作,用于改变按下时的样式
-(void)itemViewClickedDown:(KSDebugBasicMenuItemView*)itemView;

//Selector被放弃选中时的操作,用于改变放弃时的样式
-(void)itemViewClickedCancel:(KSDebugBasicMenuItemView*)itemView;

//当Selector的容器SelectorScrollView完成配置后会调用
-(void)didSelectorScrollViewFinished:(UIScrollView*)scrollView;

//选中新Selector后scrollView控件的表现形式，如露出下一个selector，提升体验
-(void)scrollViewActionWithNewItemView:(KSDebugBasicMenuItemView*)itemView withOldItemView:(KSDebugBasicMenuItemView*)oldItemView;

@end

@interface KSDebugSelectorBasicView : UIView<UIScrollViewDelegate, KSDebugBasicSelectorProtocol>
{
    CGFloat    _buttonWidth;
    CGFloat    _buttonHeight;
    UIScrollView * _scrollView;
}
//兼容的取名，表示当前有多少个Selector
@property (nonatomic, assign) NSUInteger pluginCnt;
//默认选中的Selector，不设置为0
@property (nonatomic, assign) NSUInteger defaultIndex;
/*Selector的边框属性*/
//Selector的边框间距
@property (nonatomic, assign) CGFloat    sctBorderWidth;
@property (nonatomic, assign) CGFloat    sctBorderHeight;
//Selector的边框宽高
@property (nonatomic, assign) CGFloat    buttonWidth;
@property (nonatomic, assign) CGFloat    buttonHeight;
//存储Selector的需要的数据类型，配合setSelectorWithItemArray使用
@property (nonatomic, retain) NSArray        *dataSource;
//设置Selector容器数组的起始位置与结束位置
/*****************************
 用于特殊需求，一般不需要使用
 TBSNSPluginSelectorView需要过滤掉第一个Selector
 *****************************/
@property (nonatomic, assign) NSInteger  startIndex;
@property (nonatomic, assign) NSInteger  endIndex;
//存储Selector的数组
@property (nonatomic, retain) NSMutableArray * btnArray;
//传入的itemView的类型，动态扩展的类框架，需要继承自TBSNSBasicMenuItemView
@property (nonatomic, retain) Class      itemViewClass;

//设置Selector管理器的参数
- (void)setPluginCnt:(NSUInteger)pluginCnt defaultIndex:(NSUInteger)defaultIndex;
//设置Selector管理器的参数通过NSArray
- (void)setSelectorWithItemArray:(NSArray*)array;
//defaultIndex表示默认选中
- (void)setSelectorWithItemArray:(NSArray*)array defaultIndex:(NSUInteger)index;
//设置当前选中的Selector
- (void)setPluginSelectBtn:(NSUInteger)index;
//设置初始化，子类完善
- (void)setupView;
//根据itemView获取index索引
- (NSInteger)getIndexWithSelector:(KSDebugBasicMenuItemView*)itemView;
//根据index获取itemView索引
- (KSDebugBasicMenuItemView*)getSelectorWithIndex:(NSUInteger)index;
//将scrollView到当前Selector的位置
- (void)reloadSelecorPosition;
//刷新数据
- (void)reloadData;
//刷新页面宽高
- (void)reloadFrame;

@end
