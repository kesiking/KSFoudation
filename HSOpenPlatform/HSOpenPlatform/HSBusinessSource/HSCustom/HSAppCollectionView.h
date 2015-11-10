//
//  HSAppCollectionView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/21.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCollectionItemTableViewCell.h"


@interface HSAppCollectionView : UITableView<UITableViewDataSource,UITableViewDelegate,HSCollectionItemTableViewCellDelegate>

typedef void(^AppIdBlock)(NSString *appId);


@property (strong,nonatomic) NSArray *dataArray;
@property (copy,nonatomic) AppIdBlock appIdBlock;

@end
