//
//  HSMessageExtModel.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/23.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "WeAppComponentBaseItem.h"
#import "HSMyMessageModel.h"

@interface HSMessageExtModel : WeAppComponentBaseItem

@property (nonatomic, strong) NSString*             messageInfo;

@property (nonatomic, strong) NSString*             messageInfoLinkStr;
@property (nonatomic, strong) NSString*             messageInfoLinkUrl;
@property (nonatomic, strong) NSMutableDictionary*  messageInfoLinkParams;

@property (nonatomic, strong) NSString*             messageInfoBtnStr;
@property (nonatomic, strong) NSString*             messageInfoBtnUrl;

@property (nonatomic, assign) NSRange               messageInfoLinkRange;
@property (nonatomic, assign) BOOL                  messageNeedLinkRange;

+(HSMessageExtModel*)getMessageExtModelWithMessageModel:(HSMyMessageModel*)messageInfoItem;

+(BOOL)isMessageLinkValidWithMessageExtModel:(HSMessageExtModel*)messageExtModel MessageInfo:(NSString*)messageInfo;

+(BOOL)shouldMessageInfoBtnShowWithMessageExtModel:(HSMessageExtModel*)messageExtModel;

@end
