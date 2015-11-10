//
//  NSArray+TBMTOPModel.m
//  taobao4ipad
//
//  Created by Luke on 8/9/13.
//  Copyright (c) 2013 taobao. All rights reserved.
//

#import "NSArray+TBJSONModel.h"
#import "WeAppComponentBaseItem.h"

@implementation NSArray(TBJSONModel)

- (NSArray *)modelArrayWithClass:(Class)modelClass{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayWithClass:modelClass]];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithDictionary:object]];
        }else{
            [modelArray addObject:object];
        }
    }
    return modelArray;
}


- (NSArray *)toArray{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (id object in self) {
        if ([object isKindOfClass:[WeAppComponentBaseItem class]]) {
            NSDictionary *objectDict = [(WeAppComponentBaseItem *)object toDictionary];
            [jsonArray addObject:objectDict];
        }else if ([object isKindOfClass:[NSArray class]]){
            [jsonArray addObject:[object toArray]];
        }else{
            [jsonArray addObject:object];
        }
    }
    
    return jsonArray;
}

@end
