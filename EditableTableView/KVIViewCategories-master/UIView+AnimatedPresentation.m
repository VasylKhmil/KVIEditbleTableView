//
//  UIView+AnimatedPresentation.m
//  IceHouse
//
//  Created by Vasyl Khmil on 9/10/15.
//  Copyright (c) 2015 IceHouse. All rights reserved.
//

#import "UIView+AnimatedPresentation.h"

@implementation UIView (AnimatedPresentation)

- (void)addSubview:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        view.hidden = YES;
        [self addSubview:view];
        [view animateShowingWithCompletition:nil];
    } else {
        [self addSubview:view];
    }
}

- (void)removeFromSuperviewAnimated:(BOOL)animated {
    if (animated) {
        [self animateHidingWithCompletition:^{
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    if (animated) {
        
        if (hidden) {
            [self animateHidingWithCompletition:nil];
        } else {
            [self animateShowingWithCompletition:nil];
        }
        
    } else {
        self.hidden = hidden;
    }
}

#pragma mark - Animation
#pragma mark - Animation(Constants)

static NSTimeInterval AnimationDuration = 0.2;

#pragma mark - Animation(Methods)

- (void)animateShowingWithCompletition:(void (^)())completion {
    if (!self.hidden) {
        return;
    }
    
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithAnimation:^{
        self.alpha = 1;
    } completion:completion];
}

- (void)animateHidingWithCompletition:(void (^)())completion {
    if (self.hidden) {
        return;
    }
    
    self.alpha = 1;
    [UIView animateWithAnimation:^{
        self.alpha = 0;
    } completion:^{
        self.hidden = YES;
        
        if (completion != nil) {
            completion();
        }
    }];
}

+ (void)animateWithAnimation:(void (^)())animation completion:(void (^)())completion {
    [UIView animateWithDuration:AnimationDuration
                     animations:animation
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

@end
