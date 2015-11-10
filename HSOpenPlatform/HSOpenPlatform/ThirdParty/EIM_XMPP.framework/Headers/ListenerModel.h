//
//  ListenerModel.h
//  ChatDemo
//
//  Created by yangxiaodong on 15/2/15.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListenerModel : NSObject

@property (nonatomic,copy)NSString *onReConnected;
@property (nonatomic,copy)NSString *onDisConnected;
@property (nonatomic,copy)NSString *onAccountConflict;


@end
