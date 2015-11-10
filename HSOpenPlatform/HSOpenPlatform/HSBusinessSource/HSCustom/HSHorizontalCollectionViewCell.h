//
//  HSHorizontalCollectionViewCell.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSApplicationModel.h"

@interface HSHorizontalCollectionViewCell : UICollectionViewCell

//@property (strong, nonatomic) UIImageView *appIconImageView;
//@property (strong,nonatomic) NSString *appIconUrlStr;
//@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) HSApplicationModel *appModel;

//- (void)setupCollectionItems:(HSApplicationModel *)collectionItem;

@end
