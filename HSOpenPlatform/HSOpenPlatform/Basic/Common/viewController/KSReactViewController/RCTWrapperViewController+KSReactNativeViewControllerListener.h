//
//  RCTWrapperViewController+KSReactNativeViewControllerListener.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/11/25.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//
#ifdef USE_ReactNative

#import "RCTWrapperViewController.h"

@interface RCTWrapperViewController (KSReactNativeViewControllerListener)

-(void)KSWillMoveToParentViewController:(UIViewController *)parent;

@end

#endif
