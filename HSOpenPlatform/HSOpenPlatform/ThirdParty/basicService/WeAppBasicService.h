//
//  TBSNSBasicService.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppBasicRequestModel.h"
#import "WeAppServiceContext.h"
#import "BasicNetWorkAdapter.h"
#import "KSCacheService.h"
#import "WeAppUtils.h"

typedef void(^CallMethod)();


@class WeAppBasicService;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSBasicServiceBlock

typedef void(^serviceDidStartLoadBlock) (WeAppBasicService* service);

typedef void(^serviceDidFinishLoadBlock) (WeAppBasicService* service);

typedef void(^serviceCacheDidLoadBlock) (WeAppBasicService* service, NSArray* cacheData);

typedef void(^serviceDidCancelLoadBlock) (WeAppBasicService* service);

typedef void(^serviceDidFailLoadBlock) (WeAppBasicService* service,NSError* error);

#define KSServiceDidStartLoadBlock(customService,...) \
customService.serviceDidStartLoadBlock = ^(WeAppBasicService* service){\
    {\
        __VA_ARGS__\
    }\
};

#define KSServiceDidFinishLoadBlock(customService,...) \
customService.serviceDidFinishLoadBlock = ^(WeAppBasicService* service){\
    {\
        __VA_ARGS__\
    }\
};

#define KSServiceDidFailLoadBlock(customService,...) \
customService.serviceDidFailLoadBlock = ^(WeAppBasicService* service,NSError* error){\
    {\
        __VA_ARGS__\
    }\
};

#define KSServiceCacheDidLoadBlock(customService,...) \
_##customService.serviceCacheDidLoadBlock = ^(WeAppBasicService* service, NSArray* cacheData){\
    {\
        __VA_ARGS__\
    }\
};
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSBasicServiceDelegate
@protocol WeAppBasicServiceDelegate <NSObject>

@required

@optional
- (void)serviceDidStartLoad:(WeAppBasicService *)service;
- (void)serviceDidCancelLoad:(WeAppBasicService *)service;
- (void)serviceDidFinishLoad:(WeAppBasicService *)service;
- (void)service:(WeAppBasicService *)service didFailLoadWithError:(NSError*)error;
- (void)serviceCacheDidLoad:(WeAppBasicService *)service cacheData:(NSArray*)cacheData;

- (void)serviceDidTimeout:(WeAppBasicService *)service;
// 服务降级时回调该方法
- (void)serviceDidDowngrade:(WeAppBasicService *)service;
// 数据操作
- (void)serviceDataOperationFinished:(WeAppBasicService *)service;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSNSBasicService
@interface WeAppBasicService : NSObject <WeAppBasicRequestModelDelegate>

// delegate与block任选其一即可
@property (nonatomic, weak)  id<WeAppBasicServiceDelegate>delegate;

// service init
-(id)initWithItemClass:(Class)itemClass andRequestModelClass:(Class)requestModelClass;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 额外属性用于记录传递上下文

@property(nonatomic, strong) WeAppServiceContext*  serviceContext;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 能够自动映射的核心参数 必须要设置的属性
// 如果返回值类型是TBSNSReturnDataTypeItem，则为item的Class；如果为TBSNSReturnDataTypeArray，则为数组中每个对象的Class
@property(nonatomic, strong) Class          itemClass;
// json最上层的key，注意是data不算，是data内的最上层的key
@property (nonatomic,strong) NSString*      jsonTopKey;
// 标记service是否需要登陆
@property (nonatomic,assign) BOOL           needLogin;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 网络适配器
// service 设置 network适配器，必须设置，否则无法加载数据
-(void)setNetwork:(BasicNetWorkAdapter*)network;

// cache对象 cache适配器，通过needCache设置是否需要使用cache缓存
@property (nonatomic, strong) KSCacheService*       cacheService;
// 使用cache的开关，如果有缓存会调用请求还是会发送serviceCacheDidLoad:cacheData:回调，还是会请求网络数据，网络请求返回后覆盖更新缓存
@property (nonatomic, assign) BOOL                  needCache;
// 1.0-仅使用cache，不发网络请求，打开onlyUserCache将忽略needCache属性，一定使用cache
// 2.0-如果本地没有缓存将继续访问网络请求
@property (nonatomic, assign) BOOL                  onlyUserCache;
// 调用是否成功标志
@property (nonatomic, assign) BOOL                  serviceSuccess;
// cache数据
@property (nonatomic, strong) NSArray*              cacheComponentItems;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 请求状态 可以做观察者模式

@property (nonatomic, assign) BOOL                   executing;
@property (nonatomic, assign) BOOL                   canceled;
@property (nonatomic, assign) BOOL                   finished;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark service block  delegate与block任选其一即可
// arc下block用strong与copy都可以，arc自动做了从栈上拷贝到堆上的操作，非arc下必须用copy属性
@property (nonatomic,copy) serviceDidStartLoadBlock  serviceDidStartLoadBlock;

@property (nonatomic,copy) serviceDidFinishLoadBlock serviceDidFinishLoadBlock;

@property (nonatomic,copy) serviceCacheDidLoadBlock  serviceCacheDidLoadBlock;

@property (nonatomic,copy) serviceDidCancelLoadBlock serviceDidCancelLoadBlock;

@property (nonatomic,copy) serviceDidFailLoadBlock   serviceDidFailLoadBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 用于扩展
// 发请求的TBSNSBasicRequestModel 的类型，必须为TBSNSBasicRequestModel及其子类
@property(nonatomic, strong)  Class                     requestModelClass;
// 发请求的model
@property(nonatomic,readonly) WeAppBasicRequestModel *  requestModel;
// 在多个服务情况下，做以区分
@property(nonatomic, strong)  NSString*                 apiName;
// version of
@property(nonatomic, strong)  NSString*                 version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark pageList 自动翻页及刷新时需要用到

// pageList使用的类，默认是TBSNSPageList
@property (nonatomic,strong) Class       pageListClass;

// listPath是数据array在json中的路径，例如{"responseData":{"result":[1,2,3]}},listPath应该是responseData.result
@property (nonatomic,strong) NSString*   listPath;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark set Item 设置service的属性
-(void)setServicePagedListWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version;

-(void)setServiceWithAPIName:(NSString *)apiName params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version;
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 查询TBModel及其子类
// 返回的item
@property(nonatomic,readonly) WeAppComponentBaseItem *item;
// 走MTOP,返回值为TBItem及其子类的，用该方法
- (void)loadItemWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
// 直接走URL
- (void)loadItemWithURL:(NSString*)urlStr params:(NSDictionary *)params version:(NSString *)version;
// 实现多态的方法，由子类实现
- (void)loadItemWithParams:(NSDictionary *)params;

- (void)uploadFileWithAPIName:(NSString*)apiName withFileName:(NSString*)fileName withFileContent:(NSData*)fileContent params:(NSDictionary *)params version:(NSString *)version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 查询NSArray类数据
// 返回的item
@property(nonatomic,readonly) NSArray *dataList;
- (void)loadDataListWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
- (void)loadDataListWithURL:(NSString*)urlStr params:(NSDictionary *)params version:(NSString *)version;
- (void)loadDataListWithParams:(NSDictionary *)params;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 可翻页的数据
// 返回的可翻页的list
@property (nonatomic, readonly) WeAppBasicPagedList* pagedList;
- (void)loadPagedListWithAPIName:(NSString*)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination version:(NSString *)version;
- (void)loadPagedListWithURL:(NSString*)urlStr params:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination version:(NSString *)version;
- (void)loadPagedListWithParams:(NSDictionary *)params pagination:(WeAppPaginationItem*)pagination;

// 如果除了分页参数其他全部与之前的请求相同，则只用基类的即可
// 如果有不一样的地方，可以在这里进行设置，包括接口名字、url地址、params、itemClass
// 比如：
// self.requestModel.apiName = @"AABBCCDD";
// self.requestModel.params = XXXX;
// self.requestModel.urlStr = XXXX;
// self.requestModel.itemClass = XXXX;
- (void)refreshPagedList;
- (void)nextPage;
- (void)refreshPagedListWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;
- (void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock;
// 返回总的数据数量
- (NSInteger)totalCount;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 写操作相关的服务，返回值为TBSNSBatOperationResultItem
- (void)operationWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
- (void)operationWithURL:(NSString*)urlStr params:(NSDictionary *)params version:(NSString *)version;
- (void)operationWithParams:(NSDictionary *)params;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 写操作相关的服务，返回值为TBSNSBatOperationResultItem
@property(nonatomic,readonly) NSNumber *numberValue;
- (void)loadNumberValueWithAPIName:(NSString*)apiName params:(NSDictionary *)params version:(NSString *)version;
- (void)loadNumberValueWithURL:(NSString*)urlStr params:(NSDictionary *)params version:(NSString *)version;
- (void)loadNumberValueWithParams:(NSDictionary *)params;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 对象获取相关，返回值为object
@property(nonatomic,readonly) id   objectValue;
- (void)loadObjectValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 重刷数据
- (void)refreshDataRequest;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark cache 操作

/*
 * 使用KSCacheStrategyTypeRemoteData策略:
 * 只存储dataList pageList item数据类型。
 * 每次updateCache调用时会清除数据库数据。
 * 翻页nextPage不存储数据
 * 目前版本不支持更新，插入，删除操作，可override后实现
 */

// 重载后可改变默认cache策略,如KSCacheStrategyTypeUpdate等
-(void)updateCache;

-(void)readCache;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Service Context 调用方式
//-(void)loadDataListWithObject:(NSObject*)object context:(TBServiceContext *)context;

@end
