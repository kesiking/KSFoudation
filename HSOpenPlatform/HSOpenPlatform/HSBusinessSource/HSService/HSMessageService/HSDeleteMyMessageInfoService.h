//
//  HSDeleteMyMessageInfoService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSDeleteMyMessageInfoService : KSAdapterService

-(void)deleteMyMessagesInfoWithUserPhone:(NSString*)userPhone messageIds:(NSArray*)messageIds;

@end
