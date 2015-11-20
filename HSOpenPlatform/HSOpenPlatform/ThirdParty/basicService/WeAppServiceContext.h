//
//  WeAppServiceContext.h
//  eHome
//
//  Created by 孟希羲 on 15/6/11.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeAppServiceContext : NSObject

@property (nonatomic, strong) NSMutableDictionary* serviceContextDict;

@property (nonatomic, strong) NSString*            baseUrl;

// 用于存储额外的数据，与service无关，仅仅是做一个保存等请求成功或是失败时使用
@property (nonatomic, strong) id                   serviceExtContextData;

@end
