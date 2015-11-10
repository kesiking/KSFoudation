//
//  HSMessageExtModel.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSMessageExtModel.h"

@implementation HSMessageExtModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messageInfoLinkParams = [NSMutableDictionary dictionary];
    }
    return self;
}

+(HSMessageExtModel*)getMessageExtModelWithMessageModel:(HSMyMessageModel*)messageInfoItem{
    
    HSMessageExtModel* messageExtModel = [HSMessageExtModel new];

    [self setupMessageExtModel:messageExtModel withCategory:[messageInfoItem.msgCategory integerValue] messageModel:messageInfoItem];
    messageExtModel.messageInfo = messageExtModel.messageNeedLinkRange ? [NSString stringWithFormat:@"%@%@",messageInfoItem.msgContent,messageExtModel.messageInfoLinkStr] : messageInfoItem.msgContent;
    messageExtModel.messageInfoLinkRange = messageExtModel.messageNeedLinkRange ?  NSMakeRange(messageInfoItem.msgContent.length, messageExtModel.messageInfoLinkStr.length) : NSMakeRange(0, 0);
    
    return messageExtModel;
}

+(void)setupMessageExtModel:(HSMessageExtModel*)messageExtModel withCategory:(NSUInteger)category messageModel:(HSMyMessageModel*)messageInfoItem{
    
    if (messageInfoItem.msgParams
        && [messageInfoItem.msgParams isKindOfClass:[NSDictionary class]]) {
        [messageExtModel.messageInfoLinkParams addEntriesFromDictionary:messageInfoItem.msgParams];
    }
    
    if (category == 1) {
        messageExtModel.messageNeedLinkRange = YES;
        messageExtModel.messageInfoLinkUrl = internalURL(@"HSActivityInfoDetailViewController");
        messageExtModel.messageInfoLinkStr = @"立即查看";
        messageExtModel.messageInfoBtnStr = @"立即充值";
        messageExtModel.messageInfoBtnUrl = @"http://www.baidu.com";
    }else if([self messageNeedLinkRangeWithMessageExtModel:messageExtModel messageModel:messageInfoItem]){
        messageExtModel.messageNeedLinkRange = YES;
    }
    
    messageExtModel.messageInfoLinkUrl = messageInfoItem.detailUrl?:messageExtModel.messageInfoLinkUrl;
    messageExtModel.messageInfoBtnUrl = messageInfoItem.rechargeUrl?:messageExtModel.messageInfoBtnUrl;
    messageExtModel.messageInfoLinkStr = messageExtModel.messageInfoLinkStr?:(messageInfoItem.detailUrl?@"立即查看":nil);
}

+(BOOL)messageNeedLinkRangeWithMessageExtModel:(HSMessageExtModel*)messageExtModel messageModel:(HSMyMessageModel*)messageInfoItem{
    return [EHUtils isNotEmptyString:messageInfoItem.detailUrl];
}

+(BOOL)shouldMessageInfoBtnShowWithMessageExtModel:(HSMessageExtModel*)messageExtModel{
    return  [EHUtils isNotEmptyString:messageExtModel.messageInfoBtnStr] && [EHUtils isNotEmptyString:messageExtModel.messageInfoBtnUrl];
}

+(BOOL)isMessageLinkValidWithMessageExtModel:(HSMessageExtModel*)messageExtModel MessageInfo:(NSString*)messageInfo{
    if (messageInfo == nil || messageInfo.length == 0) {
        return NO;
    }
    if (messageExtModel == nil || messageExtModel.messageInfo == nil) {
        return NO;
    }
    return  messageExtModel.messageNeedLinkRange && messageExtModel.messageInfoLinkRange.length > 0 && NSLocationInRange(NSMaxRange(messageExtModel.messageInfoLinkRange) - 1, NSMakeRange(0, [messageInfo length]));
}

@end
