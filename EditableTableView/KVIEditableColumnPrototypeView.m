//
//  KVIEditableColumnView.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableColumnPrototypeView.h"
#import "UIView+IBINSPECTABLE.h"

@implementation KVIEditableColumnPrototypeView

#pragma mark - Properties

- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    
    if (_widthConstraint != nil) {
        [self removeConstraint:_widthConstraint];
    }
    
    _widthConstraint = widthConstraint;
    
    [self addConstraint:widthConstraint];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.backgroundColor = selected ? [UIColor grayColor] : [UIColor whiteColor];
    self.borderColor = selected ? [UIColor redColor] : [UIColor clearColor];
    
}

@end
