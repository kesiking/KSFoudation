//
//  WeAppCollectionViewCell.h
//  WeAppSDK
//
//  Created by 逸行 on 14-10-31.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSViewCell.h"

@interface KSCollectionViewCell : UICollectionViewCell<KSViewCellProtocol>

+(NSString*)reuseIdentifier;

@property (nonatomic, strong) Class                       viewCellClass;

@property (nonatomic, strong) KSViewCell*                 cellView;

@property (nonatomic,weak) KSScrollViewServiceController* scrollViewCtl;

@end
