//
//  HSNationalAfterSaleService.h
//  HSOpenPlatform
//
//  Created by xtq on 15/11/9.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSNationalAfterSaleModel.h"

@interface HSNationalAfterSaleService : KSAdapterService

- (void)getNationalAfterSaleWithAppId:(NSString *)appId;

@end
