//
//  NSDate+string.h
//  O了
//
//  Created by roya-7 on 14-10-16.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (string)
-(NSString *)stringWithFormatter:(NSString *)formatter;

-(NSString *)nowDateStringWithFormatter:(NSString *)formatter;
-(NSString *)nowDateStringWithFormatter:(NSString *)formatter andTime:(NSString *)timeStame;
@end
