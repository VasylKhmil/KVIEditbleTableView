//
//  UIView+IBInspectable.h
//  IceHouse
//
//  Created by Vasyl Khmil on 9/10/15.
//  Copyright (c) 2015 IceHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IBINSPECTABLE)

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable BOOL masksToBounds;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
