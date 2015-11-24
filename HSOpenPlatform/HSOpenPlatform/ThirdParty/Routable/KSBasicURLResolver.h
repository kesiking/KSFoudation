//
//  KSBasicURLResolver.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-22.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBURLActionHandler.h"

#define ACTION_ANIMATION_KEY @"ACTION_ANIMATION_KEY"

#define ACTION_NEEDLOGIN_KEY @"needLogin"

@class TBURLAction;

@interface KSBasicURLResolver : NSObject<TBURLActionHandler>

-(UIViewController *)viewControllerWithAction:(TBURLAction *)action;

@end
