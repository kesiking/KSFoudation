//
//  UIColor+Ext.h
//  MobileWallet
//
//  Created by louzhenhua on 8/15/14.
//  Copyright (c) 2014 CMCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ext)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
@end
