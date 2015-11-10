//
//  HSActivityInfoDetailView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/10/14.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "KSView.h"
#import "HSActivityInfoModel.h"

@interface HSActivityInfoDetailView : KSView

@property (nonatomic, strong) HSActivityInfoModel            *activityInfoModel;

@property (nonatomic, weak)   UIViewController               *activityViewController;

@end
