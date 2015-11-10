//
//  TBSelectionControlDelegate.h
//  TBTrade
//
//  Created by christ.yuj on 14-2-8.
//  Copyright (c) 2014年 christ.yuj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBSelectionControlDelegate <NSObject>

- (void)clickedControl:(UIControl *)control index:(NSUInteger)index;

@end
