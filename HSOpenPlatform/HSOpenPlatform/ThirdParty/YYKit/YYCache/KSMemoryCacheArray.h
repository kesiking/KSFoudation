//
//  KSMemoryCacheArray.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/8.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMemoryCacheArray : NSObject <NSCopying>

- (id)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSparseArray:(KSMemoryCacheArray *)sparseArray NS_DESIGNATED_INITIALIZER;

+ (instancetype)sparseArray;
+ (instancetype)sparseArrayWithCapacity:(NSUInteger)capacity;
+ (instancetype)sparseArrayWithSparseArray:(KSMemoryCacheArray *)sparseArray;

// Use nil object to remove at idx.
- (void)setObject:(id<NSCoding>)obj atIndexedSubscript:(NSUInteger)idx;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

// Use nil obj to remove at key.
- (void)setObject:(id<NSCoding>)obj forKeyedSubscript:(NSNumber *)key;
- (id)objectForKeyedSubscript:(NSNumber *)key;

// User as NSMutableArray
- (void)addObject:(id<NSCoding>)anObject;
- (void)insertObject:(id<NSCoding>)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (id)objectAtIndex:(NSUInteger)index;
// 该函数性能不好
- (NSUInteger)indexOfObject:(id)anObject;

@property (readonly, nonatomic) NSUInteger count;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (void)removeAllObjects;

@end
