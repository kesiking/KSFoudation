//
//  TBHint.h
//  Taobao2013
//
//  Created by Dong on 13-2-28.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeAppToast : NSObject

+(void)toast:(NSString*)s;
+(void)toastAtBottom:(NSString*)s;
+(void)toastAtBottom:(NSString*)s displaytime:(float)t;
+(void)toast:(NSString*)s toView:(UIView*)v;
+(void)toastTransparency:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t;
+(void)toast:(NSString*)s toView:(UIView*)v displaytime:(float)t postion:(int)y;

@end


typedef void(^ MessageConfrimBlock)();

@interface WeApppMessageObject : NSObject
@property (nonatomic, strong) NSString*message,*cancelString,*confirmString;
@property (nonatomic, strong)MessageConfrimBlock confirmationBlock;
@end

@interface WeAppConfirmHint : NSObject
@property (nonatomic, strong) NSMutableArray*messages;
@property (nonatomic, strong)UIView*hintView,*lastView;
+ (id)sharedManager;
+(void)addToast:(NSString*)s andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
+(void)addToast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
-(void)toast:(NSString*)s withConfrimationTitle:(NSString*)confirmString andCancelString:(NSString*)cancelString andConfirmation:(void (^)(void))confirm toView:(UIView*)v;
@end