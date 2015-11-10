//
//  KSNetworkDataMock.m
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/27.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSNetworkDataMock.h"

@interface KSNetworkDataMock()

@property (nonatomic, strong)  NSMutableDictionary *         networkMockDict;

@end

@implementation KSNetworkDataMock

+ (instancetype)sharedInstantce {
    static id sharedInstantce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstantce = [[self alloc] init];
    });
    return sharedInstantce;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMock];
    }
    return self;
}

-(void)setupMock{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"KSNetworkDataMock" ofType:@"plist"];
    NSDictionary* mockDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (mockDict) {
        [self.networkMockDict addEntriesFromDictionary:mockDict];
    }
}

-(NSMutableDictionary*)networkMockDict{
    if (_networkMockDict == nil) {
        _networkMockDict = [NSMutableDictionary dictionary];
    }
    return _networkMockDict;
}

- (void)setJsonData:(NSString*)jsonData withKey:(NSString*)key{
    if (jsonData == nil || key == nil) {
        return;
    }
    [self.networkMockDict setObject:jsonData forKey:key];
}

- (NSString*)getJsonDataWithKey:(NSString*)key{
    return [self.networkMockDict objectForKey:key];
}

@end
