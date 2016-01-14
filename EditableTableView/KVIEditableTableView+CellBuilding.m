//
//  KVIEditableTableView+CellBuilding.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 1/14/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTableView+CellBuilding.h"
#import "UITableViewCell+KVIColumns.h"

@implementation KVIEditableTableView (CellBuilding)

- (UITableViewCell *)buildedCellForRowAtIdexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray<UIView*> *columnsItems = [NSMutableArray new];
    
    for (NSInteger index = 0; index < self.columnWidths.count; ++index) {
        UIView *columnItem = [self.editableDataSource tableView:self columnViewForRowAtIndexPath:indexPath atColumnIndex:index];
        
        [columnsItems addObject:columnItem];
    }
    
    UITableViewCell *cell = [self containerCellForIndexPath:indexPath];
    
    [cell kvi_buildColumnsWithViews:columnsItems widths:self.columnWidths];
    
    return cell;
}

#pragma mark - Private

- (UITableViewCell *)containerCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if ([self.editableDelegate respondsToSelector:@selector(tableView:containerCellForRowAtIndexPath:)]) {
        cell = [self.editableDelegate tableView:self containerCellForRowAtIndexPath:indexPath];
    
    } else {
        cell = [UITableViewCell new];
    }
    
    return cell;
}


@end
