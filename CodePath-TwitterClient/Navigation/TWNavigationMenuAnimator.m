//
//  TWNavigationMenuAnimator.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWNavigationMenuAnimator.h"
#import "TWNavigationMenuViewController.h"

@implementation TWNavigationMenuAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    BOOL isPresenting = [toViewController isKindOfClass:[TWNavigationMenuViewController class]];
    
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    CGFloat width = CGRectGetWidth(toFrame);
    
    UIView *shadowView = [[UIView alloc] initWithFrame:toFrame];
    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    void(^completion)(BOOL) = ^(BOOL finished){
        fromViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.transform = CGAffineTransformIdentity;
        if (isPresenting) {
            toViewController.view.backgroundColor = shadowView.backgroundColor;
            [shadowView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };
    
    if (!isPresenting) {
        toViewController.view.frame = toFrame;
        fromViewController.view.backgroundColor = [UIColor clearColor];
        [[transitionContext containerView] insertSubview:shadowView belowSubview:fromViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            shadowView.alpha = 0;
            fromViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(-width, 0);
        } completion:completion];
    }
    else {
        [[transitionContext containerView] addSubview:shadowView];
        [[transitionContext containerView] addSubview:toViewController.view];
        toViewController.view.frame = toFrame;
        toViewController.view.transform = CGAffineTransformMakeTranslation(-width, 0);
        shadowView.alpha = 0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            shadowView.alpha = 1;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:completion];
    }
}

@end
