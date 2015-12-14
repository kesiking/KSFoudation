//
//  KSDebugUtils.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 *  @author 孟希羲, 15-12-07 10:12:52
 *
 *  @brief  钩子函数 swizzleSelector 将两个函数方法对调，其中对于同一个方法而言，先执行对调的方法先执行，后执行对调的方法后执行
 *
 *  @param class            传入类
 *  @param originalSelector 原始的方法
 *  @param swizzledSelector 对调的方法
 *
 *  @since 1.0
 */
void ks_debug_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector);

@interface KSDebugUtils : NSObject

+ (void)injectSwizzledSelector:(SEL)swizzledSelector withSelector:(SEL)selector withUndefinedBlock:(void (^)(id slf, id sender, id paramOne, id paramTwo, id paramThree))undefinedBlock withImplementationBlock:(void (^)(id slf, id sender, id paramOne, id paramTwo, id paramThree))implementationBlock intoTargetClass:(Class)cls;

+ (void)sniffWithoutDuplicationForObject:(NSObject *)object selector:(SEL)selector sniffingBlock:(void (^)(void))sniffingBlock originalImplementationBlock:(void (^)(void))originalImplementationBlock;

/*!
 *  @author 孟希羲, 15-12-02 10:12:04
 *
 *  @brief  获取当前展示在屏幕上的viewController
 *
 *  @return CurrentAppearedViewController
 *
 *  @since  1.0
 */
+ (UIViewController*)getCurrentAppearedViewController;

/*!
 *  @author 孟希羲, 15-12-03 09:12:38
 *
 *  @brief  获取instance变量的属性名称及属性变量
 *
 *  @param  instanse 变量实例
 *
 *  @return property dict
 *
 *  @since  1.0
 */
+(NSMutableDictionary*)getInstansePropertyWithInstanse:(id)instanse;

@end
