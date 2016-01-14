//
//  KVIEditableTableView+CellBuilding.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 1/14/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import "UITableViewCell+KVIColumns.h"
#import "UIView+KVIColumns.h"

@implementation UITableViewCell (KVIColumns)

+ (UITableViewCell *)kvi_columnsCellWithViews:(NSArray<UIView *> *)views widths:(NSArray<NSNumber*> *)widths {
    UITableViewCell *cell = [UITableViewCell new];
    
    [cell kvi_buildColumnsWithViews:views widths:widths];
    
    return cell;
}

- (void)kvi_buildColumnsWithViews:(NSArray<UIView *> *)views widths:(NSArray<NSNumber*> *)widths {
    [self.contentView kvi_startColumnsAdding];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isLast = (obj == views.lastObject);
        
        NSNumber *width = widths[idx];
        
        [self.contentView kvi_addNewColumn:obj withWidth:width isLast:isLast];
    }];
}

@end
