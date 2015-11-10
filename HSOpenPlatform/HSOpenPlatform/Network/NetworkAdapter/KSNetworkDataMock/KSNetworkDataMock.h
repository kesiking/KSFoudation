//
//  KSNetworkDataMock.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/27.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSNetworkDataMock : NSObject

+ (instancetype)sharedInstantce;

- (void)setJsonData:(NSString*)jsonData withKey:(NSString*)key;

- (NSString*)getJsonDataWithKey:(NSString*)key;

@end
