//
//  ChatVoiceDataModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-9.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatVoiceDataModel : NSObject
@property(nonatomic,copy)NSString *voiceUrl;///<语音文件url
@property(nonatomic,copy)NSString *voicePath;///<语音文件路径
@property(nonatomic,copy)NSString *voiceLenth;///<语音长度
@property(nonatomic,copy)NSString *voiceName;///<语音name
@property (nonatomic,copy)NSString *thread; ///唯一名字
@property (nonatomic,copy)NSString *duration;//时间长度

@end
