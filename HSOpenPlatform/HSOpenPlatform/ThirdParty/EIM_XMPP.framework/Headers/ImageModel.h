//
//  ImageModel.h
//  ChatDemo
//
//  Created by Mr.Chi on 15-1-19.
//  Copyright (c) 2015年 yangxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
@property (nonatomic,copy) NSString * measure;
//中图
@property (nonatomic,copy) NSString * middle_link;
//原图下载地址
@property (nonatomic,copy) NSString * original_link;
//原上传图片的小图
@property (nonatomic,copy) NSString * small_link;
//图片大小
@property (nonatomic,copy) NSString * dataLength;

@property (nonatomic,copy)NSString *thread;

//图片名字
@property (nonatomic,copy) NSString * imgeName;

+(ImageModel *)pareImgeByDic:(NSDictionary *)dic;
@end
