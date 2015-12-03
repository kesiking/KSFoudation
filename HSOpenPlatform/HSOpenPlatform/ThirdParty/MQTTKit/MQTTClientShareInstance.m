//
//  MQTTClientShareInstance.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "MQTTClientShareInstance.h"

@implementation MQTTClientShareInstance

+ (instancetype)sharedCenter {
    static id sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)dealloc{
    
}

- (void)config{
    _client = [[MQTTClient alloc] initWithClientId:self.clientID];
    [_client setPort:MQTTClientDefaultPort];
    [_client setUsername:MQTTClientDefaultUsername];
    [_client setPassword:MQTTClientDefaultPassword];
    WEAKSELF
    [_client connectToHost:MQTTClientDefaultHost completionHandler:^(NSUInteger code) {
        if (code == ConnectionAccepted) {
            STRONGSELF
            // when the client is connected, send a MQTT message
            [strongSelf.client publishString:@"Hello, MQTT"
                                     toTopic:@"/MQTTKit/example"
                                     withQos:AtMostOnce
                                      retain:NO
                           completionHandler:^(int mid) {
                               NSLog(@"message has been delivered");
                           }];
        }
    }];
}

@end
