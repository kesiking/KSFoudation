//
//  VoiceModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-19.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceModel : NSObject
@property (nonatomic,copy) NSString * duration;
@property (nonatomic,copy) NSString * link;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy)NSString *thread;

+(VoiceModel *)pareByDic:(NSDictionary *)dic;
@end
