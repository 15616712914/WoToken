//
//  PushTransition.m
//  JC_NavTransitionAnimation
//
//  Created by haobitou on 15/8/12.
//  Copyright (c) 2015年 haobitou. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.7f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVc = [transitionContext finalFrameForViewController:toVc];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    toVc.view.frame = CGRectOffset(finalFrameForVc, bounds.size.width, 0);
    
    [[transitionContext containerView] addSubview:toVc.view];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         fromVc.view.alpha = 0.8;
                         toVc.view.frame = finalFrameForVc;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         fromVc.view.alpha = 1.0;
                     }];
}

@end
