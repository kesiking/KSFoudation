//
//  WeAppTSimpleSelectorScrollView.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppBasicSelectorScrollView.h"
#import "WeAppSelectorDelegate.h"

@interface WeAppTSimpleSelectorScrollView : WeAppBasicSelectorScrollView

@property (nonatomic, weak)  id<WeAppSelectorDelegate>   delegate;
@property (nonatomic, weak)  id<WeAppSelectorSourceData> sourceDelegate;
@property (nonatomic, assign) BOOL                       needIndicatorView;

-(UIImageView*)getIndicatorView;

-(void)setScrollIndicatorViewRate:(CGFloat)rate;

@end
