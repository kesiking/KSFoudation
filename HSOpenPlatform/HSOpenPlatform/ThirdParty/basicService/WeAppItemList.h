//
//  TBSNSItemList.h
//  Taobao2013
//
//  Created by 逸行 on 13-1-29.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeAppMockedNSMutableArray <NSObject>

+ (id)array;

@optional
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;
- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsInArray:(NSArray *)otherArray;

- (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0);

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

@end


@interface WeAppItemList : NSObject <WeAppMockedNSMutableArray>

@property (nonatomic, assign) NSUInteger        currentPage;
@property (nonatomic, assign) long              totalCount;
@property (nonatomic, assign) NSUInteger        followCount;
@property (nonatomic, assign) NSUInteger        pageSize;
@property (nonatomic, assign) long              newDataCount;

- (id)init;

- (void)reset;
- (BOOL)hasMore;
- (NSArray*)getItemList;

@end
