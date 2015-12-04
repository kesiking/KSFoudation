//
//  MQTTClientShareInstance.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/2.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "MQTTClientShareInstance.h"

@interface MQTTClientShareInstance()

@property (readwrite, strong) NSMutableSet    *kMQTTMessageTopicSet;

@property (readwrite, strong) NSMutableSet    *kMQTTMessageTopicSubcribingSet;

/*!
 *  @author 孟希羲, 15-12-04 12:12:07
 *
 *  @brief  默认实现
 *
 *  @since  1.0
 */
- (void)publishMessageToDefaultTopic:(NSString *)payload;

- (void)publishMessageToDefaultTopic:(NSString *)payload completionHandler:(void (^)(int mid))completionHandler;

- (void)subscribeMQTTMessageDefaultTopic;

- (void)unsubscribeMQTTMessageDefaultTopic;

/*!
 *  @author 孟希羲, 15-12-04 12:12:45
 *
 *  @brief  更定制化接口
 *
 *  @since  1.0
 */

- (void)publishMessage:(NSString *)payload toTopic:(NSString *)topic completionHandler:(void (^)(int mid))completionHandler;

- (void)subscribeMQTTMessageWithTopic:(NSString*)topic;

- (void)unsubscribeMQTTMessageWithTopic:(NSString*)topic;

@end

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
    [self disconnectMQTT];
    [self removeNotification];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 初始化
- (void)config{
    _kMQTTMessageTopicSet = [NSMutableSet set];
    _kMQTTMessageTopicSubcribingSet = [NSMutableSet set];
    
    // 初始化MQTT实例
    _client = [[MQTTClient alloc] initWithClientId:MQTTClientDefaultClientID];
    [_client setPort:MQTTClientDefaultPort];
    [_client setUsername:MQTTClientDefaultUsername];
    [_client setPassword:MQTTClientDefaultPassword];
    [_client setKeepAlive:300];
    
    // 连接MQTT
    [self connectMQTTToDefaultHostAndSubcribeMQTTMessage];
    // 添加MQTT消息观察者
    [self addMQTTMessageObserver];
    
    // 注册消息
    [self addNotification];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 连接MQTT
-(void)connectMQTTToDefaultHostAndSubcribeMQTTMessage{
    WEAKSELF
    [self connectMQTTWithHost:MQTTClientDefaultHost completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            STRONGSELF
            // when the client is connected, send a MQTT message
            [strongSelf subscribeMQTTMessageDefaultTopic];
        }
    }];
}

-(void)connectMQTTToDefaultHostWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler{
    [self connectMQTTWithHost:MQTTClientDefaultHost completionHandler:completionHandler];
}

-(void)connectMQTTWithHost:(NSString*)host completionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler{
    [_client connectToHost:host completionHandler:completionHandler];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 连接MQTT
-(void)disconnectMQTT{
    [self disconnectMQTTWithCompletionHandler:^(NSUInteger code) {
        // The client is disconnected when this completion handler is called
        NSLog(@"MQTT client is disconnected");
    }];
}

-(void)disconnectMQTTWithCompletionHandler:(MQTTDisconnectionHandler)completionHandler{
    [_client disconnectWithCompletionHandler:completionHandler];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 添加MQTT消息观察者
-(void)addMQTTMessageObserver{
    WEAKSELF
    [_client setMessageHandler:^(MQTTMessage *message) {
        STRONGSELF
        NSString *text = [message payloadString];
        if (strongSelf.MQTTMessageBlock) {
            strongSelf.MQTTMessageBlock(message, text);
        }
        NSLog(@"received message %@", text);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 向MQTT的主题发布消息
- (void)publishMessageToDefaultTopic:(NSString *)payload{
    [self publishMessageToDefaultTopic:payload completionHandler:nil];
}

- (void)publishMessageToDefaultTopic:(NSString *)payload completionHandler:(void (^)(int mid))completionHandler{
    [self publishMessage:payload toTopic:MQTTClientMessageTopic completionHandler:completionHandler];
}

- (void)publishMessage:(NSString *)payload toTopic:(NSString *)topic completionHandler:(void (^)(int mid))completionHandler{
    if (topic == nil || topic.length == 0) {
        NSLog(@"message topic %@ is error", topic);
        return;
    }
    if (payload == nil || payload.length == 0) {
        NSLog(@"message payload %@ is error", payload);
        return;
    }
    [self.client publishString:payload
                             toTopic:topic
                             withQos:AtMostOnce
                              retain:NO
                   completionHandler:^(int mid) {
                       if (completionHandler) {
                           completionHandler(mid);
                       }
                       NSLog(@"message has been delivered");
                   }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 向MQTT的订阅主题消息
-(void)subscribeMQTTMessageDefaultTopic{
    [self subscribeMQTTMessageWithTopic:MQTTClientMessageTopic];
}

-(void)subscribeMQTTMessageWithTopic:(NSString*)topic{
    if (topic == nil || topic.length == 0) {
        NSLog(@"message topic %@ is error", topic);
        return;
    }
    if ([self.kMQTTMessageTopicSet containsObject:topic]) {
        NSLog(@"message topic %@ has subscribed before", topic);
        return;
    }
    if ([self.kMQTTMessageTopicSubcribingSet containsObject:topic]) {
        NSLog(@"message topic %@ is subscribing now, please hold on moment", topic);
        return;
    }
    
    [self.kMQTTMessageTopicSubcribingSet addObject:topic];
    
    WEAKSELF
    [self.client subscribe:topic withCompletionHandler:^(NSArray *grantedQos) {
        // The client is effectively subscribed to the topic when this completion handler is called
        NSLog(@"subscribed to topic %@", topic);
        STRONGSELF
        [strongSelf.kMQTTMessageTopicSubcribingSet removeObject:topic];
        [strongSelf.kMQTTMessageTopicSet addObject:topic];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 向MQTT的解除已订阅的主题消息
- (void)unsubscribeMQTTMessageDefaultTopic{
    [self unsubscribeMQTTMessageWithTopic:MQTTClientMessageTopic];
}

- (void)unsubscribeMQTTMessageWithTopic:(NSString*)topic{
    if (topic == nil || topic.length == 0) {
        NSLog(@"message topic %@ is error", topic);
        return;
    }
    if (![self.kMQTTMessageTopicSet containsObject:topic]) {
        NSLog(@"message topic %@ has not subscribed before", topic);
        return;
    }
    WEAKSELF
    [self.client unsubscribe:topic withCompletionHandler:^(void) {
        // The client is effectively subscribed to the topic when this completion handler is called
        STRONGSELF
        [strongSelf.kMQTTMessageTopicSet removeObject:topic];
        NSLog(@"subscribed to topic %@", topic);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)applicationDidBecomeActive:(NSNotification*)notification{
    if (_client != nil && _client.host != nil && _client.clientID != nil) {
        [_client reconnect];
    }else if (_client.host != nil && _client.clientID != nil){
        [self connectMQTTToDefaultHostAndSubcribeMQTTMessage];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification method
-(void)applicationDidEnterBackground:(NSNotification*)notification{
    if (_client != nil) {
        [self disconnectMQTT];
    }
}

@end
