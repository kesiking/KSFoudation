//
//  NSDictionary+JSONSerialize.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "NSDictionary+JSONSerialize.h"

@implementation NSDictionary (JSONSerialize)

-(NSString*)JSONString{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

-(NSData*)JSONData{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return json;
}

@end

@implementation NSArray (JSONSerialize)

-(NSString*)JSONString{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

-(NSData*)JSONData{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return json;
}

@end

@implementation NSString (JSONSerialize)

-(NSString*)JSONString{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

-(NSData*)JSONData{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!json)
        RMLog(@"toJSON failed. Error trace is: %@", error);
    return json;
}

- (id)objectFromJSONString
{
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (!object) {
        RMLog(@"toJSON failed. Error trace is: %@", error);
    }
    return object;
}

@end

@implementation NSString (URLCode)

- (NSString*)tbUrlEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString*)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

#pragma mark - URL Encode & Decode
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                                              kCFStringEncodingUTF8));
    
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}

- (NSDictionary*)tbQueryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        if (!pairString) {
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            continue;
        }
        //        NSArray* kvPair = [pairString componentsSeparatedByString:@"="]; // modify by Tim Cao 2012/08/14, custom separator
        NSMutableArray* kvPair = [NSMutableArray array];
        NSUInteger equalSignPosition = [pairString rangeOfString:@"="].location;
        if (equalSignPosition == NSNotFound) {
            [kvPair addObject:pairString];
            
        } else {
            [kvPair addObject:[pairString substringToIndex:equalSignPosition]];
            if (equalSignPosition != pairString.length-1)
                [kvPair addObject:[pairString substringFromIndex:equalSignPosition+1]];
        }
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            if (key && value) {
                // add by Tim Cao 2012/08/14, avoid nil value(wrong encoding) to be added to dictionary
                [pairs setObject:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
