//
//  ChatVideoModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-9.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatVideoModel : NSObject
@property(nonatomic,copy)NSString *createTime;///<创建时间
@property(nonatomic,copy)NSString *duration;///<视频长度(秒)
@property(nonatomic,copy)NSString *filesize;///<视频大小
@property(nonatomic,copy)NSString *media_uuid;///<消息uuid
@property(nonatomic,copy)NSString *original_link;///<视频连接
@property(nonatomic,copy)NSString *title;///<title

@end
