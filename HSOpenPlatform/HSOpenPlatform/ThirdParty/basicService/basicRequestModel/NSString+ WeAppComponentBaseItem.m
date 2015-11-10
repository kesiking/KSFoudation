//
//  NSString+TBModel.m
//  TBSDK
//
//  Created by christ.yuj on 13-2-25.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "NSString+WeAppComponentBaseItem.h"

@implementation NSString (WeAppComponentBaseItem)

- (unsigned int)weappUnsignedIntValue{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] unsignedIntValue];
}
- (long)weappLongValue{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] longValue];
}
- (unsigned long)weappUnsignedLongValue{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] unsignedLongValue];
}

- (unsigned long long)weappUnsignedLongLongValue{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] unsignedLongLongValue];
}

- (NSUInteger)weappUnsignedIntegerValue{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [[formatter numberFromString:self] unsignedIntegerValue];
}

@end

@implementation NSObject (WeAppComponentBaseItem)

- (unsigned int)weappUnsignedIntValue{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self weappUnsignedIntValue];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)self unsignedIntValue];
    }
    return 0;
}
- (long)weappLongValue{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self weappLongValue];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)self longValue];
    }
    return 0;
}
- (unsigned long)weappUnsignedLongValue{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self weappUnsignedLongValue];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)self unsignedLongValue];
    }
    return 0;
}

- (unsigned long long)weappUnsignedLongLongValue{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self weappUnsignedLongLongValue];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)self unsignedLongLongValue];
    }
    return 0;
}

- (NSUInteger)weappUnsignedIntegerValue{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self weappUnsignedIntegerValue];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)self unsignedIntegerValue];
    }
    return 0;
}

@end
