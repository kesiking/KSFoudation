//
//  HSBusinessDetailListService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSBusinessDetailModel.h"

@interface HSBusinessDetailListService : KSAdapterService

-(void)loadBusinessDetailListWithUserPhone:(NSString*)userPhone productId:(NSString*)productId;

@end
