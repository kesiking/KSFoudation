//
//  HSCollectionItemView.h
//  HSOpenPlatform
//
//  Created by jinmiao on 15/10/19.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCollectionItemCount 3
#define kHSCollectionItemTableViewCellHeight 90

@class HSCollectionItemView;
@protocol HSCollectionItemViewDelegate <NSObject>
@optional
- (void)collectionItemView:(HSCollectionItemView *)collectionView actionWithTag:(NSInteger)tag;
@end


@interface HSCollectionItemView : UIView

@property (weak, nonatomic) id<HSCollectionItemViewDelegate> viewDelegate;
- (void)setupCollectionItems:(NSArray *)CollectionItemList;

@end
