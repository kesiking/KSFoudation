//
//  TBSNSBasicRequestModel.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-18.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppBasicRequestModel.h"
#import "WeAppURLStringUtil.h"
#import "WeAppUtils.h"
#import "WeAppJsonUtil.h"

@interface WeAppBasicRequestModel()

@end

@implementation WeAppBasicRequestModel

@synthesize item = _item;
@synthesize itemClass = _itemClass;
@synthesize jsonTopKey = _jsonTopKey;
@synthesize dataList = _dataList;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 设置model的基本参数
-(void)setModelWithAPIName:(NSString *)apiName params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    self.getDataMethodType = WeAppGetDataTypeMethodMTOP;
    self.returnDataType = returnDataType;
    self.apiName = apiName;
    self.params = params;
    self.pagedList.pagination = pagination;
    self.version = version;
}

//-(WeAppBasicPagedList *)pagedList{
//    if (_pagedList == nil) {
//        if (self.pageListClass != nil && [self.pageListClass isSubclassOfClass:[WeAppBasicPagedList class]]) {
//            _pagedList = [[self.pageListClass alloc]init];
//            _pagedList.itemClass = self.itemClass;
//        }else{
//            _pagedList = [[WeAppBasicPagedList alloc]init];
//        }
//    }
//    return _pagedList;
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 底层提供修改model request数据的机会

-(void)updateParamsForRequest:(BasicNetWorkAdapter*)request{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 走MTOP的接口
// 走MTOP
-(void)loadItemWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypeItem pagination:nil version:version];
}

-(void)loadDataListWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypeArray pagination:nil version:version];
}

-(void)loadPagedListWithAPIName:(NSString *)apiName params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self setPaged:pagination];
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypePagedList pagination:pagination version:version];
}

-(void)operationWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypeOperation pagination:nil version:version];
}

-(void)loadNumberValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypeNumber pagination:nil version:version];
}

-(void)loadObjectValueWithAPIName:(NSString *)apiName params:(NSDictionary *)params version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithAPIName:apiName params:params returnDataType:WeAppDataTypeObject pagination:nil version:version];
}
- (void)uploadFileWithAPIName:(NSString*)apiName withFileName:(NSString*)fileName withFileContent:(NSData*)fileContent params:(NSDictionary *)params version:(NSString *)version
{
    NSLog (@"%s", __FUNCTION__);
    
    [self basicUploadFileWithAPIName:apiName withFileName:fileName withFileContent:fileContent params:params returnDataType:WeAppDataTypeItem pagination:nil version:version];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 走URL的接口
-(void)loadItemWithURL:(NSString *)url params:(NSDictionary *)params version:(NSString *)version {
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithURL:url params:params returnDataType:WeAppDataTypeItem pagination:nil version:version];
}

-(void)loadDataListWithURL:(NSString *)url params:(NSDictionary *)params version:(NSString *)version {
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithURL:url params:params returnDataType:WeAppDataTypeArray pagination:nil version:version];
}

-(void)loadPagedListWithURL:(NSString *)url params:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    NSLog (@"%s", __FUNCTION__);
    [self setPaged:pagination];
    [self basicLoaderWithURL:url params:params returnDataType:WeAppDataTypePagedList pagination:pagination version:version];
}

-(void)operationWithURL:(NSString *)url params:(NSDictionary *)params version:(NSString *)version {
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithURL:url params:params returnDataType:WeAppDataTypeOperation pagination:nil version:version];
}

-(void)loadNumberValueWithURL:(NSString *)url params:(NSDictionary *)params version:(NSString *)version {
    NSLog (@"%s", __FUNCTION__);
    [self basicLoaderWithURL:url params:params returnDataType:WeAppDataTypeNumber pagination:nil version:version];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 多态的实现，由子类实现，对外通过基类调用（但是子类实例）
// 以下为子类实现的默认取数据接口，用于多态，直接通过基类来调用（但用的是子类的实例）
-(void)loadItemWithParams:(NSDictionary *)params {
    //need sub class to OverRide
}

-(void)loadDataListWithParams:(NSDictionary *)params {
    //need sub class to OverRide
}

-(void)loadPagedListWithParams:(NSDictionary *)params pagination:(WeAppPaginationItem *)pagination{
    //need sub class to OverRide
}

-(void)operationWithParams:(NSDictionary *)params {
    //need sub class to OverRide
}

-(void)loadNumberValueWithParams:(NSDictionary *)params {
    //need sub class to OverRide
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 重刷数据
- (void)refreshDataRequest{
    switch (self.returnDataType) {
        case WeAppDataTypeItem:{
            [self loadItemWithAPIName:self.apiName params:self.params version:self.version];
        }
            break;
        case WeAppDataTypeArray:{
            [self loadDataListWithAPIName:self.apiName params:self.params version:self.version];
        }
            break;
        case WeAppDataTypePagedList:{
            [self refreshPagedList];
        }
            break;
        case WeAppDataTypeNumber:{
            [self loadNumberValueWithAPIName:self.apiName params:self.params version:self.version];
        }
            break;
        case WeAppDataTypeObject:{
            [self loadObjectValueWithAPIName:self.apiName params:self.params version:self.version];
        }
            break;
        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 分页专用
- (void)refreshPagedList {
    
    if (self.pagedList == nil) {
        return;
    }
    
    [self.pagedList refresh];
    [self loadWithStoredState];
}

- (void)refreshPagedListWithBlock:(IsObjectEnableBlock)isObjectEnableBlock
{
    if (self.pagedList == nil) {
        return;
    }
    if (isObjectEnableBlock == nil) {
        [self.pagedList refresh];
        [self loadWithStoredState];
    }else{
        [self.pagedList refreshWithBlock:isObjectEnableBlock];
        [self loadWithStoredState];
    }
}

- (void)nextPage {
    if (self.pagedList == nil) {
        return;
    }
    
    [self.pagedList nextPage];
    [self loadWithStoredState];
}

- (void)nextPageWithBlock:(IsObjectEnableBlock)isObjectEnableBlock{
    if (self.pagedList == nil) {
        return;
    }
    if (isObjectEnableBlock == nil) {
        [self.pagedList nextPage];
        [self loadWithStoredState];
    }else{
        [self.pagedList nextPageWithBlock:isObjectEnableBlock];
        [self loadWithStoredState];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 底层实现
-(void)basicLoaderWithURL:(NSString *)url params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    self.getDataMethodType = WeAppGetDataTypeMethodURL;
    self.returnDataType = returnDataType;
    self.urlStr = url;
    self.params = params;
    self.version = version;
    
    // add params
    url = [WeAppURLStringUtil urlString:url addParams:params addPagination:pagination];
    
    if (self.isLoading) {
        [self cancel];
    }
    
    if (self.network) {
        [self updateParamsForRequest:self.network];
        [self.network request:url withParam:nil serviceContext:self.serviceContext onSuccess:^(NSDictionary *success) {
            ;
        } onError:^(NSDictionary *error) {
            ;
        } onCancel:^(NSDictionary *json) {
            ;
        }];
    }
}

-(void)basicLoaderWithAPIName:(NSString *)apiName params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    if(!self.isLoading) {
        self.getDataMethodType = WeAppGetDataTypeMethodMTOP;
        self.returnDataType = returnDataType;
        self.apiName = apiName;
        self.params = params;
        self.version = version;
        
        if (self.network) {
            NSMutableDictionary *newParams = nil;
            if (self.params) {
                newParams = [NSMutableDictionary dictionaryWithDictionary:self.params];
            }else{
                newParams = [NSMutableDictionary dictionary];
            }
            
            if (self.needLogin) {
                [newParams setObject:[NSNumber numberWithBool:self.needLogin] forKey:SERVICE_REQUEST_NEED_LOGIN_KEY];
            }
            
            //支持可变的pageSize等设置
            if (pagination) {
                [pagination addParams:self.params withDict:newParams];
            }
            
            //提供修改model request数据的机会
            [self updateParamsForRequest:self.network];
            
            self.isLoading = YES;
            __block __weak WeAppBasicRequestModel *wSelf = self;
            if (self.delegate && [self.delegate respondsToSelector:@selector(modelDidStartLoad:)]) {
                [self.delegate performSelector:@selector(modelDidStartLoad:) withObject:self];
            }
            BOOL modelShouldLoad = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(modelShouldLoad:)]) {
                modelShouldLoad = [self.delegate modelShouldLoad:self];
            }
            if (!modelShouldLoad) {
                self.isLoading = NO;
                return;
            }
            [self.network request:self.apiName withParam:newParams serviceContext:self.serviceContext onSuccess:^(NSDictionary *success) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;

                sSelf.isLoading = NO;
                [sSelf parseMTOPData:success];
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(modelDidFinishLoad:)]) {
                    [sSelf.delegate performSelector:@selector(modelDidFinishLoad:) withObject:sSelf];
                }
            } onError:^(NSDictionary *error) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;
                
                sSelf.isLoading = NO;
                
                NSError* errorObj = nil;
                if ([error isKindOfClass:[NSDictionary class]]) {
                    errorObj = [error objectForKey:@"responseError"];
                }
                
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(model:didFailLoadWithError:)]) {
                    [sSelf.delegate performSelector:@selector(model:didFailLoadWithError:) withObject:sSelf withObject:errorObj];
                }
            } onCancel:^(NSDictionary *json) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;
                sSelf.isLoading = NO;
                
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(modelDidCancelLoad:)]) {
                    [sSelf.delegate performSelector:@selector(modelDidCancelLoad:) withObject:sSelf];
                }
            }];
        }
    }
}

-(void)basicUploadFileWithAPIName:(NSString *)apiName withFileName:(NSString*)fileName withFileContent:(NSData*)fileContent params:(NSDictionary *)params returnDataType:(WeAppDataType)returnDataType pagination:(WeAppPaginationItem *)pagination version:(NSString *)version{
    if(!self.isLoading) {
        self.getDataMethodType = WeAppGetDataTypeMethodMTOP;
        self.returnDataType = returnDataType;
        self.apiName = apiName;
        self.params = params;
        self.version = version;
        
        if (self.network) {
            NSMutableDictionary *newParams = nil;
            if (self.params) {
                newParams = [NSMutableDictionary dictionaryWithDictionary:self.params];
            }else{
                newParams = [NSMutableDictionary dictionary];
            }
            
            if (self.needLogin) {
                [newParams setObject:[NSNumber numberWithBool:self.needLogin] forKey:@"needLogin"];
            }
            
            //支持可变的pageSize等设置
            if (pagination) {
                [pagination addParams:self.params withDict:newParams];
            }
            
            //提供修改model request数据的机会
            [self updateParamsForRequest:self.network];
            
            self.isLoading = YES;
            __block __weak WeAppBasicRequestModel *wSelf = self;
            if (self.delegate && [self.delegate respondsToSelector:@selector(modelDidStartLoad:)]) {
                [self.delegate performSelector:@selector(modelDidStartLoad:) withObject:self];
            }
            [self.network uploadfile:self.apiName withFileName:fileName withFileContent:fileContent withParam:newParams serviceContext:self.serviceContext onSuccess:^(NSDictionary *json) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;
                
                sSelf.isLoading = NO;
                [sSelf parseMTOPData:json];
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(modelDidFinishLoad:)]) {
                    [sSelf.delegate performSelector:@selector(modelDidFinishLoad:) withObject:sSelf];
                }
            } onError:^(NSDictionary *json) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;
                
                sSelf.isLoading = NO;
                
                NSError* errorObj = nil;
                if ([json isKindOfClass:[NSDictionary class]]) {
                    errorObj = [json objectForKey:@"responseError"];
                }
                
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(model:didFailLoadWithError:)]) {
                    [sSelf.delegate performSelector:@selector(model:didFailLoadWithError:) withObject:sSelf withObject:errorObj];
                }
            } onCancel:^(NSDictionary *json) {
                __strong WeAppBasicRequestModel *sSelf = wSelf;
                sSelf.isLoading = NO;
                
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(modelDidCancelLoad:)]) {
                    [sSelf.delegate performSelector:@selector(modelDidCancelLoad:) withObject:sSelf];
                }
            }];
        }
    }
}

// 通过已有状态载入数据，即上次调用的数据
-(void)loadWithStoredState {
    switch (self.getDataMethodType) {
        case WeAppGetDataTypeMethodMTOP:
        {
            [self basicLoaderWithAPIName:self.apiName params:self.params returnDataType:self.returnDataType pagination:self.pagedList.pagination version:self.version];
        }
            break;
        case WeAppGetDataTypeMethodURL:
        {
            [self basicLoaderWithURL:self.urlStr params:self.params returnDataType:self.returnDataType pagination:self.pagedList.pagination version:self.version];
        }
            break;
            
        default:
            break;
    }
}

-(void)setPaged:(WeAppPaginationItem*)pagination{
    
    if (pagination == nil) {
        return;
    }
    
    if (_pagedList == nil) {
        if (self.pageListClass != nil && [self.pageListClass isSubclassOfClass:[WeAppBasicPagedList class]]) {
            _pagedList = [[self.pageListClass alloc] init];
        }else{
            _pagedList = [[WeAppBasicPagedList alloc] init];
        }
    }
    _pagedList.itemClass = self.itemClass;
    [_pagedList setListPath:self.listPath];
    
    self.pagedList.pagination = pagination;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBSDKRequestModel回调

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Mock TBURLRequestDelegate

- (void)cancel {
    _network = nil;
}

- (void)requestDidStartLoad:(id)request {
    self.isLoading = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(modelDidStartLoad:)]) {
        [self.delegate performSelector:@selector(modelDidStartLoad:) withObject:self];
    }
}

- (void)requestDidFinishLoad:(id)request {
    self.isLoading = NO;
    switch (self.getDataMethodType) {
        case WeAppGetDataTypeMethodMTOP:
        {
            [self parseMTOPData:request];
        }
            break;
        case WeAppGetDataTypeMethodURL:
        {
            [self parseURLData:request];
        }
            break;
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(modelDidFinishLoad:)]) {
        [self.delegate performSelector:@selector(modelDidFinishLoad:) withObject:self];
    }
}


- (void)requestDidLoadFailed:(id)request withError:(NSError*)error {
    // 将action identifier添加到finished列表
    self.isLoading = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(model:didFailLoadWithError:)]) {
        [self.delegate performSelector:@selector(model:didFailLoadWithError:) withObject:self withObject:error];
    }
}

- (void)requestDidCancelLoad:(id)request {
    // 将action identifier添加到finished列表
    self.isLoading = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(modelDidCancelLoad:)]) {
        [self.delegate performSelector:@selector(modelDidCancelLoad:) withObject:self];
    }
}

- (void)reset {
    NSLog (@"%s", __FUNCTION__);
    
    [self clear];
}

-(void)clear {
    switch (self.returnDataType) {
        case WeAppDataTypeItem:
            _item = nil;
            break;
        case WeAppDataTypeArray:
            _dataList = nil;
            break;
        case WeAppDataTypePagedList:
            //被修改了，否则无网络分页时就会出错，需要商议
            _pagedList = nil;
            break;
        case WeAppDataTypeNumber:
            _numberValue = nil;
            break;
        case WeAppDataTypeObject:
            _objectValue = nil;
            break;
        default:
            break;
    }
}

-(void)parseMTOPData:(NSDictionary *)request {
    NSDictionary *dataJosnValue;
    
    if (request != nil && [request isKindOfClass:[NSDictionary class]]) {
        if (self.jsonTopKey.length > 0) {
            dataJosnValue = [request objectForKey:self.jsonTopKey];
        }else {
            dataJosnValue = request;
        }
    }
    
    [self parseData:dataJosnValue];
    
}

-(void)parseURLData:(NSDictionary *)request {
    if (request == nil) {
        return;
    }
    NSObject *dataJosnValue;
    // 如果是dic
    if (self.jsonTopKey.length > 0) {
        dataJosnValue = [request objectForKey:self.jsonTopKey];
    }else {
        dataJosnValue = request;
    }
    
    
    [self parseData:dataJosnValue];
}

-(void)parseData :(NSObject*)dataJosnValue{
    switch (self.returnDataType) {
        case WeAppDataTypeItem:
        {
            _item = [WeAppJsonUtil parseJson:dataJosnValue toObject:self.item withDataType:WeAppDataTypeItem itemClass:self.itemClass];
        }
            break;
        case WeAppDataTypeArray:
        {
            _dataList = [WeAppJsonUtil parseJson:dataJosnValue toObject:self.dataList withDataType:WeAppDataTypeArray itemClass:self.itemClass];
        }
            break;
        case WeAppDataTypePagedList:
        {
            if (self.pageListClass != nil && [self.pageListClass isSubclassOfClass:[WeAppBasicPagedList class]]) {
                NSDictionary* params = nil;
                if (self.listPath) {
                    params = [NSDictionary dictionaryWithObjectsAndKeys:self.listPath,@"listPath", nil];
                }
                _pagedList = [WeAppJsonUtil parseJson:dataJosnValue toObject:(NSObject*)self.pagedList withObjectClass:self.pageListClass withDataType:WeAppDataTypePagedList itemClass:self.itemClass params:params];
            }else{
                _pagedList = [WeAppJsonUtil parseJson:dataJosnValue toObject:(NSObject*)self.pagedList withDataType:WeAppDataTypePagedList itemClass:self.itemClass];
            }
            
        }
            break;
        case WeAppDataTypeNumber:
        {
            _numberValue = [WeAppJsonUtil parseJson:dataJosnValue toObject:self.numberValue withDataType:WeAppDataTypeNumber itemClass:nil];
        }
            break;
        case WeAppDataTypeObject:
            _objectValue = [WeAppJsonUtil parseJson:dataJosnValue toObject:self.objectValue withDataType:WeAppDataTypeObject itemClass:nil];
            break;
        default:
            break;
    }
}

-(void)dealloc{
    if (_network) {
        _network = nil;
    }
    self.delegate = nil;
    NSLog(@"dealloc");
}

@end

