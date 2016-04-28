//
//  KSDebugDataCollection.h
//  HSOpenPlatform
//
//  Created by xtq on 15/12/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugDataCollection : NSObject

@property (nonatomic, assign) NSUInteger maxDataLength;     //default is 1024*1024

+ (void)configWithServerAddress:(NSString *)serverAddress;

+ (instancetype)sharedCollection;


- (void)addObject:(NSDictionary *)dic forDebug:(NSString *)debugName;

- (void)removeObject:(NSDictionary *)dic forDebug:(NSString *)debugName;

- (void)removeAllObject;


- (void)uploadDataCollection;

@end
