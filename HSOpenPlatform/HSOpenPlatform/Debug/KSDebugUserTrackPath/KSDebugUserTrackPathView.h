//
//  KSDebugUserTrackPathView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/7.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSDebugBasicTextView.h"
#import "KSMemoryCacheArray.h"

#define KSDebug_UserTrackPaths_Key @"KSDebugUserTrackPaths"

#define KSDebug_UserTrackPaths_MaxCount (1500)

#define KSDebugUserTrackPathArrayClass KSMemoryCacheArray

@interface KSDebugUserTrackPathView : KSDebugBasicTextView

@property (nonatomic, strong)  KSDebugUserTrackPathArrayClass*   userTrackPaths;

+(KSDebugUserTrackPathView*)shareUserTrackPath;

-(void)trimUserTrackPaths;

@end
