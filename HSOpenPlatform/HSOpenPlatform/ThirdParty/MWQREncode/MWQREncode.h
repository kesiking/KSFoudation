//
//  MWQREncode.h
//  MWQREncode
//
//  Created by 许学 on 14-10-14.
//  Copyright (c) 2014年 xuxue. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MWQREncode : NSObject

//生成二维码图像
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

//生成带Logo的二维码图像
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size LogoImage:(UIImage *)Logo;

@end
