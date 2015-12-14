//
//  KSDebugViewAppearDurationView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/8.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugBasicTextView.h"

#define KSDebug_ViewAppearDurations_Key @"KSViewAppearDurations"

#define KSDebug_ViewAppearDurations_MaxCount (1500)

@interface KSDebugViewAppearDurationView : KSDebugBasicTextView

@property (nonatomic, strong)  NSMutableArray*   viewAppearDurations;

+(KSDebugViewAppearDurationView*)shareViewAppearDuration;

-(void)trimUserTrackPaths;



@end
