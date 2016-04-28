//
//  HSDeviceCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 16/3/28.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "HSCommonAppListCollectionView.h"
#import "HSDeviceModel.h"

typedef void(^ServiceDidFailLoadBlock)(void);
typedef void(^ServiceDidFinishLoadBlock)(void);
//typedef void(^DataArrayRefreshBlock)(NSInteger dataArrayCount);

@interface HSDeviceCollectionView : HSCommonAppListCollectionView

@property (nonatomic, copy) ServiceDidFinishLoadBlock serviceDidFinishLoadBlock;

@property (nonatomic, copy) ServiceDidFailLoadBlock serviceDidFailLoadBlock;

//@property (nonatomic, copy) DataArrayRefreshBlock dataArrayRefreshBlock;

-(void)refreshDataRequest;


@end
