//
//  UIView+IBInspectable.m
//  IceHouse
//
//  Created by Vasyl Khmil on 9/10/15.
//  Copyright (c) 2015 IceHouse. All rights reserved.
//

#import "UIView+IBINSPECTABLE.h"

@implementation UIView (IBINSPECTABLE)
@dynamic cornerRadius, borderWidth, shadowOffset, shadowOpacity, shadowRadius, masksToBounds, borderColor;

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
