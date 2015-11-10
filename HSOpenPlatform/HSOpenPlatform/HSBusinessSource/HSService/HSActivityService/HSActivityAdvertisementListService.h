//
//  HSActivityAdvertisementListService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/13.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSActivityAdvertisementListService : KSAdapterService

-(void)loadActivityAdvertisementListDataWithUserPhone:(NSString*)userPhone;

@end
