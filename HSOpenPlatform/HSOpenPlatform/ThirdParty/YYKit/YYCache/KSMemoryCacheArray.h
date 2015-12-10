//
//  KSMemoryCacheArray.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/8.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSMemoryCacheArrayCountLimit (1000)

@interface KSMemoryCacheArray : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger memoryCacheArrayCountLimit;

@property (nonatomic, assign) BOOL needQueueBlock;

- (id)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSparseArray:(KSMemoryCacheArray *)sparseArray NS_DESIGNATED_INITIALIZER;

+ (instancetype)sparseArray;
+ (instancetype)sparseArrayWithCapacity:(NSUInteger)capacity;
+ (instancetype)sparseArrayWithSparseArray:(KSMemoryCacheArray *)sparseArray;

// Use nil object to remove at idx.
- (void)setObject:(id<NSCoding>)obj atIndexedSubscript:(NSUInteger)idx;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)objectAtIndexedSubscript:(NSUInteger)idx withBlock:(void (^)(NSString *key, id<NSCoding> object))block;
// Use nil obj to remove at key.
- (void)setObject:(id<NSCoding>)obj forKeyedSubscript:(NSNumber *)key;
- (id)objectForKeyedSubscript:(NSNumber *)key;

// User as NSMutableArray
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
/*
 对于200000基数，获取某个key
 '直接使用NSMutableArray' measured [Time, seconds] average: 0.028, relative standard deviation: 4.578%, values: [0.030904, 0.026768, 0.026760, 0.027495, 0.027058, 0.027626, 0.026799, 0.028399, 0.029141, 0.028858],
 '使用KSMemoryCacheArray' measured [Time, seconds] average: 0.723, relative standard deviation: 9.389%, values: [0.723737, 0.698857, 0.701223, 0.693413, 0.699719, 0.701247, 0.719311, 0.922482, 0.687052, 0.678485],
 */
- (id)objectAtIndex:(NSUInteger)index;

/*
 对于200000基数，获取某个key
 '使用KSMemoryCacheArray的异步获取' measured [Time, seconds] average: 0.582, relative standard deviation: 10.128%, values: [0.521502, 0.509008, 0.503513, 0.515745, 0.632907, 0.595427, 0.661817, 0.639578, 0.623428, 0.613524],
 */
- (void)objectAtIndex:(NSUInteger)index withBlock:(void (^)(NSString *key, id<NSCoding> object))block;
// 函数性能不好
- (NSUInteger)indexOfObject:(id)anObject;
/*
 对于20000基数
 
 '直接使用NSMutableArray' measured [Time, seconds] average: 0.000, relative standard deviation: 113.946%, values: [0.000002, 0.000001, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],
 
 '使用KSMemoryCacheArray' measured [Time, seconds] average: 2.531, relative standard deviation: 10.358%, values: [2.589457, 2.727221, 2.294212, 2.262713, 2.626776, 2.343007, 3.082039, 2.773024, 2.241870, 2.367270],
 
 '使用KSMemoryCacheArray异步操作' measured [Time, seconds] average: 0.147, relative standard deviation: 10.195%, values: [0.152234, 0.134376, 0.143487, 0.133621, 0.126686, 0.142715, 0.137410, 0.161241, 0.173981, 0.167627],
 */
- (void)addObject:(id<NSCoding>)anObject;
- (void)insertObject:(id<NSCoding>)anObject atIndex:(NSUInteger)index;

@property (readonly, nonatomic) NSUInteger count;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (void)removeAllObjects;

@end
