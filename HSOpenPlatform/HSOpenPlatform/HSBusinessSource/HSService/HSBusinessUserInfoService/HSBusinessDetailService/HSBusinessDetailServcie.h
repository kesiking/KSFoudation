//
//  HSBusinessDetailServcie.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSBusinessDetailModel.h"

@interface HSBusinessDetailServcie : KSAdapterService

-(void)loadBusinessDetailListWithUserPhone:(NSString*)userPhone appId:(NSString*)appId businessId:(NSString*)businessId;

@end
