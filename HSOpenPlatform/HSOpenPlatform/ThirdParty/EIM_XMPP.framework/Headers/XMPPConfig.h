//
//  XMPPConfig.h
//  XMPPSample
//
//  Created by lewis on 14-3-27.
//  Copyright (c) 2014年 com.lanou3g. All rights reserved.
//

#ifndef XMPPSample_XMPPConfig_h
#define XMPPSample_XMPPConfig_h

//openfire服务器IP地址 ！！！！改服务器地址，别忘了历史消息接口的url！！！！
#define  kHostName      @"218.205.81.29"
//openfire服务器端口 默认5222
#define  kHostPort      5222
//openfire域名
//#define kDomin @"li726-26"
//resource
#define kResource @"Smack"
#define openfireName @"openfireName"  ///<openfire的名字
#define xmpp_queueName "com.eqi.xmppRoomQueue"///<room名字

//消息推送
#define PUSH_CRT_TYPE   @"product"  //develop  or product  推送证书类型

#define xmpp_queueStream "com.eqi.xmppStreamQueue"///<消息的queue

#define image_path @"/file/img/"//图片沙盒目录

#define voice_path @"/file/voice/"//语音沙盒目录

/********************50服务器历史消息使用的url********************/
#define XMPP_HMS_PORT 8100
#define XMPP_HMS_GROUP_URL [NSString stringWithFormat:@"http://%@:%i/hms/manage/selectgroup", kHostName, XMPP_HMS_PORT]
#define XMPP_HMS_CHAT_URL [NSString stringWithFormat:@"http://%@:%i/hms/manage/selectchat", kHostName, XMPP_HMS_PORT]
/********************50服务器历史消息使用的url********************/

/********************29服务器历史消息使用的url********************/
//#define XMPP_HMS_GROUP_URL [NSString stringWithFormat:@"http://%@/hms/manage/selectgroup", kHostName]
//#define XMPP_HMS_CHAT_URL [NSString stringWithFormat:@"http://%@/hms/manage/selectchat", kHostName]
/********************29服务器历史消息使用的url********************/

#endif
