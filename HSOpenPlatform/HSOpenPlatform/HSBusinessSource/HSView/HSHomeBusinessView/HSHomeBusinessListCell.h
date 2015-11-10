//
//  HSHomeBusinessListCell.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSApplicationModel.h"

#define home_businessListCell_height               (caculateNumber(124))

@interface HSHomeBusinessListCell : UICollectionViewCell

- (void)setupCollectionItem:(HSApplicationModel *)item;

@end
