//
//  TBSNSItemList.m
//  Taobao2013
//
//  Created by 逸行 on 13-1-29.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "WeAppItemList.h"

@interface WeAppItemList ()

@property (nonatomic, strong) NSMutableArray*       realItemList;

@end

@implementation WeAppItemList

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSMutableArray

+ (WeAppItemList*)array {
    WeAppItemList* itemList = [[WeAppItemList alloc] init];
    return itemList;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (id)init {
    self.realItemList = [NSMutableArray array];
    self.newDataCount = 0;
    return self;
}

- (NSUInteger)count{
    return [self.realItemList count];
}

- (id)objectAtIndex:(NSUInteger)index{
    if (index < [self.realItemList count]) {
        return [self.realItemList objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)indexOfObject:(id)anObject{
    return [self.realItemList indexOfObject:anObject];
}

- (void)addObject:(id)anObject{
    [self.realItemList addObject:anObject];
}

- (void)addObjectsFromArray:(NSArray *)otherArray{
    [self.realItemList addObjectsFromArray:otherArray];
}

- (void)removeAllObjects{
    [self.realItemList removeAllObjects];
}

- (void)removeObject:(id)anObject{
    [self.realItemList removeObject:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [self.realItemList insertObject:anObject atIndex:index];
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
     [self.realItemList insertObjects:objects atIndexes:indexes];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [self.realItemList removeObjectAtIndex:index];
}

- (void)removeObjectsInArray:(NSArray *)otherArray{
    [self.realItemList removeObjectsInArray:otherArray];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes{
    if (indexes == nil
        || ![indexes isKindOfClass:[NSIndexSet class]]
        || [indexes count] <= 0) {
        return;
    }
    if ([self.realItemList count] <= [indexes count]) {
        return;
    }
    [self.realItemList removeObjectsAtIndexes:indexes];
}

- (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0){
    return [self.realItemList sortedArrayUsingComparator:cmptr];
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)count{
    return [self.realItemList countByEnumeratingWithState:state objects:buffer count:count];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)reset {
    self.currentPage = 0;
    self.totalCount = 0;
    self.newDataCount = 0;
    [self removeAllObjects];
}

- (BOOL)hasMore {
    return self.newDataCount >= self.pageSize;
//    return self.currentPage*self.pageSize < self.totalCount;
}

- (NSArray*)getItemList{
    return _realItemList;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSProxy

- (void)forwardInvocation:(NSInvocation*)invocation {
    if ([self.realItemList respondsToSelector:invocation.selector]) {
        [invocation setTarget:self.realItemList];
    } else {
        [invocation setTarget:self];
    }
    [invocation invoke];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel {
    if ([self.realItemList respondsToSelector:sel]) {
        return [self.realItemList methodSignatureForSelector:sel];
    }
    
    return nil;
}


@end
