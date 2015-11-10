//
//  ChatListModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-25.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfoModel.h"
@interface ChatListModel : NSObject

@property (copy,nonatomic) NSString       *toUserId;///<to
@property (copy,nonatomic) NSString       *fromUserId;///<from
@property (copy,nonatomic) NSString       *nikName;
@property (copy,nonatomic) NSString       *lastMessage;///<最后一条消息
@property (copy,nonatomic) NSString       *lastTime;///<最后一条消息时间
@property (nonatomic,copy)  NSString      *timeStamp;///<最后一条消息时间戳

@property (copy,nonatomic) NSString       *lastSender;///<最后一条消息的发送人


@property (assign,nonatomic) NSInteger lastMessageType;///<消息类型,0为文本,1为图片,2声音,
@property (assign,nonatomic) NSInteger       chatType;///<会话类型
@property (assign,nonatomic) NSInteger searchNum;
//@property(nonatomic,assign)NSInteger unReadCount;///<未读消息数量

//@property(nonatomic,strong)RoomInfoModel *roomInfoModel;///<房间对象




@end
