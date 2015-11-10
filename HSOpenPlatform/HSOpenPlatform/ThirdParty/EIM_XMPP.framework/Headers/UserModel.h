//
//  UserModel.h
//  ChatDemo
//
//  Created by yangxiaodong on 15/1/9.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface UserModel : NSObject


@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * nickName;//昵称
@property (nonatomic, copy) NSString * Email;
@property (nonatomic, copy) NSString * subscription;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic,copy)NSString *judge;
@property (nonatomic,copy)NSString *ask;

+(NSArray *)parsedByUserStr:(XMPPIQ *)iq;
+(UserModel *)parsedByUserIq:(XMPPIQ *)iq;
+(NSArray *)parsedByiq:(XMPPIQ *)iq;


@end
