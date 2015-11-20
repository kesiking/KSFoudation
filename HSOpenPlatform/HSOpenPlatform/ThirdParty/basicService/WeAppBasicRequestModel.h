//
//  TBSNSBasicRequestModel.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//
#import "WeAppComponentBaseItem.h"
#import "WeAppServiceContext.h"
#import "WeAppBasicPagedList.h"
#import "BasicNetWorkAdapter.h"
#import "WeAppUtils.h"

// 取数据的方式
typedef NS_ENUM(NSInteger, WeAppGetDataMethodType) {
    WeAppGetDataTypeMethodMTOP,	// 走MTOP
    WeAppGetDataTypeMethodURL  // 直接走URL
};

@class WeAppBasicRequestModel;

@protocol WeAppBasicRequestModelDelegate<NSObject>

- (void)modelDidStartLoad:(WeAppBasicRequestModel*)model;

- (BOOL)modelShouldLoad:(WeAppBasicRequestModel*)model;

- (void)modelDidFinishLoad:(WeAppBasicRequestModel*)model;

- (void)modelDidUserCache:(WeAppBasicRequestModel*)model;

- (void)model:(WeAppBasicRequestModel*)model didFailLoadWithError:(NSError*)error;

- (void)modelDidCancelLoad:(WeAppBasicRequestModel*)model;


@optional
- (void)modelWillStartLoad:(WeAppBasicRequestModel*)model;

@end

@interface WeAppBasicRequestModel : NSObject {
    
}

@property (nonatomic, weak )  id<WeAppBasicRequestModelDelegate> delegate;
@property (nonatomic, strong) NSString*   basicUrl;
@property (nonatomic, strong) NSURL*      requestUrl;
@property (nonatomic, assign) BOOL        isLoading;
@property (nonatomic, assign) BOOL        needLogin;
@property (nonatomic, assign) BOOL        onlyUserCache;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 额外属性用于记录传递上下文

@property(nonatomic, strong) WeAppServiceContext*  serviceContext;

- (void)cancel;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 设置model的基本参数
-(void)setModelWithAPIName:(NSString *)apiName params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 底层提供修改model request数据的机会

@property (nonatomic, strong) BasicNetWorkAdapter* network;

-(void)updateParamsForRequest:(BasicNetWorkAdapter*)request;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 能够自动映射的核心参数
// 返回值的时候根据该变量进行判断，默认为TBSNSGetDataTypeMethodMTOP
@property (nonatomic) WeAppGetDataMethodType getDataMethodType;
// 返回值的时候根据该变量进行判断，默认为TBSNSReturnDataTypeItem
@property (nonatomic) WeAppDataType returnDataType;
// json最上层的key，必须设置，默认为 @"data"
@property (nonatomic,retain) NSString* jsonTopKey;
// pageList使用的类，默认是TBSNSPageList
@property (nonatomic,strong) Class pageListClass;
@property (nonatomic,strong) NSString*  listPath;
// 如果返回值类型是TBSNSReturnDataTypeItem，则为item的Class；如果为TBSNSReturnDataTypeArray，则为数组中每个对象的Class
@property (nonatomic,retain) Class itemClass;
// 下面三个属性主要给分页等需要保存上一次访问状态的接口使用
// 取数据的MTOP api的名字
@property (nonatomic,retain) NSString *apiName;
// 取数据的URL 的地址
@property (nonatomic,retain) NSString *urlStr;
// 参数
@property (nonatomic,retain) NSDictionary *params;
// version of api
@property(nonatomic, strong) NSString * version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 最后的返回数据从下面三个变量中取，注意类型
// 返回的item
@property (nonatomic, retain) WeAppComponentBaseItem*      item;
// 返回的数组
@property (nonatomic, retain) NSArray* dataList;
// 返回的可翻页的list
@property (nonatomic, retain) WeAppBasicPagedList* pagedList;
// 返回的数值
@property (nonatomic, retain) NSNumber* numberValue;
// 返回的对象
@property (nonatomic, retain) id        objectValue;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 走MTOP的接口
// 返回值为TBItem及其子类的，用该方法
- (void)loadItemWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
// 返回值为NSArray的用该方法
- (void)loadDataListWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
// 返回值为可翻页的list的用该方法
- (void)loadPagedListWithAPIName:(NSString*)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination version:(NSString *)version;
// 操作类型使用该方法（比如加入收藏夹等），返回值为TBSNSBatOperationResult及其子类
- (void)operationWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
// 返回值为数值类型
- (void)loadNumberValueWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
// 返回值为数对象类型
- (void)loadObjectValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version;

- (void)uploadFileWithAPIName:(NSString*)apiName withFileName:(NSString*)fileName withFileContent:(NSData*)fileContent params:(NSDictionary *)params version:(NSString *)version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 走URL的接口
// 同上，只不过是走URL
- (void)loadItemWithURL:(NSString*)url params:(NSDictionary *)params version:(NSString *)version;
- (void)loadDataListWithURL:(NSString*)url params:(NSDictionary *)params version:(NSString *)version;
- (void)loadPagedListWithURL:(NSString*)url params:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination version:(NSString *)version;
- (void)operationWithURL:(NSString*)url params:(NSDictionary *)params version:(NSString *)version;
- (void)loadNumberValueWithURL:(NSString*)url params:(NSDictionary *)params version:(NSString *)version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 多态的实现，由子类实现，对外通过基类调用（但是子类实例）
// 下面方法是默认的取数据方法，基类没有实现，由子类实现（多态）
- (void)loadItemWithParams:(NSDictionary *)params;
- (void)loadDataListWithParams:(NSDictionary *)params;
- (void)loadPagedListWithParams:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination;
- (void)operationWithParams:(NSDictionary *)params;
- (void)loadNumberValueWithParams:(NSDictionary *)params;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 分页专用
- (void)refreshPagedList;
- (void)nextPage;
- (void)refreshPagedListWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;
- (void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 重刷数据

- (void)refreshDataRequest;

@end