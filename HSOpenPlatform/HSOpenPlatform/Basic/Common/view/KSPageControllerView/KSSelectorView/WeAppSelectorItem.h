//
//  WeAppSelectorItem.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface WeAppSelectorItem : WeAppComponentBaseItem

@property (nonatomic, strong) NSString*         title;
@property (nonatomic, strong) NSString*         selectedBackgroundUrl;
@property (nonatomic, strong) NSString*         backgroundUrl;
@property (nonatomic, strong) NSString*         iconUrl;
@property (nonatomic, assign) NSUInteger        newMsgNum;
@property (nonatomic, strong) NSString*         formatType;
@property (nonatomic, strong) NSString*         precision;
@property (nonatomic, assign) BOOL              isShowRedDot;

@property (nonatomic, assign) NSInteger         imageQuality;
@property (nonatomic, strong) NSDictionary*     userTrack;

@end
