//
//  KSImageListCache.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/28.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSClearImageListCacheNotification @"KSClearImageListCacheNotification"

@interface KSImageListCache : NSObject

@property (strong, nonatomic) NSCache *memCache;

+ (KSImageListCache *)sharedImageCache;

@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

- (void)removeImageForKey:(NSString *)key;

- (void)clearMemory;

@end
