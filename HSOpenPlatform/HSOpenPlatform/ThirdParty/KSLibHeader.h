//
//  KSLibHeader.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-20.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#ifndef basicFoundation_KSLibHeader_h
#define basicFoundation_KSLibHeader_h

#import "AFNetworking.h"
#import "RDVTabBarController.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIView+Geometry.h"
#import "WeAppComponentBaseItem.h"
#import "NSArray+TBJSONModel.h"
#import "NSDictionary+TBJSONModel.h"
#import "WeAppBasicService.h"
#import "Routable.h"
#import "WeAppConstant.h"
#import "NSDictionary+JSONSerialize.h"
#import "UIViewController+KSNavigator.h"
#import "KSNavigator.h"
#import "TTTAttributedLabel.h"
#import "MBProgressHUD.h"
#import "WeAppToast.h"
#import "DateTools.h"
#import "VoiceConverter.h"
#import "View+MASAdditions.h"
#import "GroupedTableView.h"
#import <MQTTKit/MQTTKit.h>
#ifdef USE_AsyncDisplayKit
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#endif

#ifdef USE_ReactNative
#import "RCTRootView.h"
#endif

#define WEAKSELF typeof(self) __weak __block weakSelf = self;
#define STRONGSELF typeof(self) __strong strongSelf = weakSelf;

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#if DEBUG
#define RMLog(args...) NSLog(@"%@", [NSString stringWithFormat: args])
#define LogMethod() NSLog(@"logged method call: -[%@ %@] (line %d)", self, NSStringFromSelector(_cmd), __LINE__)
#define WarnDeprecated() NSLog(@"***** WARNING: deprecated method call: -[%@ %@] (line %d)", self, NSStringFromSelector(_cmd), __LINE__)
#else
// DEBUG not defined:

#define RMLog(args...)    // do nothing.
#define LogMethod()
#define WarnDeprecated()
#define NS_BLOCK_ASSERTIONS 1
#endif

#endif
