//
//  HSAfterSaleProductCollectionView.h
//  HSOpenPlatform
//
//  Created by xtq on 16/3/31.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSCommonAppListCollectionView.h"

typedef void(^ServiceDidFailLoadBlock)(void);
typedef void(^ServiceDidFinishLoadBlock)(void);

@interface HSAfterSaleProductCollectionView : HSCommonAppListCollectionView

@property (nonatomic, copy) ServiceDidFinishLoadBlock serviceDidFinishLoadBlock;

@property (nonatomic, copy) ServiceDidFailLoadBlock serviceDidFailLoadBlock;

-(void)refreshDataRequest;

@end
