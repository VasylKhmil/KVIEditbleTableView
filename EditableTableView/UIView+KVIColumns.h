//
//  UIView+KVIColumns.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 12/10/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KVIColumns)

- (void)kvi_startColumnsAdding;

- (void)kvi_addNewColumn:(UIView *)newColumn withWidth:(NSNumber *)width isLast:(BOOL)isLast;

@end
