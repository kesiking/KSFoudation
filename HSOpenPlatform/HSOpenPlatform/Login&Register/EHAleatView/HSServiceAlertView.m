//
//  HSServiceAlertView.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/18.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import "HSServiceAlertView.h"

@implementation HSServiceAlertView

-(void)setService:(WeAppBasicService *)service{
    if (_service != service) {
        _service.delegate = nil;
        _service = nil;
        _service = service;
        _service.delegate = self;
    }
}

- (void)serviceDidStartLoad:(WeAppBasicService *)service{
    if (self.serviceDidStartedBlock) {
        self.serviceDidStartedBlock(self, service);
    }
}

- (void)serviceDidCancelLoad:(WeAppBasicService *)service{
    
}

- (void)serviceDidFinishLoad:(WeAppBasicService *)service{
    // todo success
    if (self.serviceDidFinishedBlock) {
        self.serviceDidFinishedBlock(self, service);
    }
}

- (void)service:(WeAppBasicService *)service didFailLoadWithError:(NSError*)error{
    if (self.serviceDidFailedBlock) {
        self.serviceDidFailedBlock(self, service, error);
    }
}

-(void)toastMessage:(NSString*)message{
    if (self.alertToastContentBlock) {
        self.alertToastContentBlock(self, message);
    }else{
        [WeAppToast toast:message];
    }
}

-(void)dealloc{
    _service.delegate = nil;
    _service = nil;
}

@end
