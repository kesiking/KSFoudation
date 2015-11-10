//
//  TBMTOPModelKeyMapper.h
//  TBJSONModel
//
//  Created by Luke on 7/29/13.
//  Copyright (c) 2013 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBJSONModelKeyMapper : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey;
- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey;

@end
