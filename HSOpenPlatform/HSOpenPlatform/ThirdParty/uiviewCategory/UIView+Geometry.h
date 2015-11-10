//
//  UIView+Geometry.h
//  TBUtility
//
//  Created by lv on 14-4-2.
//
//

#import <UIKit/UIKit.h>

typedef BOOL(^IsViewEnableBlock)(UIView *view);

/**
 * 移入plugin中 TB_UIViewAdditions.h
 */
@interface UIView (Geometry)
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

- (UIViewController*)viewController;
- (UIView*)descendantOrSelfWithClass:(Class)cls;
- (UIView*)ancestorOrSelfWithClass:(Class)cls;
- (void)removeAllSubviews;
//获取当前view的superView属性，通过IsViewEnableBlock判断是否需要的view，若是所需view则返回当前view，否则返回nil;
-(id)getEnableViewFromSuperView:(IsViewEnableBlock)IsViewEnableBlock;

@end
