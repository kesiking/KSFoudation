//
//  KSAdapterService+AddSignParam.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/16.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterService+AddSignParam.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation KSAdapterService (AddSignParam)

- (AddSignParamBlock)getAddSignParamBlock {
    WEAKSELF
    AddSignParamBlock block = ^(NSMutableDictionary *param) {
        if (!weakSelf) {
            return param;
        }
        NSString *serectKey = @"Funo.wcity_2015";
        NSString *reqnoStr = [weakSelf getReqnoStr];
        NSString *signStr = [weakSelf getSignStrWithReqnoStr:reqnoStr requestParam:param SerectKey:serectKey];
        NSMutableDictionary* newParams = [NSMutableDictionary new];
        [newParams setObject:reqnoStr forKey:@"reqno"];
        [newParams setObject:signStr forKey:@"sign"];
        return newParams;
    };
    return block;
}

- (NSString *)getReqnoStr {
    NSString *dateStr = [self stringFromDate:[NSDate date] withFormat:nil];
    NSString *randomStr = [self getRandomStrOfLength:6];
    NSLog(@"reqno : %@",[NSString stringWithFormat:@"%@%@",dateStr,randomStr]);
    return [NSString stringWithFormat:@"%@%@",dateStr,randomStr];
}

- (NSString *)getSignStrWithReqnoStr:(NSString *)reqno requestParam:(NSMutableDictionary *)requestParam SerectKey:(NSString *)serectKey{
    NSError *error = nil;
    NSString *paramString = @"";
    if ([requestParam count] > 0) {
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:requestParam options:NSJSONWritingPrettyPrinted error:&error];
        paramString = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    }
    
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@%@",reqno,serectKey,paramString,serectKey];
    NSLog(@"%@",resultStr);
    resultStr = [[self MD5String:resultStr] uppercaseString];

    return resultStr;
}


#pragma mark - Helper Functions
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if (dateFormat == nil || dateFormat.length == 0) {
        dateFormat = @"yyyyMMddHHmmss";
    }
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *destDateString = [formatter stringFromDate:date];
    return destDateString;
}

- (NSString *)getRandomStrOfLength:(NSUInteger)length {
    if (length < 1) {
        return nil;
    }
    NSUInteger randomNum = 0;
    for (NSUInteger i = 0; i < length; i++) {
        randomNum = randomNum*10+arc4random()%10;
        if (randomNum == 0 && i == 0) {
            i--;
        }
    }
    return [NSString stringWithFormat:@"%ld",randomNum];
}

- (NSString *)MD5String:(NSString *)string {
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
     CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
