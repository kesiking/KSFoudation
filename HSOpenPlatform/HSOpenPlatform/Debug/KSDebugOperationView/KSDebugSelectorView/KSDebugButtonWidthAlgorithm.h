//
//  KSDebugButtonWidthAlgorithm.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define borderWidth   (0)
#define defaultHeight (52)

#define BUTTON_AVERAGE_WIDTH (71.11)
#define BUTTON_MIN_WIDTH     (44)

@interface KSDebugButtonWidthAlgorithm : NSObject

// 根据传入的button个数计算出button的宽度大小
// 默认返回整个屏幕宽度

+(CGFloat)viewDynamicWidthWithNum:(NSUInteger)number;
+(CGFloat)viewDynamicWidthWithNum:(NSUInteger)number andParentWidth:(CGFloat)width;
+(CGFloat)viewDynamicHeightWithNum:(NSUInteger)number;
+(NSString*)imageSelectNameWithNum:(NSUInteger)number;
+(NSString*)imageNormalNameWithNum:(NSUInteger)number;

@end
