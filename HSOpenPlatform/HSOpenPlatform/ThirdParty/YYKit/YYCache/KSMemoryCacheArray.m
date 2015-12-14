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
    NSMutableArray      *_storage;
    YYCache             *_cache;
}

- (instancetype)init
{
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if ((self = [super init])) {
        _storage = [NSMutableArray arrayWithCapacity:capacity];
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
        _storage = [NSMutableArray arrayWithCapacity:0];
        _cache = [[YYCache alloc] initWithName:name];
        [self setupCache];
    }
    return self;
}

-(void)setupCache{
    self.memoryCacheArrayCountLimit = KSMemoryCacheArrayCountLimit;
    _cache.memoryCache.countLimit =  self.memoryCacheArrayCountLimit;
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
        _storage = [sparseArray->_storage mutableCopy];
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
    if (idx >= [_storage count]) {
        return nil;
    }
    NSString *numberKey = [_storage objectAtIndex:idx];
    id<NSCoding> object = [_cache objectForKey:numberKey];
    return object;
}

- (void)objectAtIndexedSubscript:(NSUInteger)idx withBlock:(void (^)(NSString *key, id<NSCoding> object))block{
    if (idx >= [_storage count]) {
        block(nil, nil);
        return;
    }
    NSString *numberKey = [_storage objectAtIndex:idx];
    [_cache objectForKey:numberKey withBlock:block];
}

- (void)setObject:(id<NSCoding>)obj atIndexedSubscript:(NSUInteger)idx
{
    [self setObject:obj forKeyedSubscript:@(idx)];
}

- (id)objectForKeyedSubscript:(NSNumber *)key
{
    if ([key integerValue] >= [_storage count]) {
        return nil;
    }
    NSString* numberKey = [_storage objectAtIndex:[key integerValue]];
    return [_cache objectForKey:numberKey];
}

- (void)setObject:(id<NSCoding>)obj forKeyedSubscript:(NSNumber *)key
{
    if (obj) {
        NSString* numberKey = [@([_storage count]) stringValue];
        if ([key integerValue] >= [_storage count]) {
            [_storage addObject:numberKey];
        }else{
            [_storage insertObject:numberKey atIndex:[key integerValue]];
        }
        if (self.needQueueBlock) {
            [_cache setObject:obj forKey:numberKey withBlock:nil];
        }else{
            [_cache setObject:obj forKey:numberKey];
        }
    } else {
        if ([key integerValue] < _storage.count) {
            [_storage removeObjectAtIndex:[key integerValue]];
        }
        [_cache removeObjectForKey:[key stringValue]];
    }
}

- (void)addObject:(id<NSCoding>)anObject{
    if (!anObject) {
        return;
    }
    [self setObject:anObject atIndexedSubscript:[self count]];
}

- (void)addObjectsFromArray:(NSArray *)otherArray withBlock:(void (^)(void))block{
    if (otherArray == nil || ![otherArray isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray* numberKeys = [NSMutableArray array];
    __block NSUInteger count = [_storage count];
    [otherArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSString* numberKey = [@(count) stringValue];
        [numberKeys addObject:numberKey];
        count++;
    }];
    [_storage addObjectsFromArray:numberKeys];
    [_cache setObjects:otherArray forKeys:numberKeys withBlock:block];
}

- (void)insertObject:(id<NSCoding>)anObject atIndex:(NSUInteger)index{
    if (!anObject) {
        return;
    }
    [self setObject:anObject atIndexedSubscript:index];
}

- (void)removeLastObject{
    NSString* numberKey = [_storage lastObject];
    if (numberKey) {
        [_cache removeObjectForKey:numberKey];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    if (index >= [_storage count]) {
        return;
    }
    [_storage removeObjectAtIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self objectAtIndexedSubscript:index];
}

- (void)objectAtIndex:(NSUInteger)index withBlock:(void (^)(NSString *key, id<NSCoding> object))block{
    [self objectAtIndexedSubscript:index withBlock:block];
}

- (NSUInteger)indexOfObject:(id)anObject{
    NSString *indexKey = nil;
    if ([_cache.memoryCache containsObjectForValue:anObject]) {
        NSUInteger count = [_cache.memoryCache totalCount];
        for (NSUInteger indexWithMemory = 0; indexWithMemory < count; indexWithMemory++) {
            NSString* numberKey = [@(indexWithMemory) stringValue];
            id obj = [_cache.memoryCache objectForKey:numberKey];
            if (obj == anObject) {
                indexKey = numberKey;
                break;
            }
        }
    }else{
        NSUInteger count = [_cache.diskCache totalCount];
        for (NSUInteger indexWithDisk = 0; indexWithDisk < count; indexWithDisk++) {
            NSString* numberKey = [@(indexWithDisk) stringValue];
            id obj = [_cache.memoryCache objectForKey:numberKey];
            if (obj == anObject) {
                indexKey = numberKey;
                break;
            }
        }
    }
    if (indexKey) {
        return [_storage indexOfObject:indexKey];
    }
    return NSNotFound;
}

- (NSUInteger)count
{
    return [_storage count];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSParameterAssert(block != nil);
    NSUInteger count = [_storage count];
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
    [_storage removeAllObjects];
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
