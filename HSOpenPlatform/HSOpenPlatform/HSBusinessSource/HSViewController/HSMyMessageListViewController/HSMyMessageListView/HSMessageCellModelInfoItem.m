//
//  HSMessageCellModelInfoItem.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/19.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMessageCellModelInfoItem.h"
#import "HSMyMessageModel.h"

@implementation HSMessageCellModelInfoItem

static NSDateFormatter *inputFormatter = nil;
static NSDateFormatter *outputFormatter = nil;

+(void)initialize{
    void (^initializeDataFormatterBlock)(void) = ^(void){
        if (inputFormatter == nil) {
            inputFormatter = [[HSDateManagerCenter sharedCenter] inputFormatter];
        }
        if (outputFormatter == nil) {
            outputFormatter = [[HSDateManagerCenter sharedCenter] outputFormatter];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
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
    if (![componentItem isKindOfClass:[HSMyMessageModel class]]) {
        self.frame = CGRectMake(0, 0, 320, 140);
        return;
    }
    HSMyMessageModel* messageInfoItem = (HSMyMessageModel*)componentItem;
    
    self.messageLinkModel = [HSMessageExtModel getMessageExtModelWithMessageModel:messageInfoItem];
    
    CGSize messageInfoSize = [self.messageLinkModel.messageInfo boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size;
    
    if (messageInfoItem.msgDate) {
        NSDate* inputDate = [inputFormatter dateFromString:messageInfoItem.msgDate];
        self.messageTime = [outputFormatter stringFromDate:inputDate];
    }
    self.messageInfoSize = CGSizeMake(SCREEN_WIDTH - 30 * 2, ceil(messageInfoSize.height));
    
    CGFloat messageInfoBtnHeight = (CGFloat)([HSMessageExtModel shouldMessageInfoBtnShowWithMessageExtModel:self.messageLinkModel] ? 40 : 10);
    
    self.frame = CGRectMake(0, 0, 320, ceil(messageInfoSize.height) - 20 + messageInfoBtnHeight + 100);
}

@end
