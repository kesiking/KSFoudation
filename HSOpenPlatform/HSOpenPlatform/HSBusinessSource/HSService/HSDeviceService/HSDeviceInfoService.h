//
//  HSDeviceInfoService.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSDeviceInfoService : KSAdapterService

- (void)loadDeviceInfoWithUserPhone:(NSString *)userPhone deviceId:(NSNumber *)deviceId;


@end
