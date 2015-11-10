//
//  EHUploadUserPicService.m
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHUploadUserPicService.h"
@implementation EHUploadUserPicService

- (void)uploadImageWithData:(NSData *)imageData UserPhone:(NSString *)userPhone{
    if (imageData == nil) {
        EHLogError(@"imageData is nil");
        return;
    }
    if (userPhone == nil) {
        userPhone = [KSLoginComponentItem sharedInstance].user_phone;
    }
    self.itemClass = [HSUserPicUrl class];
    self.jsonTopKey = @"responseData";
    
    [self uploadFileWithAPIName:kHSUploadUserPicApiName withFileName:[self fileName] withFileContent:imageData params:@{@"user_phone":userPhone,@"fileName":[self fileName]} version:nil];
}

-(NSString *)fileName{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[self uuid]];
    return fileName;
}

- (NSString*)uuid{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
