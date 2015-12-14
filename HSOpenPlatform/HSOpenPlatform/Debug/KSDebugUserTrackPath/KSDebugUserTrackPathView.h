//
//  KSDebugUserTrackPathView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/7.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugBasicTextView.h"

#define KSDebug_UserTrackPaths_Key @"KSDebugUserTrackPaths"

#define KSDebug_UserTrackPaths_MaxCount (1500)

@interface KSDebugUserTrackPathView : KSDebugBasicTextView

@property (nonatomic, strong)  NSMutableArray*   userTrackPaths;

+(KSDebugUserTrackPathView*)shareUserTrackPath;

-(void)trimUserTrackPaths;

@end
