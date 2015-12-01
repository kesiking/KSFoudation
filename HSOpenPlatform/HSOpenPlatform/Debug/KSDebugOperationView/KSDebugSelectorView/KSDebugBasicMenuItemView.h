//
//  KSDebugBasicMenuItemView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDebugMaroc.h"

@protocol KSDebugBasicMenuItemProtocol <NSObject>

@optional

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@interface KSDebugBasicMenuItemView : UIView<KSDebugBasicMenuItemProtocol>

@end
