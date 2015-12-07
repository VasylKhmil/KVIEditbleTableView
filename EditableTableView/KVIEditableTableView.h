//
//  KVIEditableTableView.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVIEditableTableView;

@protocol KVIEditableTableViewDataSource <UITableViewDataSource>

- (NSInteger)numberOfColumnsInTableView:(KVIEditableTableView *)tableView;

- (CGFloat)tableView:(KVIEditableTableView *)tableView widthForColumnAtIndex:(NSUInteger)columnIndex;

- (UIView *)tableView:(KVIEditableTableView *)tableView columnViewForRowAtIndexPath:(NSIndexPath *)indexPath atColumnIndex:(NSUInteger)columnIndex;

@end


@protocol KVIEditableTableViewDelegate <UITableViewDelegate>

@optional
- (NSString *)tableView:(KVIEditableTableView *)tableView editTitleForColumnAtIndex:(NSUInteger)columnIndex;

- (BOOL)tableView:(KVIEditableTableView *)tableView canResizeColumnAtIndex:(NSUInteger)columnIndex;

- (void)tableView:(KVIEditableTableView *)tableView resizedColumngAtIndex:(NSUInteger)collumnIndex toSize:(CGFloat)newSize;

@end


extern CGFloat KVIColumnsDynamicWidth;


@interface KVIEditableTableView : UITableView

@property (nonatomic, weak) id<KVIEditableTableViewDataSource> IBOutlet dataSource;

@property (nonatomic, weak) id<KVIEditableTableViewDelegate> IBOutlet delegate;

@property (nonatomic, readonly) NSArray *columnWidths;;

- (void)startColumnsEditing;

@end
