//
//  RoomInfoModel.h
//  e企
//
//  Created by roya-7 on 14/11/19.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface RoomInfoModel : NSObject
@property(nonatomic,copy)NSString *roomJid;///<房间jid
@property(nonatomic,copy)NSString *roomName;///<房间名字
@property(nonatomic,retain)NSMutableArray *roomMemberList;///<房间成员列表
@property (nonatomic,retain)NSMutableArray *rooMberNike;//房间成员nike名字
@property(nonatomic,copy)NSString *roomMemberListStr;///<房间成员列表,以;分割


@property (nonatomic,copy)NSString *invitename;//邀请者
@property(nonatomic,copy)NSString *invitenikename;//邀请者昵称
@property (nonatomic,copy)NSString *isinvitername;//被邀请者
@property (nonatomic,copy)NSString *isinviternikename;//被邀请者昵称
@property (nonatomic,copy)NSString *exitgroupname;//退群者
@property (nonatomic,copy)NSString *exitgroupnickname;//退群者昵称
@property (nonatomic,copy)NSString *modityGroupname;//修改群名字的用户


@property (nonatomic,strong) NSString * depict;//描述
@property (nonatomic,strong) NSString * subject;//主题
@property (nonatomic,strong) NSString * contactsNum;//占有者人数
@property (nonatomic,strong) NSString * createData;//创建日期

+(RoomInfoModel *)parsedByRoomDetail:(XMPPIQ *)iq;




+(NSArray *)parsedByUserStr:(XMPPIQ *)iq;
+(RoomInfoModel *)pareMessage:(XMPPMessage *)iq;
@end
