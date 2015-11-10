//
//  HSHomeCustomerServiceCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSHorizontalCollectionView.h"
#import "HSApplicationModel.h"

typedef void(^ServiceDidFailLoadBlock)(void);

@interface HSHomeCustomerServiceCollectionView : HSHorizontalCollectionView

@property (nonatomic, copy) ServiceDidFailLoadBlock serviceDidFailLoadBlock;

-(void)refreshDataRequest;

@end
