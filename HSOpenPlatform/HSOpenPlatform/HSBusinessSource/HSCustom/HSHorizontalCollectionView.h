//
//  HSHorizontalCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSHorizontalCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>
//{
//    Class _cellClass;
//}

typedef void(^ItemIndexBlock)(NSInteger itemIndex);

@property (strong,nonatomic) NSArray *dataArray;
@property (copy,nonatomic) ItemIndexBlock itemIndexBlock;
@property (assign,nonatomic) NSInteger itemIndex;

//@property (strong, nonatomic) Class cellClass;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellClass:(Class)cellClass;

@end
