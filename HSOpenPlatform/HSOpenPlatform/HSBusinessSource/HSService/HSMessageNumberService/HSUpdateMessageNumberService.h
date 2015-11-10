//
//  EHUpdateMessageNumberService.h
//  eHome
//
//  Created by 孟希羲 on 15/6/30.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "KSAdapterService.h"

@interface HSUpdateMessageNumberService : KSAdapterService

-(void)updateMessageNumberWithUserPhone:(NSString *)userPhone;

@end
