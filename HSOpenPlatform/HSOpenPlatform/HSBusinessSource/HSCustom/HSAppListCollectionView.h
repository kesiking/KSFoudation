//
//  HSAppListCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/27.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSApplicationIntroModel.h"


@interface HSAppListCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

typedef void(^AppIndexBlock)(NSInteger appIndex);

@property (strong,nonatomic) NSArray *dataArray;
@property (copy,nonatomic) AppIndexBlock appIndexBlock;


@end
