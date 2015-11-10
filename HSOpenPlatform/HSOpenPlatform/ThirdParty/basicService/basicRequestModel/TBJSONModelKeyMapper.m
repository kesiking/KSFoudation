//
//  TBMTOPModelKeyMapper.m
//  TBJSONModel
//
//  Created by Luke on 7/29/13.
//  Copyright (c) 2013 taobao. All rights reserved.
//

#import "TBJSONModelKeyMapper.h"

@interface TBJSONModelKeyMapper()
@property(strong,nonatomic) NSMutableDictionary *jsonToModelMap;
@property(strong,nonatomic) NSMutableDictionary *modelToJsonMap;

@end

@implementation TBJSONModelKeyMapper

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self != nil) {
        self.jsonToModelMap = [[NSMutableDictionary alloc] initWithDictionary:dict];
        self.modelToJsonMap = [[NSMutableDictionary alloc] initWithCapacity:[dict count]];
        for (NSString *key in dict) {
            self.modelToJsonMap[dict[key]] = key;
        }
    }
    return self;
}


- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey{
    NSString *mapped =  [self.jsonToModelMap objectForKey:jsonKey];
    return mapped ? mapped : jsonKey;
}

- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey{
    NSString *mapped = [self.modelToJsonMap objectForKey:modelKey];
    return mapped ? mapped : modelKey;
}

@end
