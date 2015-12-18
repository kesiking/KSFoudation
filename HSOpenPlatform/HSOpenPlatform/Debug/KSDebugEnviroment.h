//
//  WeAppDebugEnviroment.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSDebugEnviroment : NSObject

// 设置debug工具所在的参考view，默认是在UIWindow上----->[[UIApplication sharedApplication] keyWindow]
@property(nonatomic, weak)    UIView*                 debugReferenceView;

/*!
 *  @author 孟希羲, 15-12-17 09:12:13
 *
 *  @brief  日志获取文件路径，例如获取SDImage的路径：
 *  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
 *  NSString *baseDir = paths.firstObject;
 *  NSString *sdImageDirectory  = [baseDir stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
 *  if (sdImageDirectory) {
 *      [_filePathArray addObject:@{@"filePath":sdImageDirectory,@"fileType":@"png"}];
 *  }
 *  定义了路径后日志工具就会将该目录下得文件显示出来，例如可以展示SDImage下的图片文件
 *
 *  @since  1.0
 */
@property(nonatomic, strong)  NSMutableArray*         filePathArray;

// 重定向请求的参数，如果需要重定向请求可填充
@property (nonatomic, strong)  NSString*              redirectHost;

@property (nonatomic, strong)  NSString*              orignalHost;

@property (nonatomic, strong)  NSString*              redirectPort;

@property (nonatomic, strong)  NSString*              orignalPort;

@end
