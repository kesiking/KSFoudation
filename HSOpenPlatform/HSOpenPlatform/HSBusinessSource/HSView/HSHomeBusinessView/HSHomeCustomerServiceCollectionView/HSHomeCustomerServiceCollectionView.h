//
//  HSHomeCustomerServiceCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/11/5.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "HSCommonAppListCollectionView.h"
#import "HSApplicationModel.h"

typedef void(^ServiceDidFailLoadBlock)(void);
typedef void(^ServiceDidFinishLoadBlock)(void);


@interface HSHomeCustomerServiceCollectionView : HSCommonAppListCollectionView

@property (nonatomic, copy) ServiceDidFinishLoadBlock serviceDidFinishLoadBlock;

@property (nonatomic, copy) ServiceDidFailLoadBlock serviceDidFailLoadBlock;

-(void)refreshDataRequest;

@end
