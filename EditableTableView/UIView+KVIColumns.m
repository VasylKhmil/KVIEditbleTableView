//
//  UIView+KVIColumns.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 12/10/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "UIView+KVIColumns.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) NSMutableArray *kvi_columns;

@end

@implementation UIView (KVIColumns)

#pragma mark - Properties

- (NSMutableArray *)kvi_columns {
    return objc_getAssociatedObject(self, @selector(kvi_columns));
}

- (void)setKvi_columns:(NSMutableArray *)kvi_columns {
    objc_setAssociatedObject(self, @selector(kvi_columns), kvi_columns, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Public

- (void)kvi_startColumnsAdding {
    NSArray *columnsConstraints = [self.constraints filteredArrayUsingPredicate:
                                   [NSPredicate predicateWithBlock:
                                    ^BOOL(NSLayoutConstraint*  _Nonnull evaluatedObject,
                                          NSDictionary<NSString *,id> * _Nullable bindings) {
                                        return [self.kvi_columns containsObject:evaluatedObject.firstItem] ||
                                        [self.kvi_columns containsObject:evaluatedObject.secondItem];
    }]];
    
    [self removeConstraints:columnsConstraints];
    
    for (UIView *column in self.kvi_columns) {
        [column removeFromSuperview];
    }
    
    self.kvi_columns = [NSMutableArray new];
}

- (void)kvi_addNewColumn:(UIView *)newColumn withWidth:(NSNumber *)width isLast:(BOOL)isLast {
    
    UIView *previousColumn = self.kvi_columns.lastObject;
    
    [self addSubview:newColumn];
    
    newColumn.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    [self kvi_setupVerticalConstraintsForView:newColumn];
    
    if (width != nil) {
        [self kvi_addWidthConstraintToView:newColumn withWidth:width.floatValue];
    }
    
    [self kvi_addLeadingConstraintToView:newColumn withPreviousView:previousColumn];
    
    if (isLast) {
        [self kvi_addTrailingConstraintiIfNeedToView:newColumn];
    }
    
    [self.kvi_columns addObject:newColumn];
    
}

#pragma mark - Constraints

- (void)kvi_setupVerticalConstraintsForView:(UIView *)view {
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0];
    
    [self addConstraint:centerY];
}

- (void)kvi_addWidthConstraintToView:(UIView *)view withWidth:(CGFloat)width {
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:width];
    
    [view addConstraint:widthConstraint];
}

- (void)kvi_addLeadingConstraintToView:(UIView *)view withPreviousView:(UIView *)previousView {
    
    NSLayoutConstraint *leadingConstraint;
    if (previousView != nil) {
        
        leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:previousView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0.0];
        
        
    } else {
        
        leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0];
        
    }
    
    [self addConstraint:leadingConstraint];
}

- (void)kvi_addTrailingConstraintiIfNeedToView:(UIView *)view {
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0 constant:0.0];
    
    [self addConstraint:trailingConstraint];
}


@end
