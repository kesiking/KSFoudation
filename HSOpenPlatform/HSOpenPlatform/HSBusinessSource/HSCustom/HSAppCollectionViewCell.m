//
//  HSAppCollectionViewCell.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/27.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSAppCollectionViewCell.h"

@implementation HSAppCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.appIconImageView = [[UIImageView alloc]init];
        //self.appIconImageView.image =
        [self.contentView addSubview:self.appIconImageView];
        
        self.appNameLabel = [[UILabel alloc]init];
        self.appNameLabel.textAlignment = NSTextAlignmentCenter;
        self.appNameLabel.font = EHFont2;
        self.appNameLabel.textColor = EHCor5;
        [self.contentView addSubview:self.appNameLabel];
        
        UIView *lineViewHorizontal = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        [lineViewHorizontal setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewHorizontal];
        
        UIView *lineViewVertical = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width, 0, 0.5, frame.size.height)];
        [lineViewVertical setBackgroundColor:RGB(0xda, 0xda, 0xda)];
        [self.contentView addSubview:lineViewVertical];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.appIconImageView setFrame:CGRectMake(29.5*SCREEN_SCALE, 27*SCREEN_SCALE, 67*SCREEN_SCALE, 67*SCREEN_SCALE)];
    [self.appNameLabel setFrame:CGRectMake(0, 109*SCREEN_SCALE, self.contentView.width, 15*SCREEN_SCALE)];
}

- (void)setupCollectionItems:(HSApplicationModel *)collectionItem{
    
    [self.appIconImageView sd_setImageWithURL:[NSURL URLWithString:collectionItem.appIconUrl] placeholderImage:[UIImage imageNamed:collectionItem.placeholderImageStr]];
    //[self.appIconImageView setImage:[UIImage imageNamed:collectionItem.placeholderImageStr]];

    self.appNameLabel.text = collectionItem.appName;
}







@end
