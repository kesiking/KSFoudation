//
//  WeAppDebugMemoryModel.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-10.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSDebugMemoryModel;

@protocol KSDebugMemoryModelProtocol <NSObject>

-(void)dataDidChanged:(KSDebugMemoryModel*)debugModel;

@end

@interface KSDebugMemoryModel : NSObject

@property (nonatomic,weak)   id<KSDebugMemoryModelProtocol> delegate;

@property (nonatomic,strong) NSTimer                *timer;

-(void)load;

-(void)unload;

-(void)cancelTimer;

-(void)timerProc:(NSTimer*)timer;

@end
