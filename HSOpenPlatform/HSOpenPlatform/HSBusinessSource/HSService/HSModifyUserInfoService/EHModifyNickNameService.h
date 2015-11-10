//
//  EHModifyNickNameService.h
//  eHome
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBasicService.h"

@interface EHModifyNickNameService : EHBasicService

-(void)modifyNickNameWithUserPhone:(NSString *)userPhone nickName:(NSString*)nickName;

@end
