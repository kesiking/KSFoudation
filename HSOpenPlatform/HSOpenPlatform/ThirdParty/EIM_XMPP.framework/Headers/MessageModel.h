//
//  MessageModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-9.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatImageDataModel.h"
#import "ChatVideoModel.h"
#import "ChatVoiceDataModel.h"
#import "XMPPMessage.h"
#import "XMPPFramework.h"
#import "RoomDetailModel.h"

@interface MessageModel : NSObject

@property (nonatomic, assign)BOOL isShowTime;//是否显示时间

@property(nonatomic,assign)NSInteger chatType;///<聊天类型,0为单聊,1为群聊,3为群发消息
@property(nonatomic,assign)NSInteger fileType;///<文件类型,0为普通文本,1为图片,2为声音,7为群组创建信息,8为单点登录消息(收到要下线),3为服务号消息,4为视频消息

@property (nonatomic,copy)NSString *timestatic;
@property(nonatomic,copy)NSString * msg;//消息内容
@property(nonatomic,copy)NSString * from;
@property(nonatomic,copy)NSString * to;
@property(nonatomic,copy)NSString * receivedTime;
//时间戳 ，以后可能将时间换成时间戳
@property(nonatomic,copy)NSString * timeStamp;
@property(nonatomic,copy)NSString *  isSend;
@property(nonatomic,copy)NSString *messageID;///<消息id
@property(nonatomic,copy)NSString *thread;///<消息提thread
@property(nonatomic,copy)NSString *roomInfo;///<房间的jid
@property(nonatomic,copy)NSString * isRead;
@property(nonatomic,copy)NSString *nameListStr;///<如果聊天类型是群发消息,名字
@property (nonatomic,copy)NSString *prompt;
@property (nonatomic,copy)NSString *hint;
@property (nonatomic,copy)NSString *sendUsername;
@property (nonatomic,copy)NSString *guid;//历史消息id
@property (nonatomic, assign) int offlineCount; //离线消息条数

@property(nonatomic,retain)ChatImageDataModel *imageChatData;///<图片对象
@property(nonatomic,strong)ChatVoiceDataModel *chatVoiceData;///<语音对象
@property(nonatomic,strong)ChatVideoModel *chatVideoModel;///<视频对象
@property (nonatomic,strong)RoomDetailModel *roomdetailmodel;//房间详情


+(MessageModel *)parsedByMessageStr:(XMPPMessage *)message error:(NSError *)er;
@end

