//
//  ChatHistoryRequestModel.h
//  EIM_XMPP
//
//  Created by huichen on 15/4/24.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryMessageRequestModel : NSObject

/**
 初始化一个用于单聊历史消息查询的model
 aTo: 消息会话对方名称（JID的node部分 如 ming9#888877vv）
 aBegin: 开始查询的guid,第一页查询允许为null，后面查询需要设置
 aEnd: 查询的上限guid，可以不设置
 aLimit: 返回消息数
 aDirection: 查询方向，NO正序查询，YES倒序查询。根据时间排序
 */
- (id)initWithToJID:(NSString*)aTo beginGuid:(NSString*)aBegin endGuid:(NSString*)aEnd limit:(int)aLimit direction:(BOOL)aDirection;

/**
 初始化一个用于群组历史消息查询的model
 aGroup: 群组名称 （JID的node部分，如 an1429691881924#888877vv）
 aBegin: 开始查询的guid,第一页查询允许为null，后面查询需要设置
 aEnd: 查询的上限guid，可以不设置
 aLimit: 返回消息数
 aDirection: 查询方向，NO正序查询，YES倒序查询。根据时间排序
 */
- (id)initWithGourpName:(NSString*)aGroup beginGuid:(NSString*)aBegin endGuid:(NSString*)aEnd limit:(int)aLimit direction:(BOOL)aDirection;

/**
    是否是请求群组历史消息的model
 */
- (BOOL)isRequestGroupMessages;

/**
    获取model的json用于请求数据
 */
- (NSDictionary*)getModelJson;

/**
 当调用getModelJson返回nil时，通过此方法查询具体参数错误
 错误码含义参考XMPPManagerErrorCode
 0 表示 无错误
 */
- (int)getJsonErrorCode;

@end
