//
//  NSString+TBModel.h
//  TBSDK
//
//  Created by christ.yuj on 13-2-25.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WeAppComponentBaseItem)

- (unsigned int)weappUnsignedIntValue;
- (long)weappLongValue;
- (unsigned long)weappUnsignedLongValue;
- (unsigned long long)weappUnsignedLongLongValue;
- (NSUInteger)weappUnsignedIntegerValue;

@end

@interface NSObject (WeAppComponentBaseItem)

- (unsigned int)weappUnsignedIntValue;
- (long)weappLongValue;
- (unsigned long)weappUnsignedLongValue;
- (unsigned long long)weappUnsignedLongLongValue;
- (NSUInteger)weappUnsignedIntegerValue;

@end
