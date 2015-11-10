//
//  NSString+TrimmingAdditions.h
//  eHome
//
//  Created by louzhenhua on 15/7/27.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TrimmingAdditions)
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet ;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet ;
@end
