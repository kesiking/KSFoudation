//
//  KSNavigator.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSBasicURLResolver.h"
#import "TBURLAction.h"

@protocol KSNavigationProtocol <NSObject>

-(BOOL)handelNavigatorURL:(NSURL*)url query:(NSDictionary*)query nativeParams:(NSDictionary *)nativeParams;

@end

//target 可以传当前页面中的view或者controller
BOOL TBOpenURLFromTarget(NSString* urlPath, id target);

// params用于传递回调。key由被调用的插件本身决定
BOOL TBOpenURLFromSourceAndParams(NSString* urlPath, id source, NSDictionary* nativeParams);

// 预留Native参数，解决为了安全等问题，不方便在url中传输入的参数
BOOL TBOpenURLFromTargetWithNativeParams(NSString* urlPath, id source, NSDictionary* params, NSDictionary *nativeParams);


BOOL TBBackFromView(UIView* view);
BOOL TBBackFromTarget(id target);

// 打开menu菜单
BOOL TBShowMenuFromSource(id source, id sender);

@interface KSNavigator : NSObject

+ (KSNavigator*)navigator;
+ (void)setNavigator:(KSNavigator*)navigator;

/**
 *	注册path与class的key-value关系.注册后可通过taobao://go/path调用此class的initWithNavigatorURL:query:方法
 *  如[TBNavigator registerClass:@"KSCityIndexViewController" withPath:@"tbcity"];
 *  注意:
 *  1.path是完全匹配。所以manwu://go/tbcity能打开页面，但是manwu://go/tbcity/xx不能打开页面.
 *  2.class需要实现UIViewControllerTBNavigator协议.
 *
 *	@param 	className 	class名字.
 *	@param 	path 	注册的路径,不能与其他人注册的path相同. 一个path只能对应一个class!
 */
+ (void)registerClass:(NSString *)className withPath:(NSString *)path;

/**
 *	通过registerClass:withPath:注册的path与class的key-value字典.
 */
@property (nonatomic, readonly) NSDictionary*   registeredPlugin;

- (BOOL)openURLAction:(TBURLAction*)action;
- (BOOL)backURLAction:(TBURLAction*)action;
- (BOOL)openMenuFromSource:(UIViewController *)source sender:(id)sender;

- (UIViewController*)containerViewControllerForController:(UIViewController *)viewController navigateType:(TBNavigationType)type;

/*
 *  预留接口，暂时未使用
 */

/**
 *	通过registerClass:withUrl:注册的url与class的key-value字典数组.
 */
@property (nonatomic, readonly) NSDictionary*   registeredPluginUrl;
/**
 *	按长度排序好的url数组. 加快比较效率
 */
@property (nonatomic, readonly) NSArray *sortedRegisteredUrlArray;


/**
 *	是否注册path,url冲突的信息. 若非空,说明冲突
 */
@property (nonatomic, readonly) NSString *registerConflictInfo;

/**
 *	注册url与class的key-value关系.注册后可通过scheme://url调用此class的initWithNavigatorURL:query:方法
 *  如[TBNavigator registerClass:@"XXViewController" withPath:@"tb.cn/x/dd"];
 *
 *  注意:
 *  1.url已改成完全匹配!。
 *  2.短域名需要先申请
 *  3.class需要实现initWithNavigatorURL:query:方法
 *
 *	@param 	className 	class名字.
 *	@param 	url 	注册的url,不能与其他人注册的url相同,不要http://等scheme前缀. 一个url只能对应一个class!
 */

+ (void)registerClass:(NSString *)className withUrl:(NSString *)url;

@end
