//
//  HSOtherAppListService.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSOtherAppListService.h"
#import "HSApplicationModel.h"


@implementation HSOtherAppListService

-(void)loadOtherAppListData{
    
    self.itemClass = [HSApplicationModel class];
    self.needCache = YES;
    self.jsonTopKey = RESPONSE_DATA_KEY;
    [self loadDataListWithAPIName:kHSOtherAppInfoListApiName params:nil version:nil];
    
}

@end
