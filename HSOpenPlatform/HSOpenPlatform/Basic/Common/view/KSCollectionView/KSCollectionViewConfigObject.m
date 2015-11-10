//
//  KSCollectionViewConfigObject.m
//  basicFoundation
//
//  Created by 逸行 on 15-4-25.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSCollectionViewConfigObject.h"

@implementation KSCollectionViewConfigObject

-(void)setupStandConfig{
    [super setupStandConfig];
    self.isEditModel = NO;
    self.autoAdjustFrameSize = NO;
    self.isTableViewCellEditingStyleDelete = NO;
    self.minimumInteritemSpacing = 8;
    self.minimumLineSpacing = 4;
    self.collectionColumn = 2;
}

-(void)setCollectionCellSize:(CGSize)collectionCellSize{
    _collectionCellSize = collectionCellSize;
}

@end
