//
//  KSDebugRequestModel.m
//  HSOpenPlatform
//
//  Created by xtq on 15/12/3.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugRequestModel.h"
#import "KSDebugUtils.h"

@implementation KSDebugRequestModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.receivedData = [[NSMutableData alloc]init];
        
        UIViewController* currentAppearedVC = [KSDebugUtils getCurrentAppearedViewController];
        self.requestedVC = [NSString stringWithFormat:@"%@:%p",NSStringFromClass([currentAppearedVC class]),currentAppearedVC];
        
        self.startTime   = [KSDebugRequestModel getCurrentDate];
        self.endTime     = nil;
        self.spendedTime = 0;
    }
    return self;
}

- (void)setRequest:(NSURLRequest *)request {
    _request = request;
    self.requestURLString = [request.URL absoluteString];
    
    NSDictionary *cachePolicyDic = @{
                                     @"NSURLRequestUseProtocolCachePolicy"               :@0,
                                     @"NSURLRequestReloadIgnoringLocalCacheData"         :@1,
                                     @"NSURLRequestReturnCacheDataElseLoad"              :@2,
                                     @"NSURLRequestReturnCacheDataDontLoad"              :@3,
                                     @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData":@4,
                                     @"NSURLRequestReloadRevalidatingCacheData"          :@5,
                                     };
    
    self.requestCachePolicy     = [cachePolicyDic objectForKey:@(request.cachePolicy)];
    self.requestTimeoutInterval = [[NSString stringWithFormat:@"%.1lf",request.timeoutInterval] doubleValue];
    self.requestHTTPMethod      = request.HTTPMethod;
    
    for (NSString *key in [request.allHTTPHeaderFields allKeys]) {
        self.requestAllHTTPHeaderFields = [NSString stringWithFormat:@"%@%@:%@\n",self.requestAllHTTPHeaderFields,key,[request.allHTTPHeaderFields objectForKey:key]];
    }
    if (self.requestAllHTTPHeaderFields.length > 1) {
        if ([[self.requestAllHTTPHeaderFields substringFromIndex:self.requestAllHTTPHeaderFields.length - 1] isEqualToString:@"\n"]) {
            self.requestAllHTTPHeaderFields = [self.requestAllHTTPHeaderFields substringToIndex:self.requestAllHTTPHeaderFields.length - 1];
        }
    }
    if (self.requestAllHTTPHeaderFields.length > 6) {
        if ([[self.requestAllHTTPHeaderFields substringToIndex:6] isEqualToString:@"(null)"]) {
            self.requestAllHTTPHeaderFields = [self.requestAllHTTPHeaderFields substringFromIndex:6];
        }
    }
    
    if ([request HTTPBody].length > 512) {
        self.requestHTTPBody=@"requestHTTPBody too long";
    }
    else {
        self.requestHTTPBody = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    if (self.requestHTTPBody.length >1 ) {
        if ([[self.requestHTTPBody substringFromIndex:self.requestHTTPBody.length - 1] isEqualToString:@"\n"]) {
            self.requestHTTPBody = [self.requestHTTPBody substringToIndex:self.requestHTTPBody.length - 1 ];
        }
    }
}

- (void)setResponse:(NSHTTPURLResponse *)response {
    _response = response;
    
    long long flowCount = [[[NSUserDefaults standardUserDefaults] objectForKey:KSDebugRequestFlowCountKey] longLongValue];
    if (!flowCount) flowCount = 0;
    flowCount += response.expectedContentLength;
    [[NSUserDefaults standardUserDefaults] setObject:@(flowCount) forKey:KSDebugRequestFlowCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.responseMIMEType              = @"";
    self.responseExpectedContentLength = @"";
    self.responseTextEncodingName      = @"";
    self.responseSuggestedFilename     = @"";
    self.responseStatusCode            = 200;
    self.responseAllHeaderFields       = @"";
    
    self.responseMIMEType              = [response MIMEType];
    self.responseExpectedContentLength = [KSDebugRequestModel getDataLengthStrWithLength:response.expectedContentLength];
    
    self.responseTextEncodingName      = [response textEncodingName];
    self.responseSuggestedFilename     = [response suggestedFilename];
    self.responseStatusCode = response.statusCode;
    
    for (NSString *key in [response.allHeaderFields allKeys]) {
        NSString *headerFieldValue=[response.allHeaderFields objectForKey:key];
        if ([key isEqualToString:@"Content-Security-Policy"]) {
            if ([[headerFieldValue substringFromIndex:12] isEqualToString:@"'none'"]) {
                headerFieldValue=[headerFieldValue substringToIndex:11];
            }
        }
        self.responseAllHeaderFields=[NSString stringWithFormat:@"%@%@:%@\n",self.responseAllHeaderFields,key,headerFieldValue];
    }
    
    if (self.responseAllHeaderFields.length>1) {
        if ([[self.responseAllHeaderFields substringFromIndex:self.responseAllHeaderFields.length-1] isEqualToString:@"\n"]) {
            self.responseAllHeaderFields=[self.responseAllHeaderFields substringToIndex:self.responseAllHeaderFields.length-1];
        }
    }
}

- (void)setEndTime:(NSDate *)endTime {
    _endTime = endTime;
    if (endTime && self.startTime) {
        self.spendedTime = [endTime timeIntervalSinceDate:self.startTime];
    }
}

+ (NSDate *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)getDataLengthStrWithLength:(long long)dataLength {
    if (dataLength < 1024) {
        return [NSString stringWithFormat:@"%lldB",dataLength];
    }
    if (dataLength < 1024*1024) {
        return [NSString stringWithFormat:@"%.3fKB",dataLength/1024.0];
    }
    else {
        return [NSString stringWithFormat:@"%.3fMB",dataLength/1024.0/1024.0];
    }
}

- (NSMutableAttributedString *)getAttributedString{
    
    NSAttributedString *VCNameString;
    NSAttributedString *startDateString;
    NSAttributedString *endDateString;
    NSAttributedString *spendTimeString;
    NSAttributedString *requestURLString;
    NSAttributedString *requestCachePolicyString;
    NSAttributedString *requestTimeoutInterval;
    NSAttributedString *requestHTTPMethod;
    NSAttributedString *requestAllHTTPHeaderFields;
    NSAttributedString *requestHTTPBody;
    NSAttributedString *responseMIMEType;
    NSAttributedString *responseExpectedContentLength;
    NSAttributedString *responseTextEncodingName;
    NSAttributedString *responseSuggestedFilename;
    NSAttributedString *responseStatusCode;
    NSAttributedString *responseAllHeaderFields;
    NSAttributedString *receiveJSONDataStr;
    NSAttributedString *receiveJSONDataJson;
    
    
    NSAttributedString *VCNameStringDetail;
    NSAttributedString *startDateStringDetail;
    NSAttributedString *endDateStringDetail;
    NSAttributedString *spendTimeStringDetail;
    NSAttributedString *requestURLStringDetail;
    NSAttributedString *requestCachePolicyStringDetail;
    NSAttributedString *requestTimeoutIntervalDetail;
    NSAttributedString *requestHTTPMethodDetail;
    NSAttributedString *requestAllHTTPHeaderFieldsDetail;
    NSAttributedString *requestHTTPBodyDetail;
    NSAttributedString *responseMIMETypeDetail;
    NSAttributedString *responseExpectedContentLengthDetail;
    NSAttributedString *responseTextEncodingNameDetail;
    NSAttributedString *responseSuggestedFilenameDetail;
    NSAttributedString *responseStatusCodeDetail;
    NSAttributedString *responseAllHeaderFieldsDetail;
    NSAttributedString *receiveJSONDataStrDetail;
    NSAttributedString *receiveJSONDataJsonDetail;
    
    UIColor *titleColor=[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
    UIFont *titleFont=[UIFont systemFontOfSize:14.0];
    UIColor *detailColor=[UIColor blackColor];
    UIFont *detailFont=[UIFont systemFontOfSize:14.0];
    
    VCNameString                        = [[NSMutableAttributedString alloc] initWithString:@"[VCName]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    startDateString                     = [[NSMutableAttributedString alloc] initWithString:@"[startDate]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    endDateString                       = [[NSMutableAttributedString alloc] initWithString:@"[endDate]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    spendTimeString                     = [[NSMutableAttributedString alloc] initWithString:@"[spendTimeString]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    requestURLString                    = [[NSMutableAttributedString alloc] initWithString:@"[requestURL]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    requestCachePolicyString            = [[NSMutableAttributedString alloc] initWithString:@"[requestCachePolicy]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    requestTimeoutInterval              = [[NSMutableAttributedString alloc] initWithString:@"[requestTimeoutInterval]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    requestHTTPMethod                   = [[NSMutableAttributedString alloc] initWithString:@"[requestHTTPMethod]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    requestAllHTTPHeaderFields          = [[NSMutableAttributedString alloc] initWithString:@"[requestAllHTTPHeaderFields]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    requestHTTPBody                     = [[NSMutableAttributedString alloc] initWithString:@"[requestHTTPBody]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseMIMEType                    = [[NSMutableAttributedString alloc] initWithString:@"[responseMIMEType]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseExpectedContentLength       = [[NSMutableAttributedString alloc] initWithString:@"[responseExpectedContentLength]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseTextEncodingName            = [[NSMutableAttributedString alloc] initWithString:@"[responseTextEncodingName]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseSuggestedFilename           = [[NSMutableAttributedString alloc] initWithString:@"[responseSuggestedFilename]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseStatusCode                  = [[NSMutableAttributedString alloc] initWithString:@"[responseStatusCode]:"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    responseAllHeaderFields             = [[NSMutableAttributedString alloc] initWithString:@"[responseAllHeaderFields]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    if ([self.responseMIMEType isEqualToString:@"application/xml"] ||[self.responseMIMEType isEqualToString:@"text/xml"]) {
        receiveJSONDataStr                  = [[NSMutableAttributedString alloc] initWithString:@"[responseXML]\n"
                                                                                     attributes:@{
                                                                                                  NSFontAttributeName : titleFont,
                                                                                                  NSForegroundColorAttributeName: titleColor
                                                                                                  }];
    }else {
        receiveJSONDataStr                  = [[NSMutableAttributedString alloc] initWithString:@"[responseDataStr]\n"
                                                                                     attributes:@{
                                                                                                  NSFontAttributeName : titleFont,
                                                                                                  NSForegroundColorAttributeName: titleColor
                                                                                                  }];
    }
    
    receiveJSONDataJson                 = [[NSMutableAttributedString alloc] initWithString:@"[responseDataJSON]\n"
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : titleFont,
                                                                                              NSForegroundColorAttributeName: titleColor
                                                                                              }];
    
    
    
    //detail
    
    VCNameStringDetail                  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.requestedVC]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    startDateStringDetail               = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.startTime]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    
    endDateStringDetail                 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.endTime]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    spendTimeStringDetail               = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2fs\n\n",self.spendedTime]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    requestURLStringDetail              = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.requestURLString]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    
    requestCachePolicyStringDetail      = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.requestCachePolicy]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    
    requestTimeoutIntervalDetail        = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lf\n",self.requestTimeoutInterval]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    
    requestHTTPMethodDetail             = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.requestHTTPMethod]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    requestAllHTTPHeaderFieldsDetail    = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.requestAllHTTPHeaderFields]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    requestHTTPBodyDetail               = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",self.requestHTTPBody]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    responseMIMETypeDetail              = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.responseMIMEType]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    responseExpectedContentLengthDetail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.responseExpectedContentLength]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    responseTextEncodingNameDetail      = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.responseTextEncodingName]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    responseSuggestedFilenameDetail     = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.responseSuggestedFilename]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    
    
    UIColor *statusDetailColor=[UIColor colorWithRed:0.96 green:0.15 blue:0.11 alpha:1];
    if (self.responseStatusCode == 200) {
        statusDetailColor=[UIColor colorWithRed:0.11 green:0.76 blue:0.13 alpha:1];
    }
    responseStatusCodeDetail            = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",self.responseStatusCode]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: statusDetailColor
                                                                                              }];
    
    responseAllHeaderFieldsDetail       = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",self.responseAllHeaderFields]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    
    NSString *receiveStr                = [[NSString alloc]initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    receiveJSONDataStrDetail            = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",receiveStr]
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : detailFont,
                                                                                              NSForegroundColorAttributeName: detailColor
                                                                                              }];
    NSError *error                      = nil;
    id jsonObject                       = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    receiveJSONDataJsonDetail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",jsonObject]
                                                                       attributes:@{
                                                                                    NSFontAttributeName : detailFont,
                                                                                    NSForegroundColorAttributeName: detailColor
                                                                                    }];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    
    [attrText appendAttributedString:VCNameString];
    [attrText appendAttributedString:VCNameStringDetail];
    
    [attrText appendAttributedString:startDateString];
    [attrText appendAttributedString:startDateStringDetail];
    
    [attrText appendAttributedString:endDateString];
    [attrText appendAttributedString:endDateStringDetail];
    
    [attrText appendAttributedString:spendTimeString];
    [attrText appendAttributedString:spendTimeStringDetail];
    
    [attrText appendAttributedString:requestURLString];
    [attrText appendAttributedString:requestURLStringDetail];
    
    [attrText appendAttributedString:requestCachePolicyString];
    [attrText appendAttributedString:requestCachePolicyStringDetail];
    
    [attrText appendAttributedString:requestTimeoutInterval];
    [attrText appendAttributedString:requestTimeoutIntervalDetail];
    
    [attrText appendAttributedString:requestHTTPMethod];
    [attrText appendAttributedString:requestHTTPMethodDetail];
    
    [attrText appendAttributedString:requestAllHTTPHeaderFields];
    [attrText appendAttributedString:requestAllHTTPHeaderFieldsDetail];
    
    [attrText appendAttributedString:requestHTTPBody];
    [attrText appendAttributedString:requestHTTPBodyDetail];
    
    [attrText appendAttributedString:responseMIMEType];
    [attrText appendAttributedString:responseMIMETypeDetail];
    
    [attrText appendAttributedString:responseExpectedContentLength];
    [attrText appendAttributedString:responseExpectedContentLengthDetail];
    
    [attrText appendAttributedString:responseTextEncodingName];
    [attrText appendAttributedString:responseTextEncodingNameDetail];
    
    [attrText appendAttributedString:responseSuggestedFilename];
    [attrText appendAttributedString:responseSuggestedFilenameDetail];
    
    [attrText appendAttributedString:responseStatusCode];
    [attrText appendAttributedString:responseStatusCodeDetail];
    
    [attrText appendAttributedString:responseAllHeaderFields];
    [attrText appendAttributedString:responseAllHeaderFieldsDetail];
    
    [attrText appendAttributedString:receiveJSONDataStr];
    [attrText appendAttributedString:receiveJSONDataStrDetail];
    
    [attrText appendAttributedString:receiveJSONDataJson];
    [attrText appendAttributedString:receiveJSONDataJsonDetail];
    
    return attrText;
}


@end
