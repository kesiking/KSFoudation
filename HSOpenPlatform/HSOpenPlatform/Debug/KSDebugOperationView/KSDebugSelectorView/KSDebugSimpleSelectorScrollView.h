//
//  KSDebugSimpleSelectorScrollView.h
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugSelectorBasicView.h"
#import "KSDebugSelectorViewDelegate.h"

@interface KSDebugSimpleSelectorScrollView : KSDebugSelectorBasicView

@property (nonatomic, weak)  id<KSDebugSelectorDelegate>   delegate;
@property (nonatomic, weak)  id<KSDebugSelectorSourceData> sourceDelegate;
@property (nonatomic, assign) BOOL                       needIndicatorView;

-(UIImageView*)getIndicatorView;

-(void)setScrollIndicatorViewRate:(CGFloat)rate;

@end

