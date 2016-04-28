//
//  HSOtherAppInfoService.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSOtherAppInfoService : KSAdapterService

-(void)loadOtherAppInfoWithAppId:(NSNumber*)appId;

@end
