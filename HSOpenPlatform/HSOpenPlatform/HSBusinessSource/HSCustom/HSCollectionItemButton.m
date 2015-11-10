//
//  HSCollectionItemButton.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCollectionItemButton.h"
#import "UIColor+Ext.h"


#define kImageHeightPercent 0.65


@implementation HSCollectionItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = EHFont5;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:EHCor4 forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * kImageHeightPercent;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * kImageHeightPercent;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * (1 - kImageHeightPercent);
    
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
