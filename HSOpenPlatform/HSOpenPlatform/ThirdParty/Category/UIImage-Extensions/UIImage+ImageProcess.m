//
//  UIImage+ImageProcess.m
//  eHome
//
//  Created by 孟希羲 on 15/8/3.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "UIImage+ImageProcess.h"

@implementation UIImage (ImageProcess)

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

+ (UIImage *) grayscaleImage: (UIImage *) image
{
    CGSize size = [image size];
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return image;
    }
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef grayimage = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:grayimage];
    
    // we're done with image now too
    CGImageRelease(grayimage);
    
    return resultUIImage;
}

- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage *)getCirleBoaderWithBorderColor:(UIColor*)color withBorderWidth:(CGFloat)borderWidth
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    //part one
    UIGraphicsBeginImageContext(CGSizeMake(width*scale, height*scale));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    CGColorRef colorRef = [color CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if( numComponents == 4){
        CGFloat R, G, B;
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        CGContextSetRGBStrokeColor(context, R, G, B, 1.0);
    }else{
        CGContextSetRGBStrokeColor(context,0,0,1,1.0);//画笔线的颜色
    }
    
    CGContextSetLineWidth(context, borderWidth);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, width/2, height/2, width/2 - borderWidth, 0, 2*3.14159265358979323846, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
