//
//  KSDebugViewLoadModel.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/15.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSDebugViewLoadModel : NSObject

@property (strong, nonatomic) NSString *vcName;

@property (strong, nonatomic) NSDate *vcInitTime;

@property (strong, nonatomic) NSDate *viewDidLoadTime;

@property (assign, nonatomic) NSTimeInterval timeSpent;

@end
