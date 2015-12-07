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

- (void)startColumnsEditing {
    
    self.scrollEnabled = FALSE;
    
    [self addEditingPrototypeView];
    
}

#pragma mark - Private

- (void)addEditingPrototypeView {
    KVIEditableTablePrototypeView *prototypeView = [[KVIEditableTablePrototypeView alloc] initWithInitialWidths:self.columnWidths];
    
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

- (BOOL)tablePrototypeView:(KVIEditableTablePrototypeView *)tablePrototype canResizeColumnAtIndex:(NSUInteger)columnIndex {
    
    if ([self.delegate respondsToSelector:@selector(tableView:canResizeColumnAtIndex:)]) {
        return [self.delegate tableView:self canResizeColumnAtIndex:columnIndex];
    }
    
    return TRUE;
}

@end
