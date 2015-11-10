//
//  WeAppBasicMenuItemView.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeAppBasicMenuItemProtocol <NSObject>

@optional

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@interface WeAppBasicMenuItemView : UIView<WeAppBasicMenuItemProtocol>

@end
