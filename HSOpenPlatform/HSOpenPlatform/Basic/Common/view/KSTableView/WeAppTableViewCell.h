//
//  WeAppTableViewCell.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-1.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSViewCell.h"

@interface WeAppTableViewCell : UITableViewCell<KSViewCellProtocol>

+(NSString*)reuseIdentifier;

+(id)createCell;

@property (nonatomic, strong) Class                viewCellClass;

@property (nonatomic, strong) KSViewCell*          cellView;

@property (nonatomic, weak)   KSScrollViewServiceController* scrollViewCtl;

@end
