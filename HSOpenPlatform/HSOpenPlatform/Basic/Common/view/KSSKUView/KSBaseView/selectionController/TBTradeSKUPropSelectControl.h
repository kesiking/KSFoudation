//
//  TBTradeSKUSelectControl.h
//  TBTrade
//
//  Created by christ.yuj on 14-1-20.
//  Copyright (c) 2014年 christ.yuj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSelectionControlDelegate.h"
@interface TBTradeSKUPropSelectControl : UIControl{
    NSInteger _selectedIndex;
    CGFloat _prevWidth;
}

@property (nonatomic, assign) NSInteger      selectedIndex;
@property (readonly, assign ) NSUInteger     numberOfSegments;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSString       *title;

@property (nonatomic, assign) id<TBSelectionControlDelegate> delegate;

- (void)setItems:(NSArray *)items;
- (void)setEnabled:(BOOL)enabled atIndex:(NSUInteger)index;
- (void)setHighlightEnabled:(BOOL)enabled forIndex:(NSUInteger)index;

@end