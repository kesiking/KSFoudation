//
//  TBErrorHandler.m
//  Taobao2013
//
//  Created by 晨燕 on 12-12-24.
//  Copyright (c) 2012年 Taobao.com. All rights reserved.
//

#import "TBModelStatusHandler.h"
#import "KSErrorView.h"
#import "TBModelStatusInfo.h"
#import "KSErrorProtocol.h"
#import "UIImage+GIF.h"

#define kErrorViewTag           12306
#define kEmptyViewTag           12307
#define kLoadingViewTag         12308

@interface TBModelStatusHandler () {

}

@property (nonatomic, strong) MBProgressHUD          *hud;

@end

@implementation TBModelStatusHandler

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management

- (void)dealloc {

}

- (id)initWithStatusInfo:(TBModelStatusInfo *)info delegate:(id<TBModelStatusDelegate>)delegate {
    if (self = [super init]) {
        self.statusInfo = info;
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithStatusInfo:(TBModelStatusInfo *)info{
    if (self = [super init]) {
        self.statusInfo = info;
    }
    return self;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Accessor

- (TBModelStatusInfo *)errorInfo {
    if (!_statusInfo) {
        _statusInfo = [[TBModelStatusInfo alloc] init];
    }
    return _statusInfo;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Method

- (UIView *)errorViewWithFrame:(CGRect)frame error:(NSError *)error actionTarget:(id)actionTarget actionSelector:(SEL)actionSelector {
    NSString* title = [self.errorInfo titleForError:error];
    NSString* subtitle = [self.errorInfo subTitleForError:error];
    NSString *btnTitle = [self.errorInfo actionButtonTitleForError:error];
    UIImage *image = [self.errorInfo imageForError:error];
    
    //是否是限流的错误码
    if (title.length || subtitle.length) {
        KSErrorView * aErrorView;
        if (self.selectorForErrorBlock!=0) {
            aErrorView = [[KSErrorView alloc] initWithImage:image
                                                      title:title
                                                   subtitle:subtitle
                                          actionButtonTitle:btnTitle
                                                     target:self
                                                   selector:@selector(selectorForError:)];
        } else{
            
            aErrorView = [[KSErrorView alloc] initWithImage:image
                                                      title:title
                                                   subtitle:subtitle
                                          actionButtonTitle:btnTitle
                                                     target:actionTarget
                                                   selector:actionSelector];
        }
        
        aErrorView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1.0f];
        aErrorView.frame = frame;
        return aErrorView;
    }
    return nil;
}

- (UIView *)emptyViewWithFrame:(CGRect)frame {
    NSString* title = [self.errorInfo titleForEmpty];
    NSString* subtitle = [self.errorInfo subTitleForEmpty];
    //UIImage* image = [self.errorInfo imageForEmpty];
    NSString *btnTitle = [self.errorInfo actionButtonTitleForEmpty];
    id image = [self.errorInfo imageForEmpty];
    image = image ? image : [self.errorInfo imageForEmpty];
    
    if (title.length || subtitle.length || image) {
        
        KSErrorView * aErrorView;
        //handle empty block first, if it exists.
        if (self.selectorForEmptyBlock!=0) {
            aErrorView = [[KSErrorView alloc] initWithImage:image
                                                      title:title
                                                   subtitle:subtitle
                                          actionButtonTitle:btnTitle
                                                     target:self
                                                   selector:@selector(selectorForEmpty)];
        } else{
            
            //if delegate is not nil, and it implement selectorForEmpty method
            if ([self.delegate respondsToSelector:@selector(selectorForEmpty)]) {
                aErrorView = [[KSErrorView alloc] initWithImage:image
                                                          title:title
                                                       subtitle:subtitle
                                              actionButtonTitle:btnTitle
                                                         target:self.delegate
                                                       selector:[self.delegate selectorForEmpty]];
            } else{
                aErrorView = [[KSErrorView alloc] initWithImage:image
                                                          title:title
                                                       subtitle:subtitle
                                              actionButtonTitle:btnTitle
                                                         target:nil
                                                       selector:nil];
            }
            
        }
        
        aErrorView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1.0f];
        aErrorView.frame = frame;
        return aErrorView;
    }
    return nil;
}

- (UIView *)loadingView {
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Method for callback
- (void)selectorForError:(NSError *)error {
    self.selectorForErrorBlock(error);
}
- (void)selectorForEmpty{
    self.selectorForEmptyBlock();
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Method

- (UIView *)showViewforError:(NSError *)error inView:(UIView *)parentView frame:(CGRect)frame {
    
    if ([error conformsToProtocol:@protocol(KSErrorProtocol)]) {
        id<KSErrorProtocol> tbError = (id<KSErrorProtocol>)error;
    }
    
    return [self showViewforError:error inView:parentView frame:frame actionTarget:self.delegate actionSelector:[self.delegate selectorForError:error]];
}

- (UIView *)showViewforError:(NSError *)error inView:(UIView *)parentView frame:(CGRect)frame actionTarget:(id)actionTarget actionSelector:(SEL)actionSelector {
    UIView *errorView = [parentView viewWithTag:kErrorViewTag];
    [errorView removeFromSuperview];
    
    UIView* view = [self errorViewWithFrame:frame error:error actionTarget:actionTarget actionSelector:actionSelector];
    view.tag = kErrorViewTag;
    [parentView addSubview:view];
    
    return view;
}

- (UIView *)showEmptyViewInView:(UIView *)parentView frame:(CGRect)frame {
    UIView* emptyView = [parentView viewWithTag:kEmptyViewTag];
    [emptyView removeFromSuperview];

    UIView* view = [self emptyViewWithFrame:frame];
    view.tag = kEmptyViewTag;
    [parentView addSubview:view];
    return view;
}

- (void)showLoadingViewInView:(UIView *)parentView{
    [self showLoadingViewInView:parentView frame:parentView.frame];
}

- (void)showLoadingViewInView:(UIView *)parentView frame:(CGRect)frame{
    if (_hud == nil) {
#ifdef USER_CUSTOM_LOADING_VIEW
        CGRect rect = CGRectMake(frame.origin.x + (frame.size.width - 80)/2, frame.origin.y + (frame.size.height - 80)/2, 80, 80);
        NSString  *name = @"loading01.gif";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.image = [UIImage sd_animatedGIFWithData:imageData];
        
        UIView* backgroundView = [[UIView alloc] initWithFrame:parentView.bounds];
        backgroundView.backgroundColor = RGB_A(0x00, 0x00, 0x00, 0.5);
        [backgroundView addSubview:imageView];
        
        _hud = [[MBProgressHUD alloc] initWithFrame:frame];
        _hud.customView = backgroundView;
        _hud.margin = 0;
        _hud.color = [UIColor clearColor];
        // Set custom view mode
        _hud.mode = MBProgressHUDModeCustomView;
#else
        _hud = [[MBProgressHUD alloc] initWithFrame:frame];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"请稍等···";
#endif
    }
    if (_hud.superview != nil) {
        [_hud removeFromSuperview];
    }
    [parentView addSubview:_hud];
    [_hud show:YES];
    // 5秒后自动关闭
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:5.0];
}

-(void)hideLoadingView{
    [_hud hide:YES];
}

- (void)removeStatusViewFromView:(UIView *)parentView hideLoading:(BOOL)hideLoading{
    UIView *errorView = nil;
    UIView* emptyView = nil;
    for (UIView* subView in parentView.subviews) {
        if (kErrorViewTag == subView.tag) {
            errorView = subView;
        }
        if (kEmptyViewTag == subView.tag) {
            emptyView = subView;
        }
    }
    
    [errorView removeFromSuperview];
    [emptyView removeFromSuperview];
    
    if (hideLoading) {
        [self hideLoadingView];
    }

}

- (void)removeStatusViewFromView:(UIView *)parentView {
    [self removeStatusViewFromView:parentView hideLoading:YES];
}

@end
