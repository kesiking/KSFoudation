//
//  HSOtherAppInfoService.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSOtherAppInfoService.h"
#import "HSApplicationIntroModel.h"


@implementation HSOtherAppInfoService

-(void)loadOtherAppInfoWithAppId:(NSNumber*)appId{
    if (appId == nil) {
        EHLogInfo(@"appId is nil");
        return;
    }
    self.itemClass = [HSApplicationIntroModel class];
    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:appId forKey:@"appId"];
    
    [self loadItemWithAPIName:kHSOtherAppIntroApiName params:params version:nil];
}


@end
