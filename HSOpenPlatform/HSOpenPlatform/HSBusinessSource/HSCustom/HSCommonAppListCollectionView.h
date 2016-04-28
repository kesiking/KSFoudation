//
//  HSHorizontalCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCommonAppListCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSIndexPath *_itemIndexPath;
    //    Class _cellClass;
}

typedef void(^ItemIndexBlock)(NSIndexPath *itemIndexPath);
typedef void(^ItemDeselectBlock)(NSIndexPath *itemIndexPath);

@property (strong,nonatomic) NSArray *dataArray;
@property (copy,nonatomic) ItemIndexBlock itemIndexBlock;
@property (copy,nonatomic) ItemDeselectBlock itemDeselectBlock;
@property (strong,nonatomic) NSIndexPath *itemIndexPath;
@property (assign,nonatomic) CGFloat cellWidth;
@property (assign,nonatomic) CGFloat cellHeight;

//@property (strong, nonatomic) Class cellClass;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellClass:(Class)cellClass;

@end
