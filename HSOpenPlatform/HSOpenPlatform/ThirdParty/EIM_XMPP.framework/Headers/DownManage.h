//
//  DownManage.h
//  O了
//
//  Created by on 14-3-14.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGIN_FLAG @"alreadyLogon" //已登录的标识
#define image_path @"/file/img/"//图片沙盒目录
#define voice_path @"/file/voice/"//语音沙盒目录
#define video_path @"/file/video/"//视频沙盒目录



@interface DownManage : NSObject
+(DownManage *)sharedDownload;
-(void)downloadWhithUrl:(NSString *)url fileName:(NSString *)fileName type:(int)type downFinish:(void (^) (NSString *filePath))downFinish downFail:(void (^) (NSError *error))fail;
@end
