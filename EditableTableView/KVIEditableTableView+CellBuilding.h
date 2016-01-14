//
//  KVIEditableTableView+CellBuilding.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 1/14/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTableView.h"

@interface KVIEditableTableView (CellBuilding)

- (UITableViewCell *)buildedCellForRowAtIdexPath:(NSIndexPath *)indexPath;

@end
