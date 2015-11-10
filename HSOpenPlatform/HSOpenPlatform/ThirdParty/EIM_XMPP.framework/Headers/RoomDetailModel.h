//
//  RoomDetailModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-28.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface RoomDetailModel : NSObject
@property (nonatomic,strong) NSString * roomName;//房间名
@property (nonatomic,strong) NSString * depict;//描述
@property (nonatomic,strong) NSString * subject;//主题
@property (nonatomic,strong) NSString * contactsNum;//占有者人数
@property (nonatomic,strong) NSString * createData;//创建日期
@property (nonatomic,copy)NSString *roomJid;

+(RoomDetailModel *)parsedByRoomDetail:(XMPPIQ *)iq;
@end
