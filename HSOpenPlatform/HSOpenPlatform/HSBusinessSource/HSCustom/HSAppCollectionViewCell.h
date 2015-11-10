//
//  HSAppCollectionViewCell.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/27.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSApplicationModel.h"


@interface HSAppCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *appIconImageView;
@property (strong, nonatomic) UILabel *appNameLabel;

- (void)setupCollectionItems:(HSApplicationModel *)collectionItem;

@end
