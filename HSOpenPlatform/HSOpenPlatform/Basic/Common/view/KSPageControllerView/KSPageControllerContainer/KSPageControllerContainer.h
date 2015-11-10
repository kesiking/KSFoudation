//
//  KSPageControllerContainer.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/14.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBPageControllerView.h"
#import "WeAppTSimpleSelectorScrollView.h"
#import "WeAppSelectorButton.h"

@class KSPageControllerContainer;

@protocol KSPageControllerViewDelegate <NSObject>

- (NSUInteger)numberOfSectionsInPageControllerView:(TBPageControllerView*)pageControllerView;

- (UIControl*)pageControllerView:(TBPageControllerView*)pageControllerView atIndex:(NSUInteger)itemIndex;

@optional

-(void)pageControllerView:(TBPageControllerView*)pageControllerView willShowViewAtIndex:(NSUInteger)itemIndex;

-(void)pageControllerView:(TBPageControllerView*)pageControllerView didShowViewAtIndex:(NSUInteger)itemIndex;

@end

@protocol KSPageControllerSelectorDelegate <NSObject>

@optional

/*!
 *  @author 孟希羲, 15-10-15 09:10:40
 *
 *  @brief  选择栏的dataSource
 *
 *  @param itemView     选择栏中的某个按钮
 *  @param selectorItem 按钮的相关数据源
 *  @param index        按钮的index
 *  @param isSelect     按钮是否选中
 *  @param firstConfig  是否首次配置，首次配置时可以设置如title、图片icon属性。
 *
 *  @since 1.0
 */
-(void)pageControllerSelectorProperty:(WeAppSelectorButton*)itemView selectorItem:(id)selectorItem withIndex:(NSUInteger)index isSelect:(BOOL)isSelect isFirstConfig:(BOOL)firstConfig;

//如果选择的是不同的selector，选中后的操作，选中同一个item不会响应
-(void)pageControllerSelectorView:(WeAppTSimpleSelectorScrollView*)selectView didSelectRowAtIndex:(NSUInteger)index;

//如果选择的是同一个selector，选中后的操作，选中同一个item响应
-(void)pageControllerSelectorView:(WeAppTSimpleSelectorScrollView*)selectView didSelectSameRowAtIndex:(NSUInteger)index;

@end

@interface KSPageControllerContainer : KSView

@property (nonatomic, strong) TBPageControllerView                  *pageControllerView;
@property (nonatomic, weak)  id<KSPageControllerViewDelegate>        pageControllerViewDelegate;

@property (nonatomic, strong) WeAppTSimpleSelectorScrollView        *selectorView;
@property (nonatomic, weak)  id<KSPageControllerSelectorDelegate>    selectorViewDelegate;

@property (nonatomic, strong) NSMutableArray                        *selectorDataSource;
@property (nonatomic, assign) CGRect                                 selectorButtonRect;

-(instancetype)initWithFrame:(CGRect)frame selectorButtonRect:(CGRect)selectorButtonRect;


-(id)dequeueReusableControlWithIdentifier:(NSString *)identifier withItemIndex:(NSUInteger)itemIndex; // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.

-(void)setControlWithControl:(UIControl*)control reuseIdentifier:(NSString *)identifier withItemIndex:(NSUInteger)itemIndex;

-(void)reloadData;

@end
