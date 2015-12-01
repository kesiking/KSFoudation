//
//  WeAppDebugManager.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDebugManager : NSObject

+(KSDebugManager*)shareInstance;

-(void)setWeApp;

@end
