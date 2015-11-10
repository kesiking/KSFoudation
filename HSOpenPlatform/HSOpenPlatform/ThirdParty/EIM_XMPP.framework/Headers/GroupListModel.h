//
//  GroupModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-20.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface GroupListModel : NSObject
@property (nonatomic,copy) NSString * groupJid;
@property (nonatomic,copy) NSString * groupName;
+(NSArray *)parsedByUserStr:(XMPPIQ *)iq;
@end
