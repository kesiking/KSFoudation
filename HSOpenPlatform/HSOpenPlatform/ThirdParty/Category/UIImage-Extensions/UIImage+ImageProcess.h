//
//  UIImage+ImageProcess.h
//  eHome
//
//  Created by 孟希羲 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageProcess)

+ (UIImage*)grayscaleImage:(UIImage*)image;

- (UIImage*)createImageWithColor:(UIColor*)color;

- (UIImage*)getCirleBoaderWithBorderColor:(UIColor*)color withBorderWidth:(CGFloat)borderWidth;

@end
