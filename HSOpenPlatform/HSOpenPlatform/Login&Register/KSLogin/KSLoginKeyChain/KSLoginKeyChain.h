//
//  KSLoginKeyChain.h
//  basicFoundation
//
//  Created by 孟希羲 on 15/6/8.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSLoginKeyChain : NSObject

@property (nonatomic,strong,getter = getAccountName) NSString * accountName;

@property (nonatomic,strong,getter = getPassword)    NSString * password;

+(KSLoginKeyChain *)sharedInstance;

-(void)clear;

@end
