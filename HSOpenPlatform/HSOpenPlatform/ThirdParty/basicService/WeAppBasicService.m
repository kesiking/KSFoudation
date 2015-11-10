//
//  TBSNSBasicService.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppBasicService.h"
#import "WeAppUtils.h"

@interface  WeAppBasicService () {
    
}
// 返回值的时候根据该变量进行判断，默认为TBSNSGetDataTypeMethodMTOP
@property (nonatomic) enum    WeAppGetDataMethodType getDataMethodType;

@property (nonatomic, strong) BasicNetWorkAdapter*   network;

@end

@implementation WeAppBasicService
@synthesize requestModel = _requestModel;
@synthesize item = _item;
@synthesize dataList = _dataList;
@synthesize pagedList = _pagedList;
@synthesize numberValue = _numberValue;
// TODO 各种synthesize还没写

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 建议使用下面的初始化方法，可以减少后续的设置操作
-(id)initWithItemClass:(Class)itemClass andRequestModelClass:(Class)requestModelClass {
    if (self = [self init]) {
        // 绑定item，由于service是按照业务模型分的，所以一个service一般只对应一个itemClass
        self.itemClass = itemClass;
        self.requestModelClass = requestModelClass;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serviceContext = [WeAppServiceContext new];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark set Item 设置service的属性

-(void)setServiceWithAPIName:(NSString *)apiName params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version {
    self.apiName = apiName;
    self.version = version;
    [self.requestModel setModelWithAPIName:apiName params:params returnDataType:returnDataType pagination:pagination version:version];
}

-(void)setServicePagedListWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version {
    self.apiName = apiName;
    self.version = version;
    [self.requestModel setModelWithAPIName:apiName params:params returnDataType:WeAppDataTypePagedList pagination:pagination version:version];
}

-(void)setOnlyUserCache:(BOOL)onlyUserCache{
    _onlyUserCache = onlyUserCache;
    _requestModel.onlyUserCache = onlyUserCache;
    if (onlyUserCache) {
        _needCache = YES;
    }
}

-(void)setNeedCache:(BOOL)needCache{
    if (_onlyUserCache) {
        _needCache = YES;
    }else{
        _needCache = needCache;
    }
}

-(void)setServiceContext:(WeAppServiceContext *)serviceContext{
    _serviceContext = serviceContext;
    _requestModel.serviceContext = serviceContext;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Load Item
-(void)loadItemWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    self.apiName = apiName;
    self.version = version;
    [self.requestModel loadItemWithAPIName:apiName params:params version:version];
}

-(void)loadItemWithURL:(NSString *)urlStr params:(NSDictionary *)params version:(NSString *)version {
    self.apiName = urlStr;
    self.version = version;
    [self.requestModel loadItemWithURL:urlStr params:params version:version];
}

-(void)loadItemWithParams:(NSDictionary *)params {
    [self.requestModel loadDataListWithParams:params];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Load DataList
-(void)loadDataListWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    self.apiName = apiName;
    self.version = version;
    [self.requestModel loadDataListWithAPIName:apiName params:params version:version];
}

-(void)loadDataListWithURL:(NSString *)urlStr params:(NSDictionary *)params version:(NSString *)version {
    self.apiName = urlStr;
    self.version = version;
    [self.requestModel loadDataListWithURL:urlStr params:params version:version];
}

-(void)loadDataListWithParams:(NSDictionary *)params {
    [self.requestModel loadDataListWithParams:params];
}

- (void)uploadFileWithAPIName:(NSString*)apiName withFileName:(NSString*)fileName withFileContent:(NSData*)fileContent params:(NSDictionary *)params version:(NSString *)version
{
    self.apiName = apiName;
    self.version = version;
    [self.requestModel uploadFileWithAPIName:apiName withFileName:fileName withFileContent:fileContent params:params version:version];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Load PagedList
-(void)loadPagedListWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version {
    self.apiName = apiName;
    self.version = version;
    [self.requestModel loadPagedListWithAPIName:apiName params:params pagination:pagination version:version];
    
}

-(void)loadPagedListWithURL:(NSString *)urlStr params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version {
    self.apiName = urlStr;
    self.version = version;
    [self.requestModel loadPagedListWithURL:urlStr params:params pagination:pagination version:version];
}

-(void)loadPagedListWithParams:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination {
    
    [self.requestModel loadPagedListWithParams:params pagination:pagination];
}

- (void)refreshDataRequest{
    [self.requestModel refreshDataRequest];
}

// 如果本次调用的api或url与上次不一样，可以在调用该方法前修改，默认是一样的，只是翻页参数不一样
// 比如：
// self.requestModel.apiName = @"AABBCCDD";
// self.requestModel.params = XXXX;
// self.requestModel.urlStr = XXXX;
-(void)refreshPagedList {
    [self.requestModel refreshPagedList];
}

- (void)refreshPagedListWithBlock:(IsObjectEnableBlock)isObjectEnableBlock{
    if (isObjectEnableBlock == nil) {
        [self.requestModel refreshPagedList];
    }else{
        [self.requestModel refreshPagedListWithBlock:isObjectEnableBlock];
    }
}

-(void)nextPage {
    if (![self.pagedList hasMore]) {
        [self modelDidCancelLoad:nil];
        [self.delegate serviceDidCancelLoad:self];
        return;
    }
    
    [self.requestModel nextPage];
}

- (void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock{
    if (isObjectEnableBlock == nil) {
        if (![self.pagedList hasMore]) {
            [self modelDidCancelLoad:nil];
            [self.delegate serviceDidCancelLoad:self];
            return;
        }
        
        [self.requestModel nextPage];
    }else{
        if (![self.pagedList hasMore]) {
            [self modelDidCancelLoad:nil];
            [self.delegate serviceDidCancelLoad:self];
            return;
        }
        
        [self.requestModel nextPageWithBlock:isObjectEnableBlock];
    }
}

-(NSInteger)totalCount {
    if (self.requestModel == nil || self.requestModel.pagedList == nil) {
        return 0;
    }
    
    return self.requestModel.pagedList.count;
}

-(void)setNeedLogin:(BOOL)needLogin{
    _needLogin = needLogin;
    _requestModel.needLogin = needLogin;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Operation
-(void)operationWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version {
    self.apiName = apiName;
    self.version = version;
    [self.requestModel operationWithAPIName:apiName params:params version:version];
}

-(void)operationWithURL:(NSString *)urlStr params:(NSDictionary *)params version:(NSString *)version{
    self.apiName = urlStr;
    self.version = version;
    [self.requestModel operationWithURL:urlStr params:params version:version];
}

-(void)operationWithParams:(NSDictionary *)params {
    [self.requestModel operationWithParams:params];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Load NumberValue
-(void)loadNumberValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    self.apiName = apiName;
    self.version = version;
    [self.requestModel loadNumberValueWithAPIName:apiName params:params version:version];
}

-(void)loadNumberValueWithURL:(NSString *)urlStr params:(NSDictionary *)params version:(NSString *)version{
    self.apiName = urlStr;
    self.version = version;
    [self.requestModel loadNumberValueWithURL:urlStr params:params version:version];
}

-(void)loadNumberValueWithParams:(NSDictionary *)params {
    [self.requestModel loadNumberValueWithParams:params];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Load object

-(void)loadObjectValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version {
    self.apiName = apiName;
    self.version = version;
    [self.requestModel loadObjectValueWithAPIName:apiName params:params version:version];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 核心取数据的model
-(WeAppBasicRequestModel *)requestModel {
    // 是否使用默认的requestModel
    if (self.requestModelClass == nil) {
        self.requestModelClass = [WeAppBasicRequestModel class];
    }
    
    // 如果为空，或类型不一样要重新设置
    if (!_requestModel || self.requestModelClass!=[_requestModel class]) {
        _requestModel = [[self.requestModelClass alloc] init];
        _requestModel.delegate = self;
    }
    if (_requestModel) {
        _requestModel.jsonTopKey = self.jsonTopKey;
        _requestModel.itemClass = self.itemClass == nil ?[WeAppComponentBaseItem class]:self.itemClass;
        _requestModel.pageListClass = self.pageListClass == nil ?[WeAppBasicPagedList class]:self.pageListClass;
        _requestModel.listPath = self.listPath == nil ? @"list":self.listPath;
        _requestModel.network = self.network;
        _requestModel.needLogin = self.needLogin;
        _requestModel.onlyUserCache = self.onlyUserCache;
        _requestModel.serviceContext = self.serviceContext;
    }
    
    return _requestModel;
}

-(void)setJsonTopKey:(NSString *)jsonTopKey{
    _jsonTopKey = jsonTopKey;
    if (_requestModel) {
        _requestModel.jsonTopKey = jsonTopKey;
    }
}

-(void)setPageListClass:(Class)pageListClass{
    _pageListClass = pageListClass;
    if (_requestModel) {
        _requestModel.pageListClass = pageListClass;
    }
}

-(void)setItemClass:(Class)itemClass{
    _itemClass = itemClass;
    if (_requestModel) {
        _requestModel.itemClass = itemClass;
    }
}

-(void)setListPath:(NSString *)listPath{
    _listPath = listPath;
    if (_requestModel) {
        _requestModel.listPath = listPath;
    }
}

-(void)setNetwork:(BasicNetWorkAdapter*)network{
    _network = network;
    if (_requestModel) {
        _requestModel.network = network;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 返回值

-(NSArray *)dataList {
    if([WeAppUtils isNotEmpty:self.requestModel.dataList]){
        _dataList = self.requestModel.dataList;
        return _dataList;
    }
    return nil;
}

-(WeAppComponentBaseItem *)item {
    if([WeAppUtils isNotEmpty:self.requestModel.item]){
        _item = self.requestModel.item;
        return _item;
    }
    
    return nil;
}

-(WeAppBasicPagedList *)pagedList {
    if([WeAppUtils isNotEmpty:self.requestModel.pagedList]){
        _pagedList = self.requestModel.pagedList;
        return _pagedList;
    }
    
    return nil;
}

-(NSNumber *)numberValue {
    return self.requestModel.numberValue;
}

-(id)objectValue{
    return self.requestModel.objectValue;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark cache 操作

-(void)updateCache{
    if (self.needCache) {
        if (self.requestModel.returnDataType == WeAppDataTypeItem) {
            [self.cacheService writeCacheWithApiName:self.apiName withParam:self.requestModel.params componentItem:self.item writeSuccess:nil];
        }else if (self.requestModel.returnDataType == WeAppDataTypeArray){
            [self.cacheService writeCacheWithApiName:self.apiName withParam:self.requestModel.params componentItemArray:self.dataList writeSuccess:nil];
        }else if(self.requestModel.returnDataType == WeAppDataTypePagedList){
            if (self.pagedList && [self.pagedList isRefresh]) {
                [self.cacheService writeCacheWithApiName:self.apiName withParam:self.requestModel.params componentItemArray:[self.pagedList getItemList] writeSuccess:^(BOOL success) {
                    
                }];
            }
        }
    }
}

-(void)readCache{
    if (self.needCache) {
        if (self.requestModel.returnDataType == WeAppDataTypeItem
            || self.requestModel.returnDataType == WeAppDataTypeArray
            || self.requestModel.returnDataType == WeAppDataTypePagedList) {
            // 翻页逻辑不读取cache数据
            if (self.requestModel.returnDataType == WeAppDataTypePagedList
                && self.pagedList && ![self.pagedList isRefresh]) {
                return;
            }
            WEAKSELF
            [self.cacheService readCacheWithApiName:self.apiName withParam:self.requestModel.params withFetchCondition:[self.cacheService.fetchConditionDict objectForKey:self.apiName] componentItemClass:self.itemClass readSuccess:^(NSMutableArray *componentItems) {
                STRONGSELF
                strongSelf.cacheComponentItems = componentItems;
                if (componentItems && [componentItems count] > 0 && strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(serviceCacheDidLoad:cacheData:)]) {
                    [strongSelf.delegate performSelector:@selector(serviceCacheDidLoad:cacheData:) withObject:strongSelf withObject:componentItems];
                }
                if (componentItems && [componentItems count] > 0 && strongSelf.serviceCacheDidLoadBlock) {
                    strongSelf.serviceCacheDidLoadBlock(strongSelf,componentItems);
                }
            }];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBRequestModelDelegate
-(void)modelDidCancelLoad:(WeAppBasicRequestModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDidCancelLoad:)]) {
        [self.delegate performSelector:@selector(serviceDidCancelLoad:) withObject:self];
    }
    if (self.serviceDidCancelLoadBlock) {
        self.serviceDidCancelLoadBlock(self);
    }
    
    self.canceled = YES;
    if (self.executing) self.executing = NO;
    if (!self.finished) self.finished = YES;
}

-(void)modelDidFinishLoad:(WeAppBasicRequestModel *)model {
    self.serviceSuccess = YES;
    @try {
        // todo update cache
        [self updateCache];
        // call back
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDidFinishLoad:)]) {
            [self.delegate performSelector:@selector(serviceDidFinishLoad:) withObject:self];
        }
        if (self.serviceDidFinishLoadBlock) {
            self.serviceDidFinishLoadBlock(self);
        }
    }
    @catch (NSException *exception) {
        self.delegate = nil;
    }
    if (self.executing) self.executing = NO;
    if (!self.finished) self.finished = YES;
}

- (void)modelDidUserCache:(WeAppBasicRequestModel*)model{
    [self readCache];
}

-(void)modelDidStartLoad:(WeAppBasicRequestModel *)model {
    @try {
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDidStartLoad:)]) {
            [self.delegate performSelector:@selector(serviceDidStartLoad:) withObject:self];
        }
        if (self.serviceDidStartLoadBlock) {
            self.serviceDidStartLoadBlock(self);
        }
        [self readCache];
    }
    @catch (NSException *exception) {
        self.delegate = nil;
    }
    self.executing = YES;
}

- (BOOL)modelShouldLoad:(WeAppBasicRequestModel*)model{
    if (self.onlyUserCache && self.cacheComponentItems && [self.cacheComponentItems count] > 0) {
        return NO;
    }
    return YES;
}

-(void)model:(WeAppBasicRequestModel *)model didFailLoadWithError:(NSError *)error {
    self.serviceSuccess = NO;
    @try {
        if (self.delegate && [self.delegate respondsToSelector:@selector(service:didFailLoadWithError:)]) {
            
            [self.delegate performSelector:@selector(service:didFailLoadWithError:) withObject:self withObject:error];
        }
        if (self.serviceDidFailLoadBlock) {
            self.serviceDidFailLoadBlock(self,error);
        }
    }
    @catch (NSException *exception) {
        self.delegate = nil;
    }
    if (self.executing) self.executing = NO;
    if (!self.finished) self.finished = YES;
}

-(void)dealloc{
    self.delegate = nil;
    self.serviceDidFailLoadBlock = nil;
    self.serviceDidCancelLoadBlock = nil;
    self.serviceDidStartLoadBlock = nil;
    self.serviceDidFinishLoadBlock = nil;
    if (_requestModel) {
        [_requestModel cancel];
        _requestModel.delegate = nil;
        _requestModel = nil;
    }
    NSLog(@"%s",__FUNCTION__);
}


@end