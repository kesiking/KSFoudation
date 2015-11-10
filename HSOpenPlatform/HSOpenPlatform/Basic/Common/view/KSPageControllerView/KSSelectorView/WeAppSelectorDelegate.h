//
//  WeAppSelectorDelegate.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeAppSelectorDelegate <NSObject>

@required
//如果选择的是不同的selector，选中后的操作，选中同一个item不会响应
-(void)selectorView:(UIView*)selectView didSelectRowAtIndex:(NSUInteger)index;

@optional
//如果选择的是同一个selector，选中后的操作，选中同一个item响应
-(void)selectorView:(UIView*)selectView didSelectSameRowAtIndex:(NSUInteger)index;

@end

//////////////////////////////////////////////////////////////////////////////////////
///

@protocol WeAppSelectorSourceData <NSObject>

@optional

//可选。版本2.0。设置selector的样式与数据，index是在selectView中第index位置的itemView，isSelect为是否选中。首次初始化每个itemView时调用，此时机可设置itemView的普通样式以及选中样式。
-(void)setSelectorViewProperty:(UIView*)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect;

//可选。版本2.0。改变selector的样式，index是在selectView中第index位置的itemView，isSelect为是否选中。选择过程中变化样式属性，会多次调用，调用时机为每次选择itemView时调用。与上一个函数相似，区别在于少了一些常用属性的设置，节省内存。
-(void)changeSelectorViewProperty:(UIView*)selectView itemView:(id)itemView withIndex:(NSUInteger)index isSelect:(BOOL)isSelect;

//可选。版本2.0。设置Selector的长宽属性，只会被调用一次，buttonWidth,buttonHeight为selectView的属性
-(void)setSelectorFrame:(UIView*)selectView;

//可选。版本1.0。返回selector的NAME，该函数专门用于设定selector的title，可用setSelectorViewProperty代替。
-(NSString*)selectorView:(UIView*)selectView selectorNameRowAtIndex:(NSUInteger)index;

//可选。版本1.0。可用setSelectorFrame代替。利用指针传递实现，该方法主要用于测试指针传值 -- 逸行
-(void)setSelectorFrame:(UIView*)selectView buttonWidth:(void*)buttonWidth buttonHeight:(void*)buttonHeight;
@end
