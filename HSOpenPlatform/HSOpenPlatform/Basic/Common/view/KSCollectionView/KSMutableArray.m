//
//  KSMutableArray.m
//  eHome
//
//  Created by 孟希羲 on 16/1/12.
//  Copyright © 2016年 com.cmcc. All rights reserved.
//

#import "KSMutableArray.h"

@interface KSMutableArray()

@property(nonatomic, strong) NSMutableIndexSet*  indexSet;

@end

@implementation KSMutableArray

-(NSMutableIndexSet *)indexSet{
    if (_indexSet == nil) {
        _indexSet = [[NSMutableIndexSet alloc] init];
    }
    return _indexSet;
}

-(void)addObject:(id)anObject{
    if ([anObject isKindOfClass:[NSIndexPath class]]) {
        [self.indexSet addIndex:((NSIndexPath*)anObject).row];
    }
    [super addObject:anObject];
}

-(void)addObjectsFromArray:(NSArray *)otherArray{
    [otherArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [self.indexSet addIndex:((NSIndexPath*)obj).row];
        }
    }];
    [super addObjectsFromArray:otherArray];
}

- (void)insertObject: (id)anObject atIndex: (NSUInteger)index
{
    if ([anObject isKindOfClass:[NSIndexPath class]]) {
        [self.indexSet addIndex:((NSIndexPath*)anObject).row];
    }
    [super insertObject:anObject atIndex: index];
}

-(BOOL)containsObject:(id)anObject{
    BOOL containsObject = [super containsObject:anObject];
    if ([anObject isKindOfClass:[NSIndexPath class]]) {
        return containsObject || [self.indexSet containsIndex:((NSIndexPath*)anObject).row];
    }
    return containsObject;
}

-(void)removeObject:(id)anObject{
    if ([anObject isKindOfClass:[NSIndexPath class]]) {
        [self.indexSet removeIndex:((NSIndexPath*)anObject).row];
    }
    [super removeObject:anObject];
}

-(void)removeAllObjects{
    [self.indexSet removeAllIndexes];
    [super removeAllObjects];
}

- (void)dealloc
{
    [_indexSet removeAllIndexes];
    _indexSet = nil;
}

- (NSUInteger)count
{
    return [super count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [super objectAtIndex: index];
}

- (void)removeObjectAtIndex: (NSUInteger)index
{
    id object = [super objectAtIndex:index];
    if ([object isKindOfClass:[NSIndexPath class]]) {
        [self.indexSet removeIndex:((NSIndexPath*)object).row];
    }
    [super removeObjectAtIndex:index];
}

@end
