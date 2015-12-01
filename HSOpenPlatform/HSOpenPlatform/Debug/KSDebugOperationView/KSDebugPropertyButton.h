//
//  HSCButton.h
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*
其实,
 */
#import <UIKit/UIKit.h>

@interface KSDebugPropertyButton : UIButton
{
    CGPoint beginPoint;
}

@property (nonatomic, assign) BOOL                       dragEnable;
@property (nonatomic, weak)   UIView                    *referenceView;
@property (nonatomic, strong) NSMutableDictionary       *dictObject;
@end
