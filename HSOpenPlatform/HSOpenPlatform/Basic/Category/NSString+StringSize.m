//
//  NSString+StringSize.m
//  eHome
//
//  Created by xtq on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

- (CGSize)sizeWithFontSize:(float)fontSize Width:(float)width{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    return rect.size;
}

@end
