//
//  HSSubscribeBussinessCellModelInfoItem.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/22.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSSubscribeBussinessCellModelInfoItem.h"
#import "HSSubscribedBussinessBasicModel.h"

static NSDateFormatter *inputFormatter = nil;
static NSDateFormatter *outputFormatter = nil;

@implementation HSSubscribeBussinessCellModelInfoItem

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem{
    if (![componentItem isKindOfClass:[HSSubscribedBussinessBasicModel class]]) {
        self.frame = CGRectMake(0, 0, 320, 55);
        return;
    }
    
    HSSubscribedBussinessBasicModel* subscribedBussinessInfoItem = (HSSubscribedBussinessBasicModel*)componentItem;
    
    CGSize subscribedBussinessInfoSize = [subscribedBussinessInfoItem.subscribedBussinessDetailText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 8 * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size;
    
    if (inputFormatter == nil) {
        inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (outputFormatter == nil) {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDate* inputDate = nil;
    BOOL needSubscribedBussinessStartTime = NO;
    if (subscribedBussinessInfoItem.subscribedBussinessStartTime) {
        inputDate = [inputFormatter dateFromString:subscribedBussinessInfoItem.subscribedBussinessStartTime];
        self.subscribedBussinessStartTime = [outputFormatter stringFromDate:inputDate];
        needSubscribedBussinessStartTime = YES;
    }
    if (subscribedBussinessInfoItem.subscribedBussinessEndTime) {
        inputDate = [inputFormatter dateFromString:subscribedBussinessInfoItem.subscribedBussinessEndTime];
        self.subscribedBussinessEndTime = [outputFormatter stringFromDate:inputDate];
    }
    
    self.subscribedBussinessInfoDescSize = CGSizeMake(SCREEN_WIDTH - 8 * 2, ceil(subscribedBussinessInfoSize.height));
    
    self.frame = CGRectMake(0, 0, 320, ceil(subscribedBussinessInfoSize.height) - 15 + 40 + (float)(needSubscribedBussinessStartTime?15:0));
}

@end
