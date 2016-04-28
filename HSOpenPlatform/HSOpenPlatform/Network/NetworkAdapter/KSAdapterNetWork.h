//
//  KSAdapterNetWork.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-21.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "BasicNetWorkAdapter.h"

static NSString* const KSAdapterNetWorkResponseStatusCode_Success = @"0000";

typedef NSMutableDictionary* (^AddSignParamBlock)(NSMutableDictionary *param);
typedef void (^HSURLConnectionOperationAuthenticationChallengeBlock)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge);

@interface KSAdapterNetWork : BasicNetWorkAdapter

@property (nonatomic, assign) BOOL              needLogin;
@property (nonatomic, assign) BOOL              needAuthenticationChallenge;    //是否需要验证连接
@property (nonatomic, retain) AFSecurityPolicy  *securityPolicy;            //验证的安全策略
@property (nonatomic, copy  ) AddSignParamBlock addSignParamBlock;          //请求参数添加签名

@end
