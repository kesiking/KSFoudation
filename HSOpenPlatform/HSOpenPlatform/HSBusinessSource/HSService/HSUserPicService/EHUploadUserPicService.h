//
//  EHUploadUserPicService.h
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHBasicService.h"
#import "HSUserPicUrl.h"

@interface EHUploadUserPicService : EHBasicService

- (void)uploadImageWithData:(NSData *)imageData UserPhone:(NSString *)userPhone;

@end
