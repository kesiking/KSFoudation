//
//  KSDebugRequestModel.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/3.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const KSDebugRequestFlowCountKey = @"KSDebugRequestFlowCountKey";

@interface KSDebugRequestModel : NSObject

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSHTTPURLResponse *response;

@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) NSString *requestedVC;  //!< 发起请求的VC（名称：地址）

@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, strong) NSDate *endTime;

@property (nonatomic, assign) NSTimeInterval spendedTime;

//request
@property (nonatomic, strong) NSString *requestURLString;
@property (nonatomic, strong) NSString *requestCachePolicy;
@property (nonatomic, assign) CGFloat   requestTimeoutInterval;
@property (nonatomic, strong) NSString *requestHTTPMethod;
@property (nonatomic, strong) NSString *requestAllHTTPHeaderFields;
@property (nonatomic, strong) NSString *requestHTTPBody;

//response
@property (nonatomic, strong) NSString *responseMIMEType;
@property (nonatomic, strong) NSString *responseExpectedContentLength;
@property (nonatomic, strong) NSString *responseTextEncodingName;
@property (nonatomic, strong) NSString *responseSuggestedFilename;
@property (nonatomic, assign) NSInteger responseStatusCode;
@property (nonatomic, strong) NSString *responseAllHeaderFields;

//JSONData
@property (nonatomic, strong) NSString *receiveJSONData;

+ (NSDate *)getCurrentDate;

+ (NSString *)getDataLengthStrWithLength:(long long)dataLength;

- (NSMutableAttributedString *)getAttributedString;

@end


