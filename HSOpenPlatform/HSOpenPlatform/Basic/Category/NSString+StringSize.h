//
//  NSString+StringSize.h
//  eHome
//
//  Created by xtq on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

- (CGSize)sizeWithFont:(UIFont *)font Width:(float)width;

- (CGSize)sizeWithFontSize:(float)fontSize Width:(float)width;

@end
