//
//  FriendRequestModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-13.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef enum
{
    HandleStatusTypeUnhandle = 0,//收到邀请
    HandleStatusTypeBeenAgreed,//被同意
    HandleStatusTypeBeenRefuse,//被拒绝
    HandleStatusTypeBeingdelete//被对方被删除
}HandleStatusType;

@interface FriendRequestModel : NSObject
@property (nonatomic,copy) NSString * requeseId;
@property (nonatomic,copy) NSString * to;
@property (nonatomic,copy) NSString * frome;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * isRead;
@property (nonatomic,copy) NSString * timeStamp;
@property (nonatomic,assign) HandleStatusType handleStatus; // 0.默认，未处理。1.已经同意 2.已经拒绝


@end
