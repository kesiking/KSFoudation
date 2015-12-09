//
//  KSMemoryCacheArray.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/8.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSMemoryCacheArray.h"
#import "YYCache.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface YYMemoryCache (KSMemoryCacheArray)

- (BOOL)containsObjectForValue:(id)value;

@end

@implementation YYMemoryCache (KSMemoryCacheArray)

- (BOOL)containsObjectForValue:(id)value {
    if (!value) return NO;
    OSSpinLock lock = [self getKSMemoryCacheLocked];
    CFMutableDictionaryRef dict = [self getKSMemoryCacheDict];
    OSSpinLockLock(&lock);
    BOOL contains = CFDictionaryContainsValue(dict, (__bridge const void *)(value));
    OSSpinLockUnlock(&lock);
    return contains;
}

-(OSSpinLock)getKSMemoryCacheLocked{
    return [[self valueForKey:@"_lock"] intValue];
}

-(CFMutableDictionaryRef)getKSMemoryCacheDict{
    return (__bridge CFMutableDictionaryRef)([[self valueForKey:@"_lru"] valueForKey:@"_dic"]);
}

@end

@interface YYDiskCache (KSMemoryCacheArray)

- (BOOL)containsObjectForValue:(id)value;

@end

@implementation YYDiskCache (KSMemoryCacheArray)

- (BOOL)containsObjectForValue:(id)value {
    if (!value) return NO;
    OSSpinLock lock = [self getKSMemoryCacheLocked];
    CFMutableDictionaryRef dict = [self getKSMemoryCacheDict];
    OSSpinLockLock(&lock);
    BOOL contains = CFDictionaryContainsValue(dict, (__bridge const void *)(value));
    OSSpinLockUnlock(&lock);
    return contains;
    ;
}

-(OSSpinLock)getKSMemoryCacheLocked{
    return [[self valueForKey:@"_lock"] intValue];
}

-(CFMutableDictionaryRef)getKSMemoryCacheDict{
    return (__bridge CFMutableDictionaryRef)([[self valueForKey:@"_lru"] valueForKey:@"_dic"]);
}

@end

@implementation KSMemoryCacheArray{
    NSMutableDictionary *_storage;
    YYCache             *_cache;
    NSUInteger           _count;
}

- (instancetype)init
{
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if ((self = [super init])) {
        _storage = [NSMutableDictionary dictionaryWithCapacity:capacity];
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        _cache = [[YYCache alloc] initWithName:[@(currentTimeInterval) stringValue]];
        [self setupCache];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if ((self = [super init])) {
        _storage = [NSMutableDictionary dictionaryWithCapacity:0];
        _cache = [[YYCache alloc] initWithName:name];
        [self setupCache];
    }
    return self;
}

-(void)setupCache{
    self.memoryCacheArrayCountLimit = KSMemoryCacheArrayCountLimit;
    _cache.memoryCache.countLimit =  self.memoryCacheArrayCountLimit;
    _count = 0;
    _needQueueBlock = YES;
    
    /*
     [_cache.diskCache setCustomArchiveBlock:^NSData *(id obj) {
     NSError *error = nil;
     if([obj isKindOfClass:[NSData class]]){
     return obj;
     }else if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
     options:0
     error:&error];
     if (jsonData && error == nil) {
     return jsonData;
     }
     }else if ([obj isKindOfClass:[NSString class]]){
     return [obj dataUsingEncoding:NSUTF8StringEncoding];
     }else if (obj){
     return [NSKeyedArchiver archivedDataWithRootObject:obj];
     }
     return nil;
     }];
     [_cache.diskCache setCustomUnarchiveBlock:^id(NSData *objData) {
     if (objData) {
     NSError *error = nil;
     id jsonStr = [NSJSONSerialization JSONObjectWithData:objData options:NSJSONReadingMutableContainers error:&error];
     if (jsonStr && error == nil) {
     return jsonStr;
     }
     return [NSKeyedUnarchiver unarchiveObjectWithData:objData];
     }
     return nil;
     }];
    */

}

-(void)setMemoryCacheArrayCountLimit:(NSUInteger)memoryCacheArrayCountLimit{
    _memoryCacheArrayCountLimit = memoryCacheArrayCountLimit;
    _cache.memoryCache.countLimit = memoryCacheArrayCountLimit;
}

- (instancetype)initWithSparseArray:(KSMemoryCacheArray *)sparseArray
{
    if ((self = [super init])) {
        _storage = [sparseArray->_storage copy];
        _cache = [[YYCache alloc] initWithName:sparseArray->_cache.name];
    }
    return self;
}

+ (instancetype)sparseArray
{
    return [self new];
}

+ (instancetype)sparseArrayWithCapacity:(NSUInteger)capacity
{
    return [[self alloc] initWithCapacity:capacity];
}

+ (instancetype)sparseArrayWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

+ (instancetype)sparseArrayWithSparseArray:(KSMemoryCacheArray *)sparseArray
{
    return [[self alloc] initWithSparseArray:sparseArray];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    NSString *key = [@(idx) stringValue];
    id<NSCoding> object = [_cache objectForKey:key];
    return object;
}

- (void)objectAtIndexedSubscript:(NSUInteger)idx withBlock:(void (^)(NSString *key, id<NSCoding> object))block{
    NSString *key = [@(idx) stringValue];
    [_cache objectForKey:key withBlock:block];
}

- (void)setObject:(id<NSCoding>)obj atIndexedSubscript:(NSUInteger)idx
{
    [self setObject:obj forKeyedSubscript:@(idx)];
}

- (id)objectForKeyedSubscript:(NSNumber *)key
{
    return [_cache objectForKey:[key stringValue]];
}

- (void)setObject:(id<NSCoding>)obj forKeyedSubscript:(NSNumber *)key
{
    if (obj) {
        if (self.needQueueBlock) {
            WEAKSELF
            [_cache setObject:obj forKey:[key stringValue] withBlock:^{
                STRONGSELF
                strongSelf->_count++;
            }];
        }else{
            [_cache setObject:obj forKey:[key stringValue]];
            _count++;
        }
    } else {
        [_cache removeObjectForKey:[key stringValue]];
        _count--;
    }
}

- (void)addObject:(id<NSCoding>)anObject{
    if (!anObject) {
        return;
    }
    [self setObject:anObject atIndexedSubscript:_count + 1];
}

- (void)insertObject:(id<NSCoding>)anObject atIndex:(NSUInteger)index{
    if (!anObject) {
        return;
    }
    [self setObject:anObject atIndexedSubscript:index];
}

- (void)removeLastObject{
    NSUInteger count = [self count];
    if (count >= 1) {
        [_cache removeObjectForKey:[@(count - 1) stringValue]];
        _count--;
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [_cache removeObjectForKey:[@(index) stringValue]];
    _count--;
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self objectAtIndexedSubscript:index];
}

- (void)objectAtIndex:(NSUInteger)index withBlock:(void (^)(NSString *key, id<NSCoding> object))block{
    [self objectAtIndexedSubscript:index withBlock:block];
}

- (NSUInteger)indexOfObject:(id)anObject{
    NSUInteger index = NSNotFound;
    if ([_cache.memoryCache containsObjectForValue:anObject]) {
        NSUInteger count = [_cache.memoryCache totalCount];
        for (NSUInteger indexWithMemory = 0; indexWithMemory < count; indexWithMemory++) {
            id obj = [_cache.memoryCache objectForKey:[@(indexWithMemory) stringValue]];
            if (obj == anObject) {
                index = indexWithMemory;
                break;
            }
        }
    }else{
        NSUInteger count = [_cache.diskCache totalCount];
        for (NSUInteger indexWithDisk = 0; indexWithDisk < count; indexWithDisk++) {
            id obj = [_cache.memoryCache objectForKey:[@(indexWithDisk) stringValue]];
            if (obj == anObject) {
                index = indexWithDisk;
                break;
            }
        }
    }
    return index;
}

- (NSUInteger)count
{
    NSUInteger count = MAX([_cache.diskCache totalCount], [_cache.memoryCache totalCount]);
    if (_count != count) {
        _count = count;
    }
    return _count;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSParameterAssert(block != nil);
    NSUInteger count = [self count];
    BOOL stop = NO;
    for (NSUInteger index = 0; index < count; index++) {
        id obj = [self objectAtIndex:index];
        if (obj) {
            block(obj, index, &stop);
        }
        if (stop) {
            break;
        }
    }
}

- (void)removeAllObjects
{
    [_cache removeAllObjects];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithSparseArray:self];
}

- (NSString *)description
{
    return [super.description stringByAppendingString:_cache.description];
}

@end
