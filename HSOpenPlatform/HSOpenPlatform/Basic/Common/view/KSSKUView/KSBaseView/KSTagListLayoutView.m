//
//  KSTagListLayoutView.m
//  basicFoundation
//
//  Created by 逸行 on 15-5-13.
//  Copyright (c) 2015年 逸行. All rights reserved.
//

#import "KSTagListLayoutView.h"

@implementation KSTagListLayoutView

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Accessor

- (void)setSelectedIndex:(NSInteger)index {
    UIView<KSTagListSelectProtocal> *view;
    if (_selectedIndex > -1) {
        view = [self.controllerViews objectAtIndex:_selectedIndex];
        [view setSelected:NO];
    }
    
    _selectedIndex = index;
    
    if (_selectedIndex >= 0) {
        view = [self.controllerViews objectAtIndex:_selectedIndex];
        [view setSelected:YES];
    }
}

- (NSInteger)selectedIndex {
    return _selectedIndex;
}

- (NSUInteger)numberOfSegments {
    return [self.controllerViews count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

-(void)setupView{
    [super setupView];
    _controllerViews = [[NSMutableArray alloc] init];
    [self performLayoutSubviews];
    // 小于0 说明没有选择
    _selectedIndex = -1;
    _minimumInteritemSpacing = TBSKU_PROP_LINE_GAP;
    _minimumLineSpacing = TBSKU_PROP_HORIZONTAL_GAP;
}

- (void)setViewItems:(NSArray *)viewItems{
    for (UIView<KSTagListSelectProtocal> *view in self.controllerViews) {
        [view removeFromSuperview];
    }
    
    [self.controllerViews removeAllObjects];
    
    for (UIView<KSTagListSelectProtocal> *view in viewItems) {
        if (![view conformsToProtocol:@protocol(KSTagListSelectProtocal)]) {
            continue;
        }
        
        //添加手势，点击屏幕其他区域关闭键盘的操作
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(propButtonClicked:)];
        gesture.numberOfTapsRequired = 1;
        gesture.cancelsTouchesInView = NO;
        [view addGestureRecognizer:gesture];
        
        [self addSubview:view];
        [self.controllerViews addObject:view];
    }
    
    [self performLayoutSubviews];
}

- (void)propButtonClicked:(UIGestureRecognizer*)gestureRecognizer {
    UIView<KSTagListSelectProtocal>* view = (UIView<KSTagListSelectProtocal>*)gestureRecognizer.view;
    NSUInteger index = [self.controllerViews indexOfObject:view];
    if (index == NSNotFound) {
        return;
    }
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
    }else{
        self.selectedIndex = -1;
    }
    if ([self.delegate respondsToSelector:@selector(clickedControl:index:)]) {
        [self.delegate clickedControl:view index:index];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override
- (void)layoutSubviews {
    [super layoutSubviews];
    [self performLayoutSubviews];
}

- (void)performLayoutSubviews {
    CGFloat width = self.width;
    
//    if (_prevWidth == width) {
//        return;
//    }
    
    _prevWidth = width;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    int rows = 0;
    
    for (int i = 0; i < [self.controllerViews count]; ++i) {
        UIView *view = [self.controllerViews objectAtIndex:i];
        if (x + view.width > width) {
            x = 0;
            rows++;
            if (i > 0) {
                y = ((UIView*)[self.controllerViews objectAtIndex:i-1]).height + y + self.minimumInteritemSpacing;
            }
        }
        
        view.frame = CGRectMake(x, y, view.width, view.height);
        x += view.width + self.minimumLineSpacing;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = size;
    
    if ([self.controllerViews count] > 0) {
        CGRect rect = self.bounds;
        
        UIView *view = [self.controllerViews objectAtIndex:[self.controllerViews count] - 1];
        rect.size.height = view.bottom;
        
        /*Bug,会以中点，上下缩的，不能直接设置Bound*/
        newSize = CGSizeMake(newSize.width, rect.size.height);
    }else {
        newSize = CGSizeZero;
    }
    
    return newSize;
}
@end
