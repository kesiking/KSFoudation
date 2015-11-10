//
//  KSImageListCache.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/28.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSImageListCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation KSImageListCache

+ (KSImageListCache *)sharedImageCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config{
    _memCache = [[NSCache alloc] init];
    _memCache.name = @"KSIMAGELISTCACHE";
    
    _ioQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemory)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemory)
                                                 name:KSClearImageListCacheNotification
                                               object:nil];
    
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    NSString* fileKey = [self getImageKeyWithKey:key];
    if (fileKey == nil) {
        return nil;
    }
    return [self.memCache objectForKey:fileKey];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    if (!image || !key) {
        return;
    }
    NSString* fileKey = [self getImageKeyWithKey:key];
    if (fileKey == nil) {
        return;
    }
    [self.memCache setObject:image forKey:fileKey cost:image.size.height * image.size.width * image.scale];
}

- (void)removeImageForKey:(NSString *)key{
    if (key == nil) {
        return;
    }
    NSString* fileKey = [self getImageKeyWithKey:key];
    if (fileKey == nil) {
        return;
    }
    [self.memCache removeObjectForKey:fileKey];
}

-(NSString*)getImageKeyWithKey:(NSString*)key{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

- (void)clearMemory {
    [self.memCache removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SDDispatchQueueRelease(_ioQueue);
}

@end
