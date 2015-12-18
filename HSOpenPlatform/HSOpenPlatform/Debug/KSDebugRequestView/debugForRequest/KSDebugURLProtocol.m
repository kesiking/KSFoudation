//
//  KSDebugURLProtocol.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/2.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugURLProtocol.h"
#import "KSDebugRequestManager.h"
#import "KSDebugRequestModel.h"
#import "KSDebugRequestHostCenter.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface KSDebugURLProtocol ()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) KSDebugRequestModel *requestModel;

@end

@implementation KSDebugURLProtocol

+ (void)registerProtocol {
    [NSURLProtocol registerClass:[KSDebugURLProtocol class]];
}

+ (void)unRegisterProtocol {
    [NSURLProtocol unregisterClass:[KSDebugURLProtocol class]];
}

/**
 *  是否处理对应的request
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request])
    {
        return NO;
    }
    NSString *scheme = [[request URL] scheme];
    NSDictionary *dict = [request allHTTPHeaderFields];
    return [dict objectForKey:@"custom_header"] == nil &&
    ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
     [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame);
}

/**
 *  可修改request
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    if (![KSDebugRequestHostCenter needRedirectInRequset]) {
        return request;
    }
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return [KSDebugRequestHostCenter redirectHostInRequset:mutableReqeust];
}

/**
 *  判断两个request是否相同，如果相同的话可以使用缓存数据，通常只需要调用父类的实现
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

/**
 *  开始相应的request,并标示已经处理过的request
 */
- (void)startLoading
{
    self.requestModel = [[KSDebugRequestModel alloc]init];
    self.requestModel.request = self.request;
    
    NSLog(@"====startLoading====");
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@(YES)
                        forKey:URLProtocolHandledKey
                     inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                    delegate:self];
}

/**
 *  取消相应的request
 */
- (void)stopLoading{
    [self.requestModel.receivedData appendData:self.receivedData];
    self.requestModel.response = (NSHTTPURLResponse *)self.response;
    self.requestModel.endTime = [KSDebugRequestModel getCurrentDate];
    [[KSDebugRequestManager sharedManager].requestArray insertObject:self.requestModel atIndex:0];
    
    [self.connection cancel];
    self.connection = nil;
}


#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
/**
 *  是否使用存储的共享凭证
 */
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

/**
 *  当使用NSURLConnection来请求需要认证的页面的时delegate会先调用协议函数：
 */
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = self.request.URL;
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];

}

//"Use -connection:willSendRequestForAuthenticationChallenge: instead."
//NS_DEPRECATED(10_6, 10_10, 3_0, 8_0
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
//}
//
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge];
//}
//
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSMutableData *)receivedData {
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc]init];
    }
    return _receivedData;
}

@end
