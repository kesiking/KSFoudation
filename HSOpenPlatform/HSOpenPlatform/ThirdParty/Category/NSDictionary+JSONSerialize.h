//
//  NSDictionary+JSONSerialize.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONSerialize)

-(NSString*)JSONString;
-(NSData*)JSONData;

@end

@interface NSArray (JSONSerialize)

-(NSString*)JSONString;
-(NSData*)JSONData;

@end

@interface NSString (JSONSerialize)

- (NSString *)JSONString;
- (NSData *)JSONData;

- (id)objectFromJSONString;

@end

@interface NSString (URLCode)

#pragma mark - URL Encode & Decode

- (NSString*)tbUrlEncoded;
/**
	返回url 编码后的字符串
	@returns 返回url 编码后的字符串
 */
- (NSString *)URLEncodedString;

/**
	返回对url编码的解码
	@returns 返回对url编码的解码字符串
 */
- (NSString *)URLDecodedString;

- (NSDictionary*)tbQueryDictionaryUsingEncoding:(NSStringEncoding)encoding;

@end
