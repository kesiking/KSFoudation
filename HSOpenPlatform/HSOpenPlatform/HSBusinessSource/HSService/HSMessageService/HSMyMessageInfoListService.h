//
//  HSMessageService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"
#import "HSMyMessageModel.h"

@interface HSMyMessageInfoListService : KSAdapterService

-(void)loadMyMessageInfoListWithUserPhone:(NSString*)userPhone;

@end
