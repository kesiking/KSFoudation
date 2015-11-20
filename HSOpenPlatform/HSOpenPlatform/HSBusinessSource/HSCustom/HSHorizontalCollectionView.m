//
//  HSHorizontalCollectionView.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHorizontalCollectionView.h"
//#import "HSHorizontalCollectionViewCell.h"
#import "HSBasicCollectionViewCell.h"
#import "HSApplicationModel.h"

@interface HSHorizontalCollectionView ()

@property (strong, nonatomic) Class cellClass;


@end

@implementation HSHorizontalCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cellClass:(Class)cellClass{
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _cellClass = cellClass;
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
//        self.cellClass = [HSBasicCollectionViewCell class];
//        [self registerClass:self.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [[NSArray alloc]init];
    }
    return self;
}

//- (void)setCellClass:(Class)cellClass {
//    _cellClass = cellClass;
//    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
//}
//-(Class)cellClass{
//    if (_cellClass != nil) {
//        return _cellClass;
//    }
//    return [HSBasicCollectionViewCell class];
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //static NSString *cellID = NSStringFromClass(self.cellClass);
    //HSHorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
//    WeAppComponentBaseItem *model = [[self.modelClass alloc]init];
//    model = self.dataArray[indexPath.row];
    HSBasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH/6,SCREEN_WIDTH/6);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.itemIndexBlock?:self.itemIndexBlock(indexPath.row);
    
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
