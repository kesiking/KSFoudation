//
//  HSProductInfoService.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/23.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSProductInfoModel.h"

@interface HSProductInfoService : KSAdapterService

- (void)loadProductInfoWithProductId:(NSNumber *)productId;

@end
