//
//  EHImageMagicMoveTransition.m
//  6.15-test-setHeadImage
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHImageMagicMoveTransition.h"
#import "EHPhotoBrowserViewController.h"
#import "EHPhotoPlayViewController.h"
#import "EHPhotoBrowserCell.h"

@implementation EHImageMagicMoveTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    EHPhotoBrowserViewController *fromVC = (EHPhotoBrowserViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EHPhotoPlayViewController *toVC = (EHPhotoPlayViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    EHPhotoBrowserCell *cell = (EHPhotoBrowserCell *)[fromVC.tableView cellForRowAtIndexPath:[[fromVC.tableView indexPathsForSelectedRows] firstObject]];
    cell.selectedView.hidden = YES;
    
    UIImageView *imv = [[UIImageView alloc]initWithImage:toVC.bigImage];
    imv.clipsToBounds = YES;
    imv.contentMode = UIViewContentModeScaleAspectFill;
    imv.frame = [containerView convertRect:cell.selectedView.frame fromView:cell.selectedView.superview];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:imv];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.alpha = 1.0;
        
        CGRect frame = [containerView convertRect:toVC.imageView.frame fromView:toVC.imageView.superview];
        imv.frame = frame;
    } completion:^(BOOL finished) {
        toVC.imageView.hidden = NO;
        cell.selectedView.hidden = NO;
        [imv removeFromSuperview];
 
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
    
}
@end
