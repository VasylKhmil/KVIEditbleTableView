//
//  ColumnsCell.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIColumnsCell.h"
#import "KVIEditableTableView.h"

@interface KVIColumnsCell ()

@property (nonatomic, strong) NSArray *columnViews;

@property (nonatomic, strong) NSArray *columnWidths;

@property (nonatomic) NSUInteger numberOfColumns;

@property (nonatomic) BOOL showHeaders;

@end


@implementation KVIColumnsCell

#pragma mark - Public

- (void)reload {
    
    [self readData];
    [self buildView];
    
}

#pragma mark - Override

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self clearView];
}

#pragma mark - Private

- (void)readData {
    
    self.numberOfColumns = [self.dataSource numberOfColumnsInCell:self];
    
    NSMutableArray *widths = [NSMutableArray new];
    NSMutableArray *views = [NSMutableArray new];
    
    for (int i = 0; i < self.numberOfColumns; ++i) {
        CGFloat width = [self.dataSource columnsCell:self widthForColumnAtIndex:i];
        UIView *view = [self.dataSource columntsCell:self viewForColumnAtIndex:i];
        
        [widths addObject:@(width)];
        [views addObject:view];
    }
    
    self.columnWidths = widths;
    self.columnViews = views;
}

- (void)clearView {
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - Building

- (void)buildView {
    
    __block UIView *previousView;
    
    [self.columnViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.translatesAutoresizingMaskIntoConstraints = FALSE;
        
        [self.contentView addSubview:obj];
        
        [self setupVerticalConstraintsForView:obj];
        
        NSNumber *width = self.columnWidths[idx];
        
        [self addWidthConstraintToView:obj withWidth:width.floatValue];

        [self addLeadingConstraintToView:obj withPreviousView:previousView];
        
        [self addTrailingConstraintiIfNeedToView:obj];
        
        previousView = obj;
        
    }];
}

- (void)setupVerticalConstraintsForView:(UIView *)view {
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0];
    
    [self.contentView addConstraints:@[centerY]];
}

- (void)setupHorizontalConstraintsForView:(UIView *)view
                                withWidth:(CGFloat)width
                             previousView:(UIView *)previousView
                                 nextView:(UIView *)nextView {
    
    [self addWidthConstraintToView:view withWidth:width];
    
}

- (void)addWidthConstraintToView:(UIView *)view withWidth:(CGFloat)width {
    
    if (width != KVIColumnsDynamicWidth) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:width];
        
        [view addConstraint:widthConstraint];
    }
}

- (void)addLeadingConstraintToView:(UIView *)view withPreviousView:(UIView *)previousView {
    
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
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0];
        
    }
    
    [self.contentView addConstraint:leadingConstraint];
}

- (void)addTrailingConstraintiIfNeedToView:(UIView *)view {
    
    if ([self needTrailingConstraintToSelfForView:view]) {
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0 constant:0.0];
        
        [self.contentView addConstraint:trailingConstraint];
    }
}

- (BOOL)needTrailingConstraintToSelfForView:(UIView *)view {
    NSArray *widths = [self.columnWidths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSNumber*  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isEqualToNumber:@(KVIColumnsDynamicWidth)];
    }]];
    
    return (widths.count > 0) && (self.columnViews.lastObject == view);
}


@end
