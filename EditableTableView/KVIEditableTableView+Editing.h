//
//  KVIEditableTableView+Editing.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVIEditableTableView.h"
#import "KVIEditableTablePrototypeView.h"

@interface KVIEditableTableView (Editing) <KVIEditableTablePrototypeViewDelegate>

- (void)startColumnsEditing;

@end
