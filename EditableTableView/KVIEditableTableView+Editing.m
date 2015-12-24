//
//  KVIEditableTableView+Editing.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTableView+Editing.h"
#import "KVIEditableTablePrototypeView.h"

@implementation KVIEditableTableView (Editing)

static NSInteger KVIEditingPrototypeViewTag = -1;

- (void)startColumnsEditing {
    
    self.scrollEnabled = FALSE;
    
    [self addEditingPrototypeView];
    
}

- (void)endColumnsEditing {
    self.scrollEnabled = TRUE;
    
    KVIEditableTablePrototypeView *prototypeView = [self viewWithTag:KVIEditingPrototypeViewTag];
    
    [prototypeView removeConstraints:prototypeView.constraints];
    
    [prototypeView removeFromSuperview];
    
    [self reloadData];
}

- (BOOL)columnsIsEditing {
    return [self viewWithTag:KVIEditingPrototypeViewTag] != nil;
}


- (void)updatePrototypeView {
    if (self.columnsIsEditing) {
        KVIEditableTablePrototypeView *prototypeView = [self viewWithTag:KVIEditingPrototypeViewTag];
        
        [prototypeView reloadWithWidths:self.columnWidths];
    }
}

#pragma mark - Private

- (void)addEditingPrototypeView {
    KVIEditableTablePrototypeView *prototypeView = [[KVIEditableTablePrototypeView alloc] initWithInitialWidths:self.columnWidths];
    
    prototypeView.delegate = self;
    
    prototypeView.tag = KVIEditingPrototypeViewTag;
    
    [self addSubview:prototypeView];
    
    prototypeView.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
    
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:self.contentOffset.y];

   
    [self addConstraints:@[widthConstraint, heightConstraint, xConstraint, yConstraint]];
}

#pragma mark - KVIEditableTablePrototypeViewDelegate

- (BOOL)tablePrototypeViewCanResizeColumns:(KVIEditableTablePrototypeView *)tablePrototype {
    
    if ([self.editableDelegate respondsToSelector:@selector(tableViewCanResizeColumns:)]) {
        return [self.editableDelegate tableViewCanResizeColumns:self];
    }
    
    return TRUE;
}

- (BOOL)tablePrototypeViewCanSwapColumns:(KVIEditableTablePrototypeView *)tablePrototype {
    if ([self.editableDelegate respondsToSelector:@selector(tableViewCanSwapColumns:)]) {
        return [self.editableDelegate tableViewCanSwapColumns:self];
    }
    
    return TRUE;
}

- (BOOL)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype canRemoveColumnAtIndex:(NSUInteger)columnIndex {
    if ([self.editableDelegate respondsToSelector:@selector(tableView:canRemoveColumnAtIndex:)]) {
        return [self.editableDelegate tableView:self canRemoveColumnAtIndex:columnIndex];
    }
    
    return TRUE;
}

- (BOOL)tablePrototypeViewCanAddNewColumns:(KVIEditableTablePrototypeView *)tablePrototype {
    if ([self.editableDelegate respondsToSelector:@selector(tableViewCanAddNewColumns:)]) {
        return [self.editableDelegate tableViewCanAddNewColumns:self];
    }
    
    return TRUE;
}

- (void)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype resizedColumnAtIndex:(NSUInteger)columnIndex toSize:(CGFloat)newSize {
    
    if ([self.editableDelegate respondsToSelector:@selector(tableView:resizedColumngAtIndex:toSize:)]) {
        [self.editableDelegate tableView:self resizedColumngAtIndex:columnIndex toSize:newSize];
    }
}

- (void)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype swapedColumnAtIndex:(NSUInteger)firstColumnIndex withColumnAtIndex:(NSUInteger)secondColumnIndex {
    
    if ([self.editableDelegate respondsToSelector:@selector(tableView:swapedColumnAtIndex:withColumnAtIndex:)]) {
        [self.editableDelegate tableView:self swapedColumnAtIndex:firstColumnIndex withColumnAtIndex:secondColumnIndex];
    }
}

- (void)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype removedColumnAtIndex:(NSUInteger)columnIndex {
    
    if ([self.editableDelegate respondsToSelector:@selector(tableView:removedColumnAtIndex:)]) {
        [self.editableDelegate tableView:self removedColumnAtIndex:columnIndex];
    }
    
}

- (void)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype addedColumnWithWidht:(CGFloat)width {
    
    if ([self.editableDelegate respondsToSelector:@selector(tableView:addedColumnWithWidht:)]) {
        [self.editableDelegate tableView:self addedColumnWithWidht:width];
    }
    
}

- (NSString *)tablePrototypeView:(KVIEditableColumnPrototypeView *)tablePrototype headerForColumnAtIndex:(NSUInteger)columnIndex {
    
    if ([self.editableDataSource respondsToSelector:@selector(tableView:headerForColumnAtIndex:)]) {
        return [self.editableDataSource tableView:self headerForColumnAtIndex:columnIndex];
    }
    
    return nil;
}

@end
