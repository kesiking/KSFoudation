//
//  HSDeviceListService.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/25.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSDeviceListService : KSAdapterService

-(void)loadUserDeviceListWithUserPhone:(NSString *)userPhone productId:(NSString *)productId;

@end
