//
//  KSDebugDataCollection.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//
//  上传JSON格式：  app_Name：                NSString
//                app_Version:
//                app_build:
//                identifier:
//                uploadDate:
//                KSDebugDataCollection:    NSArray

static NSString * const KSDebugDataCollectionKey = @"KSDebugDataCollection";

#import "KSDebugDataCollection.h"

@interface KSDebugDataCollection () <NSURLSessionDelegate>

@property (nonatomic, strong) NSString *serverAddress;

@property (nonatomic, strong) NSMutableDictionary *debugDic;    //数据收集

@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic) NSURLSession                *session;

@property (nonatomic) NSURLSessionDataTask        *dataTask;

@property (nonatomic, assign) BOOL                 isUploading;

@property (nonatomic, strong) NSMutableDictionary *backupDic;  //临时备用字典

@end

@implementation KSDebugDataCollection

- (instancetype)init {
    if (self = [super init]) {
        _maxDataLength = 1024 * 1024;
        
        _debugDic = [[NSMutableDictionary alloc]init];
        
        _session = [self backgroundSession];
        _isUploading = NO;
        _backupDic = [[NSMutableDictionary alloc]init];
        [self addNotification];
    }
    return self;
}

+ (instancetype)sharedCollection {
    static id sharedCollection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCollection = [[self alloc]init];
    });
    return sharedCollection;
}

+ (void)configWithServerAddress:(NSString *)serverAddress {
    [KSDebugDataCollection sharedCollection].serverAddress = serverAddress;
}

- (void)setServerAddress:(NSString *)serverAddress {
    _serverAddress = serverAddress;
    NSURL *url = [NSURL URLWithString:serverAddress];
    _request = [NSMutableURLRequest requestWithURL:url];
}

/**
 *  如果正在上传中，则用备用字典来收集数据。若上传成功，则清空原字典并添加备用字典，若失败，则在原字典上添加备用字典。（考虑在上传过程中又收集到新的数据的特殊情况）
 */
- (void)addObject:(NSDictionary *)dic forDebug:(NSString *)debugName {
    if (!_isUploading) {
        NSMutableArray *muArray = [_debugDic objectForKey:debugName];
        if (!muArray) {
            muArray = [[NSMutableArray alloc]init];
        }
        [muArray addObject:dic];
        [_debugDic setObject:muArray forKey:debugName];

    }
    else {
        NSMutableArray *muArray = [_backupDic objectForKey:debugName];
        if (!muArray) {
            muArray = [[NSMutableArray alloc]init];
        }
        [muArray addObject:dic];
        [_backupDic setObject:muArray forKey:debugName];
        return;
    }

    if ([self dataLengthOfDic:_debugDic] > self.maxDataLength) {
        [self uploadDataCollection];
    }
}

- (void)removeObject:(NSDictionary *)dic forDebug:(NSString *)debugName {
    [_debugDic removeObjectForKey:debugName];
}

- (void)removeAllObject {
    [_debugDic removeAllObjects];
}


- (void)uploadDataCollection {
    if (_isUploading) return;
    _isUploading = YES;
    if (_backupDic.count > 0) {
        [_backupDic removeAllObjects];
    }
    
    NSMutableDictionary *uploadDic = [[self dicOfAppInfo] mutableCopy];
    if (_debugDic) {
        [uploadDic setObject:[_debugDic mutableCopy] forKey:@"KSDebugDataCollection"];
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:uploadDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@",error);
        _isUploading = NO;
        return;
    }
    [_request setHTTPBody:data];
    
    self.dataTask = [self.session dataTaskWithRequest:_request];
    [self.dataTask resume];
}

#pragma mark - Private Methods
- (NSUInteger)dataLengthOfDic:(NSDictionary *)dic {
    if (!dic) {
        return 0;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"JSON Error:%@",error);
    return jsonData.length;
}

- (void)mergeNewDic:(NSMutableDictionary *)newDic toOriginalDic:(NSMutableDictionary *)OriginalDic {
    for (NSString *keyName in newDic.allKeys) {
        NSMutableArray *newSubArr = [newDic objectForKey:keyName];
        NSMutableArray *originalSubArr = [OriginalDic objectForKey:keyName];
        for (id object in newSubArr) {
            [originalSubArr addObject:object];
        }
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = self.request.URL;
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"CompleteWithError:%@",error);
    _isUploading = NO;
    if (error) {
        if (_backupDic.count > 0) {
            [self mergeNewDic:_backupDic toOriginalDic:_debugDic];
            [_backupDic removeAllObjects];
        }
    }
    else {
        _debugDic = [_backupDic mutableCopy];
    }
}

#pragma mark - Getters
- (NSURLSession *)backgroundSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"KSDebugDataCollectionSession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

- (NSMutableDictionary *)dicOfAppInfo {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    // app bundleId
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    //AppName、AppBundleID、UploadDate
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *dateStr = [NSString stringWithFormat:@"%@",localeDate];
    
    [dic setObject:app_Name forKey:@"app_Name"];
    [dic setObject:app_Version forKey:@"app_Version"];
    [dic setObject:app_build forKey:@"app_build"];
    [dic setObject:identifier forKey:@"identifier"];
    [dic setObject:dateStr forKey:@"uploadDate"];

    return dic;
}


#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadDataCollection) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//当切换到后台时，如果数据量达到最大值一半就进行上传。
- (void)applicationDidEnterBackground {
    if ([self dataLengthOfDic:_debugDic] > self.maxDataLength/2) {
        [self uploadDataCollection];
    }
}


- (void)dealloc {
    [self removeNotification];
}

@end
