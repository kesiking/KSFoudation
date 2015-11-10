//
//  EHImageMagicMoveInverseTransition.m
//  6.15-test-setHeadImage
//
//  Created by xtq on 15/6/23.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "EHImageMagicMoveInverseTransition.h"
#import "EHPhotoBrowserViewController.h"
#import "EHPhotoPlayViewController.h"
#import "EHPhotoBrowserCell.h"

@implementation EHImageMagicMoveInverseTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    EHPhotoPlayViewController *fromVC = (EHPhotoPlayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EHPhotoBrowserViewController *toVC = (EHPhotoBrowserViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    UIImageView *imv = [[UIImageView alloc]initWithImage:fromVC.bigImage];
    imv.clipsToBounds = YES;
    imv.contentMode = UIViewContentModeScaleAspectFill;
    imv.frame = [containerView convertRect:fromVC.imageView.frame fromView:fromVC.imageView.superview];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    EHPhotoBrowserCell *cell = (EHPhotoBrowserCell *)[toVC.tableView cellForRowAtIndexPath:[[toVC.tableView indexPathsForSelectedRows] firstObject]];
    cell.selectedView.hidden = YES;

    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:imv];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.alpha = 0.0f;
        imv.frame = [containerView convertRect:cell.selectedView.frame fromView:cell.selectedView.superview];
    } completion:^(BOOL finished) {
        [imv removeFromSuperview];
        fromVC.imageView.hidden = NO;
        cell.selectedView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
