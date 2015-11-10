//
//  SetMessageSoundModel.h
//  EIM_XMPP
//
//  Created by lixiao on 15/4/28.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetMessageSoundModel : NSObject

@property (nonatomic, copy) NSString * UserJid;
@property (nonatomic, copy) NSString * messageRemind;
@property (nonatomic, copy) NSString * voice;
@property (nonatomic, copy) NSString * vibration;
@property (nonatomic, copy) NSString * speak;

@end
