//
//  EHPhotoBrowserCell.h
//  eHome
//
//  Created by xtq on 15/6/19.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kColumn 3           //列数
#define kPhotoSpaceX 2      //照片的横向间隔
#define kPhotoSpaceY 2      //照片的纵向间隔
#define kCellSide 2         //cell的两边留白

typedef void (^SelectedBlock)(UIImage *bigImage);

@interface EHPhotoBrowserCell : UITableViewCell

@property(nonatomic,strong)SelectedBlock selectedBlock;     //照片选择回调
@property(nonatomic,strong)UIView *selectedView;
- (void)setRowPhotos:(NSArray *)photosArray;

@end
