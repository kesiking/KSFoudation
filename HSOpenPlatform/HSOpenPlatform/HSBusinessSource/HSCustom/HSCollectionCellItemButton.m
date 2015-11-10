//
//  HSCollectionCellItemButton.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCollectionCellItemButton.h"
#import "UIColor+Ext.h"

#define kImageHeightPercent 0.86


@implementation HSCollectionCellItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = EHFont2;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:EHCor5 forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 27*SCREEN_SCALE;
    CGFloat imageW = contentRect.size.width;
    //CGFloat imageH = 30;
    CGFloat imageH = 67*SCREEN_SCALE;
    //CGFloat imageH = contentRect.size.height * kImageHeightPercent;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = 109*SCREEN_SCALE;
    //CGFloat y = contentRect.size.height * kImageHeightPercent;
    CGFloat width = contentRect.size.width;
    CGFloat height = 15*SCREEN_SCALE;
    //CGFloat height = contentRect.size.height * (1 - kImageHeightPercent);
    
    return CGRectMake(x, y, width, height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
