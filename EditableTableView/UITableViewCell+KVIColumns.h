//
//  KVIEditableTableView+CellBuilding.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 1/14/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (KVIColumns)

+ (UITableViewCell *)kvi_columnsCellWithViews:(NSArray<UIView*> *)views widths:(NSArray<NSNumber*> *)widths;

- (void)kvi_buildColumnsWithViews:(NSArray<UIView*> *)views widths:(NSArray<NSNumber*> *)widths;

@end
