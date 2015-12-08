//
//  KSDebugToastView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/4.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSDebugToastView : UIView

+(void)toast:(NSString*)s;
+(void)toast:(NSString*)s toView:(UIView*)v;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(CGPoint)position withCallBackBlock:(void (^)(UIView* toastView, UILabel* toastLabel))callBackBlock;

@end
