//
//  KSDebugViewLoadDurationView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/11.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugBasicView.h"

#define KSDebug_ViewLoadDurations_Key @"KSViewLoadDurations"

#define KSDebug_ViewLoadDurations_MaxCount (2)

@interface KSDebugViewLoadDurationView : KSDebugBasicView

@property (nonatomic, strong)  NSMutableArray*   viewLoadDurations;
@property (strong,nonatomic) UILabel *viewLoadDurationLabel;

+(KSDebugViewLoadDurationView*)shareViewLoadDuration;


@end
