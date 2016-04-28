//
//  HSBusinessUserInfoModifyService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSBusinessUserInfoModifyService : KSAdapterService

-(void)modifyBusinessUserInfoWithUserPhone:(NSString *)userPhone memberPhone:(NSString *)memberPhone deviceId:(NSNumber*)deviceId nickName:(NSString*)nickName;

@end
