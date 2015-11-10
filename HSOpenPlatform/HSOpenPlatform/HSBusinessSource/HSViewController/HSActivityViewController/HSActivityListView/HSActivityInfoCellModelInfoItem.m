//
//  HSActivityInfoCellModelInfoItem.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/12.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSActivityInfoCellModelInfoItem.h"
#import "HSActivityInfoModel.h"

@implementation HSActivityInfoCellModelInfoItem

static NSDateFormatter *inputFormatter = nil;
static NSDateFormatter *outputFormatter = nil;

+(void)initialize{
    void (^initializeDataFormatterBlock)(void) = ^(void){
        if (inputFormatter == nil) {
            inputFormatter = [[HSDateManagerCenter sharedCenter] inputFormatter];
        }
        if (outputFormatter == nil) {
            outputFormatter = [[HSDateManagerCenter sharedCenter] outputFormatter];
            [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
        }
    };
    if ([NSThread isMainThread]) {
        if (initializeDataFormatterBlock) {
            initializeDataFormatterBlock();
        }
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (initializeDataFormatterBlock) {
                initializeDataFormatterBlock();
            }
        });
    }
}

// 配置初始化KSCellModelInfoItem，在modelInfoItem中可以配置cell需要的参数
-(void)setupCellModelInfoItemWithComponentItem:(WeAppComponentBaseItem*)componentItem{
    if (![componentItem isKindOfClass:[HSActivityInfoModel class]]) {
        self.frame = CGRectMake(0, 0, 320, 210);
        return;
    }
    HSActivityInfoModel* activityInfoItem = (HSActivityInfoModel*)componentItem;
    CGSize activityInfoDescSize = [activityInfoItem.activityDetailText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25 * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:EHSiz4],NSFontAttributeName, nil] context:nil].size;
   
    if (activityInfoItem.activityStartTime) {
        self.activityStartDate = [inputFormatter dateFromString:activityInfoItem.activityStartTime];
        self.activityStartTimeStr = [outputFormatter stringFromDate:self.activityStartDate];
    }
    if (activityInfoItem.activityEndTime) {
        self.activityEndDate = [inputFormatter dateFromString:activityInfoItem.activityEndTime];
        self.activityEndTimeStr = [outputFormatter stringFromDate:self.activityEndDate];
    }
    
    self.activityInfoDescSize = CGSizeMake(SCREEN_WIDTH - 25 * 2, ceil(activityInfoDescSize.height));
    
    self.frame = CGRectMake(0, 0, 320, self.activityInfoDescSize.height + 215 - 18);
}

@end
