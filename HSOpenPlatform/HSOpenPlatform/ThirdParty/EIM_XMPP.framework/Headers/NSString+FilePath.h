//
//  NSString+FilePath.h
//  O了
//
//  Created by 卢鹏达 on 14-1-23.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)
/**
 *  获取项目沙盒中Documents所在路径
 *
 *  @return Documents路径
 */
- (NSString *)filePathOfDocuments;
/**
 *  获取项目沙盒中Caches所在路径
 *
 *  @return Caches路径
 */
- (NSString *)filePathOfCaches;
/**
 *  获取项目沙盒中Library所在路径
 *
 *  @return Library路径
 */
- (NSString *)filePathOfLibrary;
/**
 *  获取项目沙盒中Tmp所在路径
 *
 *  @return Tmp路径
 */
- (NSString *)filePathOfTmp;


#pragma mark - 拼装网络请求的path
- (NSString *)pathRequestUuid:(NSString *)uuid;

#pragma mark - 根据秒数获取时间
- (NSString *)timeWithSecondAndFormat:(NSString *)format;///<根据秒数获取时间
#pragma mark - 根据时间获取秒数
- (NSString *)secondWithTimeAndFormat:(NSString *)format;///<根据时间获取秒数

#pragma mark - 获取发送人uid
-(NSString *)deleteOpenFireName;
/**
 *  获取房间消息的发送人
 *
 *  @return 
 */
-(NSString *)getFromWithRoomMessageFrom;
@end
