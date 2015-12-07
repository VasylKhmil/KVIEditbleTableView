//
//  UIView+AnimatedPresentation.h
//  IceHouse
//
//  Created by Vasyl Khmil on 9/10/15.
//  Copyright (c) 2015 IceHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AnimatedPresentation)

- (void)addSubview:(UIView *)view animated:(BOOL)animated;
- (void)removeFromSuperviewAnimated:(BOOL)animated;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
