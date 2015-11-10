//
//  KSErrorProtocol.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSErrorProtocol <NSObject>

//! 服务器返回的错误码
@property (nonatomic, strong) NSString                    *errorCode;

//! 错误信息
@property (nonatomic, strong) NSString                    *msg;

//! 子错误代码
@property (nonatomic, strong)  NSString                   *sub_code;

//! 子错误信息
@property (nonatomic, strong)  NSString                   *sub_msg;

//! 调用接口时传递的参数
@property (nonatomic, strong)  NSDictionary               *args;

@end
