//
//  EHImageClipView.h
//  8.13-test-layerClip
//
//  Created by xtq on 15/8/14.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHImageClipView : UIView

@property (nonatomic, strong)UIColor *dimingColor;

- (UIImage *)imageClipped;

@end
