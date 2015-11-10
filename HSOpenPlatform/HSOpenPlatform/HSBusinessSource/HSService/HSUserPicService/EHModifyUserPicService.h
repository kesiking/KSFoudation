//
//  EHModifyUserPicService.h
//  eHome
//
//  Created by xtq on 15/6/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBasicService.h"

@interface EHModifyUserPicService : EHBasicService

-(void)modifyUserPicWithUserPhone:(NSString *)userPhone PicUrl:(NSString*)url SmallPicUrl:(NSString*)smallUrl;

@end
