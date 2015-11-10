//
//  KSToastView.h
//  eHome
//
//  Created by 孟希羲 on 15/8/31.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSToastView : NSObject

+(void)toast:(NSString*)s;
+(void)toast:(NSString*)s toView:(UIView*)v;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(CGPoint)position withCallBackBlock:(void (^)(UIView* toastView, UILabel* toastLabel))callBackBlock;
@end
