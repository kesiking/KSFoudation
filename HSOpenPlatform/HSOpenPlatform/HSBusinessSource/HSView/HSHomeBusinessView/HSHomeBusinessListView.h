//
//  HSHomeBusinessListView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHomeBusinessListCell.h"

typedef void(^AppSelectedBlock)(NSInteger selectedIndex);

@interface HSHomeBusinessListView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) NSArray *dataArray;

@property (copy,nonatomic) AppSelectedBlock appSelectedBlock;

@end
