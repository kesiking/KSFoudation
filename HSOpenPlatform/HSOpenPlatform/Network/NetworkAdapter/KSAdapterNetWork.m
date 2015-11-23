
//
//  KSAdapterNetWork.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSAdapterNetWork.h"
#import "AFHTTPRequestOperationManager.h"
#import "KSSecurityPolicyAdapter.h"
#import "KSAuthenticationCenter.h"
#import "KSNetworkDataMock.h"

//#define LINK_TEST_NETWORK

#ifdef LINK_TEST_NETWORK
    #define DEFAULT_SCHEME @"http"
    #define DEFAULT_HOST @"192.168.7.245"
    #define DEFAULT_PORT @"8081"
#else
    #define DEFAULT_SCHEME APP_DEFAULT_SCHEME
    #define DEFAULT_HOST @"112.54.207.12"
    #define DEFAULT_PORT @"9080"
#endif

//#define DEFAULT_PARH @"PersonSafeManagement/"
#define DEFAULT_PARH @"BMS/"
#define KS_MANWU_BASE_URL [NSString stringWithFormat:@"%@://%@:%@/%@",DEFAULT_SCHEME,DEFAULT_HOST,DEFAULT_PORT,DEFAULT_PARH]

// po [[NSString alloc] initWithData:self.responseData encoding:4]

typedef NS_ENUM(NSInteger, KSAdapterNetWorkResponseStatus) {
    KSAdapterNetWorkResponseStatus_Success = 1,       // 成功
    KSAdapterNetWorkResponseStatus_Fail    = 0,       // 失败
};

@implementation KSAdapterNetWork

-(void)request:(NSString *)apiName withParam:(NSMutableDictionary *)param serviceContext:(WeAppServiceContext*)serviceContext onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    // mock 数据
    BOOL hasMockData = [self didLoadDataFromMockWithApiName:apiName withParam:param onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
    
    if (hasMockData) {
        return;
    }
    
    if (![self isNetReachable]) {
        // 没有网络 直接返回错误
        EHLogError(@"-----> apiName: %@, network error",apiName);
        NSString* errorString = UISYSTEM_NETWORK_ERROR_MESSAGE;
        [WeAppToast toast:errorString];
        NSDictionary* errorDic = [self getNetUnreachableErrorDictWithResultstring:errorString];
        errorBlock(errorDic);
        return;
    }
    
    // 检查是否需要登陆
    self.needLogin = [param objectForKey:SERVICE_REQUEST_NEED_LOGIN_KEY];
    // 增加最外层的json配置属性，兼容之前版本
    NSString* jsonTopKey = [param objectForKey:SERVICE_RESPONSE_JSON_TOP_KEY];
    // 统一调用登陆逻辑
    [self callWithAuthCheck:apiName method:^{
        NSString* path = apiName;
        
        // 默认为json序列化
        NSMutableDictionary* newParams = [self getMutableParamWithParam:param];
        
        // 获取successCompleteBlock
        void(^successCompleteBlock)(AFHTTPRequestOperation *operation, id responseObject) = [self getSuccessCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey serviceContext:serviceContext onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        // 获取errorCompleteBlock
        void(^errorCompleteBlock)(AFHTTPRequestOperation *operation, NSError *error) = [self getErrorCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey serviceContext:serviceContext onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        [self preProccessParamWithParam:newParams serviceContext:serviceContext];

        AFHTTPRequestOperationManager *httpRequestOM = [self getAFHTTPRequestOperationManagerWithServiceContext:serviceContext];
        if ([serviceContext.serviceContextDict objectForKey:@"Content-Type"]) {
            [httpRequestOM.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        }else{
            [httpRequestOM.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        
        [self showNetworkActivityIndicatorVisible];

        AFHTTPRequestOperation * requestOperation = [httpRequestOM POST:path parameters:newParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successCompleteBlock) {
                successCompleteBlock(operation, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorCompleteBlock) {
                errorCompleteBlock(operation, error);
            }
        }];
        EHLogInfo(@"\n 请求参数 -----> requestURL : %@ \n requestParams :%@",requestOperation.request.URL , newParams?:@{});
    } onError:errorBlock];
}

-(NSMutableDictionary*)getMutableParamWithParam:(NSMutableDictionary*)param{
    NSMutableDictionary* newParams = nil;
    if (param && [param isKindOfClass:[NSMutableDictionary class]]) {
        return param;
    }else if ([param isKindOfClass:[NSDictionary class]]){
        newParams = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return newParams;
}

-(void)preProccessParamWithParam:(NSMutableDictionary*)newParams serviceContext:(WeAppServiceContext*)serviceContext{
    if (self.needLogin && ![newParams objectForKey:@"user_phone"] && [KSAuthenticationCenter userPhone]) {
        [newParams setObject:[KSAuthenticationCenter userPhone] forKey:@"user_phone"];
    }
    // 增加额外属性配置，可由使用者自由搭配
    if (serviceContext && serviceContext.serviceContextDict) {
        // 添加所需要的配置属性
    }
    
    /****************************/
    // 删除不必要的参数
    [newParams removeObjectForKey:SERVICE_REQUEST_NEED_LOGIN_KEY];
    // 去除最外层的json配置属性
    [newParams removeObjectForKey:SERVICE_RESPONSE_JSON_TOP_KEY];
}

-(AFHTTPRequestOperationManager*)getAFHTTPRequestOperationManagerWithServiceContext:(WeAppServiceContext*)serviceContext{
    AFHTTPRequestOperationManager *httpRequestOM = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:serviceContext.baseUrl?:KS_MANWU_BASE_URL]];
    httpRequestOM.shouldUseCredentialStorage = NO;
    /**** SSL Pinning ****/
    KSSecurityPolicyAdapter *securityPolicy = [KSSecurityPolicyAdapter policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    [httpRequestOM setSecurityPolicy:securityPolicy];
    /**** SSL Pinning ****/
    
    /**** 接口 参数 设置 ****/
    if ([[serviceContext.serviceContextDict objectForKey:@"requestSerializerNeedJson"] boolValue]) {
        [httpRequestOM.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
            if ([parameters isKindOfClass:[NSString class]]) {
                return (NSString*)parameters;
            }
            NSError* jsonError = nil;
            NSData*  jsonData = [NSJSONSerialization
                                 dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&jsonError];
            if ([jsonData length] > 0 && jsonError == nil){
                id paramObj = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                EHLogInfo(@"JSON String = %@ \n requestURL : %@", paramObj,request.URL.absoluteString);
                return paramObj;
            }
            return nil;
        }];
    }
    /**** 接口 参数 设置 ****/
    
    return httpRequestOM;
}

-(void(^)(AFHTTPRequestOperation *operation, id responseObject))getSuccessCompleteBlockWithApiName:(NSString *)apiName withParam:(NSDictionary *)param jsonTopKey:(NSString*)jsonTopKey serviceContext:(WeAppServiceContext*)serviceContext onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    return ^void(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* responseDict = (NSDictionary*)responseObject;
            if (jsonTopKey && [jsonTopKey isKindOfClass:[NSString class]] && jsonTopKey.length > 0) {
                responseDict = [responseDict objectForKey:jsonTopKey];
            }
            
            /**** 输出 参数 ****/
            NSString* resultString = [responseDict objectForKey:[serviceContext.serviceContextDict objectForKey:@"resultString"]?:@"message"];
            NSString* resultTime = [responseDict objectForKey:[serviceContext.serviceContextDict objectForKey:@"resultTime"]?:@"time"];
            NSUInteger resultCode = [[responseDict objectForKey:[serviceContext.serviceContextDict objectForKey:@"resultCode"]?:@"status"] integerValue];
            NSUInteger resultDataCount = [[responseDict objectForKey:[serviceContext.serviceContextDict objectForKey:@"resultDataCount"]?:@"dataCounts"] integerValue];
            EHLogInfo(@"\n 服务器响应成功 ----> requestURL : %@ \n requestParams :%@ \nrequest result with \n resultTime:%@,resultstring:%@,resultcode:%lu,apiName:%@,resultDataCount:%lu",operation.request.URL, param?:@{},resultTime,resultString,resultCode,apiName,resultDataCount);
            /**** 输出 参数 ****/
            
            if (resultCode == KSAdapterNetWorkResponseStatus_Success) {
                EHLogInfo(@"\n ----> request success responseDict = \n %@",responseDict);
                successBlock(responseDict);
            }else{
                NSDictionary* errorDic = [self getCommonErrorDictWithResultstring:resultString];
                errorBlock(errorDic);
            }
        }else{
            NSDictionary* errorDic = [self getCommonErrorDictWithResultstring:nil];
            errorBlock(errorDic);
        }
        [self hideNetworkActivityIndicatorVisible];
    };
}

-(void(^)(AFHTTPRequestOperation *operation, NSError *error))getErrorCompleteBlockWithApiName:(NSString *)apiName withParam:(NSDictionary *)param jsonTopKey:(NSString*)jsonTopKey serviceContext:(WeAppServiceContext*)serviceContext onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    return ^void(AFHTTPRequestOperation *operation, NSError *error){
        NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
        if (error) {
            [errorDic setObject:error forKey:@"responseError"];
            EHLogInfo(@"\n 服务器响应失败 ----> requestURL : %@ \n requestParams :%@ \nrequest failed with error \n %@",operation.request.URL, param?:@{}, error);
        }
        errorBlock(errorDic);
        [self hideNetworkActivityIndicatorVisible];
    };
}

-(void)uploadfile:(NSString *)apiName withFileName:(NSString*)fileName withFileContent: (NSData*)fileContent withParam:(NSMutableDictionary *)param serviceContext:(WeAppServiceContext*)serviceContext onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
    if (![self isNetReachable]) {
        // 没有网络 直接返回错误
        EHLogError(@"-----> apiName: %@, network error",apiName);
        NSString* errorString = UISYSTEM_NETWORK_ERROR_MESSAGE;
        [WeAppToast toast:errorString];
        NSDictionary* errorDic = [self getNetUnreachableErrorDictWithResultstring:errorString];
        errorBlock(errorDic);
        return;
    }
    // 检查是否需要登陆
    self.needLogin = [param objectForKey:@"needLogin"];
    // 增加最外层的json配置属性
    NSString* jsonTopKey = [param objectForKey:@"__jsonTopKey__"];
    // 统一调用登陆逻辑
    [self callWithAuthCheck:apiName method:^{
        NSString* path = apiName;
        
        // 默认为json序列化
        NSMutableDictionary* newParams = [self getMutableParamWithParam:param];
        
        // 获取successCompleteBlock
        void(^successCompleteBlock)(AFHTTPRequestOperation *operation, id responseObject) = [self getSuccessCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey serviceContext:serviceContext onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        // 获取errorCompleteBlock
        void(^errorCompleteBlock)(AFHTTPRequestOperation *operation, NSError *error) = [self getErrorCompleteBlockWithApiName:apiName withParam:param jsonTopKey:jsonTopKey serviceContext:serviceContext onSuccess:successBlock onError:errorBlock onCancel:cancelBlock];
        
        [self preProccessParamWithParam:newParams serviceContext:serviceContext];
        
        AFHTTPRequestOperationManager *httpRequestOM = [self getAFHTTPRequestOperationManagerWithServiceContext:serviceContext];
        [httpRequestOM.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        
        [httpRequestOM POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString*key in [newParams allKeys]) {
                [formData appendPartWithFormData:[NSData dataWithBytes:[[newParams objectForKey:key] UTF8String]  length:[[newParams objectForKey:key] length]] name:key];
            }
            
            [formData appendPartWithFileData:fileContent name:fileName fileName:fileName mimeType:@"application/octet-stream"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successCompleteBlock) {
                successCompleteBlock(operation, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorCompleteBlock) {
                errorCompleteBlock(operation, error);
            }
        }];
    } onError:errorBlock];
}

// 判断是否需要登陆才能操作，如果需要登陆，则先登陆，登陆成功后在回调接口；否则直接访问
-(void)callWithAuthCheck:(NSString*) apiName method:(CallMethod)callMethod onError:(NetworkErrorBlock)errorBlock{
    
    if (self.needLogin)
    {
        [[KSAuthenticationCenter sharedCenter] authenticateWithLoginActionBlock:^(BOOL loginSuccess) {
            if (loginSuccess)
                callMethod();
            else if (self.needLogin && errorBlock){
                NSDictionary* errorDic = [self getLoginErrorDict];
                errorBlock(errorDic);
            }
        } cancelActionBlock:^{
            if (errorBlock) {
                NSDictionary* errorDic = [self getLoginErrorDict];
                errorBlock(errorDic);
            }
        }];
    }
    else {
        callMethod();
    }
}

-(NSMutableDictionary*)getNetUnreachableErrorDictWithResultstring:(NSString*)resultstring{
    NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:9999 userInfo:@{NSLocalizedDescriptionKey: resultstring}];
    NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
    if (error) {
        [errorDic setObject:error forKey:@"responseError"];
    }
    return errorDic;
}

-(NSMutableDictionary*)getCommonErrorDictWithResultstring:(NSString*)resultstring{
    NSError *error = [NSError errorWithDomain:@"apiRequestErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: resultstring?:@"连接成功，请求数据不存在"}];
    NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
    if (error) {
        [errorDic setObject:error forKey:@"responseError"];
    }
    return errorDic;
}

-(NSMutableDictionary*)getLoginErrorDict{
    NSError* error = [NSError errorWithDomain:loginFailDomain code:loginFailCode userInfo:nil];
    NSMutableDictionary* errorDic = [NSMutableDictionary dictionary];
    if (error) {
        [errorDic setObject:error forKey:@"responseError"];
    }
    return errorDic;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark showOrhide network

-(void)showNetworkActivityIndicatorVisible{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideNetworkActivityIndicatorVisible{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark network reachable status
-(BOOL)isNetReachable{
#ifdef _KSAppConfiguration_
    return (KSNetworkReachabilityStatusNotReachable != [[KSAppConfiguration sharedCenter] networkReachabilityStatus]) && (KSNetworkReachabilityStatusUnknown != [[KSAppConfiguration sharedCenter] networkReachabilityStatus]);
#else
    return YES;
#endif
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark mock data network
-(BOOL)didLoadDataFromMockWithApiName:(NSString *)apiName withParam:(NSDictionary *)param onSuccess:(NetworkSuccessBlock)successBlock onError:(NetworkErrorBlock)errorBlock onCancel:(NetworkCancelBlock)cancelBlock{
#ifdef MOCKDATA
    NSString* jsonData = [[KSNetworkDataMock sharedInstantce] getJsonDataWithKey:apiName];
    if (jsonData) {
        NSError* error = nil;
        NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (responseDict) {
            successBlock(responseDict);
            return YES;
        }
    }
#endif
    return NO;
}

@end
