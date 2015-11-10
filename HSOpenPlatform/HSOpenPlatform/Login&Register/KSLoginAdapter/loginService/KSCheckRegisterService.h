//
//  KSCheckRegisterService.h
//  eHome
//
//  Created by 孟希羲 on 15/6/16.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^checkRegisterBlock)(BOOL isRegister, NSError* error);

@interface KSCheckRegisterService : NSObject

-(void)checkRegisterWithAccountName:(NSString*)accountName checkRegister:(checkRegisterBlock)checkRegister;

@end
