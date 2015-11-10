//
//  HSDateManagerCenter.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/27.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDateManagerCenter : NSObject

@property (nonatomic,strong) NSDateFormatter        *inputFormatter;
@property (nonatomic,strong) NSDateFormatter        *outputFormatter;

+ (instancetype)sharedCenter;

- (NSString*)currentTime;

@end
