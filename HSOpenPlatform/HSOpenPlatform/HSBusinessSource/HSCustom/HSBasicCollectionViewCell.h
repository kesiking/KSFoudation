//
//  HSBasicCollectionViewCell.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/11.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HSBasicCollectionViewCell : UICollectionViewCell{
    WeAppComponentBaseItem *_model;
}

@property (strong, nonatomic) WeAppComponentBaseItem *model;

//- (void)setupCollectionItems:(WeAppComponentBaseItem *)collectionItem;


@end
