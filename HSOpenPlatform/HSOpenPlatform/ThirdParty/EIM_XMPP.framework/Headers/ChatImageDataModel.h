//
//  ChatImageDataModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-9.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatImageDataModel : NSObject
@property(nonatomic,copy)NSString *middleLink;///<图片原图
@property(nonatomic,copy)NSString *originalLink;///<图片大图
@property(nonatomic,copy)NSString *smallLink;///<图片小图
@property(nonatomic,copy)NSString *imageName;///<图片名字
@property(nonatomic,copy)NSString *imagePath;///<图片路径
@property (nonatomic,copy)NSString *fileLength; // 图片大小
@property (nonatomic,copy)NSString *width; //图片宽度
@property(nonatomic,copy)NSString *height; //图片高度


@end
