//
//  MQTTClientShareInstance.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MQTTClientDefaultHost       @"iot.eclipse.org"
#define MQTTClientDefaultPort       1883
#define MQTTClientDefaultUsername   @"kesiking"
#define MQTTClientDefaultPassword   @"bt65jukeungeng"

@interface MQTTClientShareInstance : NSObject

@property (nonatomic,strong) NSString                *clientID;

@property (nonatomic,strong) MQTTClient              *client;

+ (instancetype)sharedCenter;

@end
