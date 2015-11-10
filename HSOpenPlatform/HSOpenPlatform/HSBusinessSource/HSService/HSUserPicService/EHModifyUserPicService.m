//
//  EHModifyUserPicService.m
//  eHome
//
//  Created by xtq on 15/6/22.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHModifyUserPicService.h"

@implementation EHModifyUserPicService

-(void)modifyUserPicWithUserPhone:(NSString *)userPhone PicUrl:(NSString*)url SmallPicUrl:(NSString*)smallUrl{
    if (url == nil || smallUrl == nil) {
        EHLogError(@"url is nil");
        return;
    }
    [self loadItemWithAPIName:kHSModifyUserInfoApiName params:@{@"user_phone":userPhone,@"user_head_img":url,@"user_head_img_small":smallUrl,@"flag":@"00001000"} version:nil];
}

@end
