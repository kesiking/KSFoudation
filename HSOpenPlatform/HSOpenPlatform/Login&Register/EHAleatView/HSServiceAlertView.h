//
//  HSServiceAlertView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/18.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "EHAleatView.h"

typedef void(^serviceDidStartedBlock)   (EHAleatView * alertView, WeAppBasicService* service);
typedef void(^serviceDidFinishedBlock)  (EHAleatView * alertView, WeAppBasicService* service);
typedef void(^serviceDidFailedBlock)    (EHAleatView * alertView, WeAppBasicService* service, NSError* error);

typedef void(^alertToastContentBlock)   (EHAleatView * alertView, NSString* toastMessage);

@interface HSServiceAlertView : EHAleatView<WeAppBasicServiceDelegate>

@property (nonatomic, strong) id                                 alertContext;

@property (nonatomic, strong) WeAppBasicService                 *service;

@property (nonatomic, copy)   serviceDidStartedBlock             serviceDidStartedBlock;

@property (nonatomic, copy)   serviceDidFinishedBlock            serviceDidFinishedBlock;

@property (nonatomic, copy)   serviceDidFailedBlock              serviceDidFailedBlock;

@property (nonatomic, copy)   alertToastContentBlock             alertToastContentBlock;

// for override and userd by subclass
-(void)toastMessage:(NSString*)message;

@end
