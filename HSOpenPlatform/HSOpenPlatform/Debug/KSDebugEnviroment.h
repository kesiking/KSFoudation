//
//  WeAppDebugEnviroment.h
//  WeAppSDK
//
//  Created by 逸行 on 15-2-2.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSDebugEnviroment : NSObject

@property(nonatomic, weak)    UIView*                 debugReferenceView;

@property(nonatomic, strong)  NSMutableArray*         filePathArray;

@end
