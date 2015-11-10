//
//  EHPhotoBrowserCell.m
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "EHPhotoBrowserCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation EHPhotoBrowserCell
{
    NSArray *_photosArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat photoWidth = (SCREEN_WIDTH - kPhotoSpaceX * (kColumn - 1) - kCellSide * 2) / kColumn;

        for (int i = 0; i < kColumn; i++) {
            UIImageView *imv = [[UIImageView alloc]init];
            imv.frame = CGRectMake(kCellSide + (photoWidth + kPhotoSpaceX) * i, 0, photoWidth, photoWidth);
            imv.tag = i + 1;
            imv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [imv addGestureRecognizer:tap];
            [self.contentView addSubview:imv];
        }
    }
    return self;
}

- (void)setRowPhotos:(NSArray *)photosArray{
    for (int i = 0; i < kColumn; i++) {
        UIImageView *imv = (UIImageView *)[self.contentView viewWithTag:i+1];
        if (i >= photosArray.count) {
            imv.hidden = YES;
        }
        else{
            imv.hidden = NO;
            ALAsset *photoAssert = [photosArray objectAtIndex:i];
            [imv setImage:[UIImage imageWithCGImage:[photoAssert thumbnail]]];
        }
    }
    _photosArray = photosArray;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *imv = (UIImageView *)tap.view;
    self.selectedView = imv;
    ALAsset *photoAssert = [_photosArray objectAtIndex:(imv.tag - 1)];
    UIImage *bigImage = [UIImage imageWithCGImage:[[photoAssert defaultRepresentation] fullScreenImage]];
    !self.selectedBlock?:self.selectedBlock(bigImage);
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
