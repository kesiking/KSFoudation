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
     ;
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
    _cache.memoryCache.countLimit = 10;
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
    id<NSCoding> object = [_cache.memoryCache objectForKey:key];
    if (!object) {
        object = [_cache.diskCache objectForKey:key];
        if (object && [_cache.memoryCache totalCount] < [_cache.memoryCache countLimit]) {
            [_cache.memoryCache setObject:object forKey:key];
        }
    }
    return object;
}

- (void)setObject:(id<NSCoding>)obj atIndexedSubscript:(NSUInteger)idx
{
    if (obj != nil) {
        [_cache setObject:obj forKey:[@(idx) stringValue]];
    }
}

- (id)objectForKeyedSubscript:(NSNumber *)key
{
    return [_cache objectForKey:[key stringValue]];
}

- (void)setObject:(id<NSCoding>)obj forKeyedSubscript:(NSNumber *)key
{
    if (obj) {
        [_cache setObject:obj forKey:[key stringValue]];
    } else {
        [_cache removeObjectForKey:[key stringValue]];
    }
}

- (void)addObject:(id<NSCoding>)anObject{
    if (!anObject) {
        return;
    }
    NSUInteger count = [self count];
    [self setObject:anObject atIndexedSubscript:count];
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
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [_cache removeObjectForKey:[@(index) stringValue]];
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self objectAtIndexedSubscript:index];
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
    return MAX([_cache.diskCache totalCount], [_cache.memoryCache totalCount]);
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
