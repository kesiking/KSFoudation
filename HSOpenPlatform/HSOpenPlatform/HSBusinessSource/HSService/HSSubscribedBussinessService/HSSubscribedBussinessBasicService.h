//
//  HSSubscribedBussinessBasicService.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

#define comboSubscribedBussinessKey             @"combo"
#define familySubscribedBussinessKey            @"family"
#define incrementSubscribedBussinessKey         @"increment"
#define preferentialSubscribedBussinessKey      @"preferential"

@interface HSSubscribedBussinessBasicService : KSAdapterService

-(void)loadSubscribedBussinessDataListWithUserPhone:(NSString*)userPhone bussinessId:(NSString*)bussinessId;

@end
