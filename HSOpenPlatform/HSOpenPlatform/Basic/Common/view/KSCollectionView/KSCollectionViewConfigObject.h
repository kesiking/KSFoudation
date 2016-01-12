//
//  KSCollectionViewConfigObject.h
//  basicFoundation
//
//  Created by 逸行 on 15-4-25.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSScrollViewConfigObject.h"

@interface KSCollectionViewConfigObject : KSScrollViewConfigObject

//如果设置collectionColumn，优先级将高于collectionCellSize的设置，会根据frame控制collectionCellSize的宽度
@property (nonatomic, assign) NSUInteger           collectionColumn;
@property (nonatomic, assign) CGSize               collectionCellSize;
@property (nonatomic, assign) NSUInteger           minimumInteritemSpacing;
@property (nonatomic, assign) NSUInteger           minimumLineSpacing;

// Updates the frame size as items are added/removed. Default is NO.
@property (nonatomic, assign) BOOL                 autoAdjustFrameSize;
// 默认为NO，如果为YES，表示KSTableViewController或是KSCollectionViewController进入编辑模式，cell中根据这个状态来更新cell的UI样式
@property (nonatomic, assign) BOOL                 isEditModel;
// tableView的删除状态（-tableView:canEditRowAtIndexPath:方法中返回），控制tableView的全选编辑状态，注：只有KSTableViewController有该功能，使用的是tabView自带删除按钮，一般不使用，主要由isEditModel来代替
@property (nonatomic, assign) BOOL                 isTableViewCellEditingStyleDelete;
// 允许手势选中（类似于iphone默认相册的功能，横向滑动可选中划过的照片），注：只有KSCollectionViewController有该功能
@property (nonatomic, assign) BOOL                 allowsPanGestureSelection;


@end
