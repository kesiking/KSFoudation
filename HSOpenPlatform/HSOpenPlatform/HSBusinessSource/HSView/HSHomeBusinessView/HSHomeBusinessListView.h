//
//  HSHomeBusinessListView.h
//  HSOpenPlatform
//
//  Created by xtq on 15/10/29.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommonAppListCollectionView.h"
#import "HSHomeBusinessListCell.h"

#define home_business_minimumLineSpacing (caculateNumber(10))

typedef void(^ServiceDidFinishLoadBlock)(void);

@interface HSHomeBusinessListView : HSCommonAppListCollectionView

@property (nonatomic, copy) ServiceDidFinishLoadBlock serviceDidFinishLoadBlock;

-(void)refreshDataRequest;

@end
