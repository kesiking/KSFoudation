//
//  KSTagListLayoutView.h
//  basicFoundation
//
//  Created by 逸行 on 15-5-13.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSView.h"
#import "KSTagCellView.h"

@protocol KSTagListSelectDelegate <NSObject>

- (void)clickedControl:(UIView<KSTagListSelectProtocal> *)control index:(NSUInteger)index;

@end

@interface KSTagListLayoutView : KSView{
    NSInteger _selectedIndex;
    CGFloat _prevWidth;
}

@property (nonatomic, assign) NSInteger       selectedIndex;
@property (readonly,  assign) NSUInteger      numberOfSegments;

@property (nonatomic, strong) NSMutableArray *controllerViews;

@property (nonatomic, assign) CGFloat         minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat         minimumLineSpacing;

@property (nonatomic, assign) id<KSTagListSelectDelegate> delegate;

- (void)setViewItems:(NSArray *)items;

@end
