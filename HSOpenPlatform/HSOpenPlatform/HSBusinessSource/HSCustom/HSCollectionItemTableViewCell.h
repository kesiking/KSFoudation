//
//  HSCollectionItemTableViewCell.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/20.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HSCollectionCellItem.h"
#import "HSApplicationModel.h"


#define kCollectionItemCount 3
#define kHSCollectionItemTableViewCellHeight 150

@class HSCollectionItemTableViewCell;
@protocol HSCollectionItemTableViewCellDelegate <NSObject>
@optional
- (void)collectionItemCell:(HSCollectionItemTableViewCell *)cell actionWithAppId:(NSInteger)tag;
@end


@interface HSCollectionItemTableViewCell : UITableViewCell
@property (weak, nonatomic) id<HSCollectionItemTableViewCellDelegate> cellDelegate;

//@property (strong, nonatomic)NSArray *colorArray;
- (void)setupCollectionItems:(NSArray *)CollectionItemList;

@end
