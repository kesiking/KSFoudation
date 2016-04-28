//
//  KSAdapterService+AddSignParam.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/16.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "KSAdapterNetWork.h"

@interface KSAdapterService (AddSignParam)

- (AddSignParamBlock)getAddSignParamBlock;

- (NSString *)getReqnoStr;

- (NSString *)getSignStrWithReqnoStr:(NSString *)reqno requestParam:(NSMutableDictionary *)requestParam SerectKey:(NSString *)serectKey;

@end
