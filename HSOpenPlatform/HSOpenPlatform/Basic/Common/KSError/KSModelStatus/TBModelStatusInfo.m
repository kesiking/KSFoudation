//
//  TBErrorInfo.m
//  Taobao2013
//
//  Created by 晨燕 on 12-12-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "TBModelStatusInfo.h"
#import "KSErrorProtocol.h"
#import <QuartzCore/QuartzCore.h>

@implementation TBModelStatusInfo


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Empty Info

- (NSString *)titleForEmpty {
    return kEmptyTitle;
}

- (NSString *)subTitleForEmpty {
    return kEmptySubtitle;
}

- (NSString *)actionButtonTitleForEmpty {
    return nil;
}

- (UIImage *)imageForEmpty {
    return [UIImage imageNamed:@"smile_error_image"];
}

- (UIImage *)imageForError:(NSError *)error {
    if ( [error conformsToProtocol:@protocol(KSErrorProtocol)]) {
//        id<KSErrorProtocol> errorResponse = (id<KSErrorProtocol>)error;
    }
    return [UIImage imageNamed:@"wifi_error_image"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Error Info

- (NSString*)titleForError:(NSError *)error {
    if ([error conformsToProtocol:@protocol(KSErrorProtocol)]) {
        id<KSErrorProtocol> tbError = (id<KSErrorProtocol>)error;
        
        if (_titleBlock) {
            return  _titleBlock(tbError);
        }

        return tbError.msg;
    }
    return kNetworkErrorTitle;
}


- (NSString*)subTitleForError:(NSError *)error {
    if ([error conformsToProtocol:@protocol(KSErrorProtocol)]) {
        id<KSErrorProtocol> tbError = (id<KSErrorProtocol>)error;
        
        if (_subtitleBlock) {
            return  _subtitleBlock(tbError);
        }

        return tbError.sub_msg;
    }
    return kNetworkErrorDefaultSubTitle;
}



- (NSString*)actionButtonTitleForError:(NSError*)error {
    if ([error conformsToProtocol:@protocol(KSErrorProtocol)]) {
        id<KSErrorProtocol> tbError = (id<KSErrorProtocol>)error;
        
        if (_actionTitleBlock) {
          return  _actionTitleBlock(tbError);
        }
        
        if(tbError.sub_msg.length > 0) {
            return tbError.sub_msg;
        }
    }
	return kNetworkErrorButtonTitle;
}

@end
