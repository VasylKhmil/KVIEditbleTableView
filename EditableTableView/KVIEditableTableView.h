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

@optional
- (NSString *)tableView:(KVIEditableTableView *)tableView headerForColumnAtIndex:(NSUInteger)columnIndex;

- (CGFloat)headerHeightForTableView:(KVIEditableTableView *)tableView;

@end


@protocol KVIEditableTableViewDelegate <UITableViewDelegate>

@optional
- (NSString *)tableView:(KVIEditableTableView *)tableView editTitleForColumnAtIndex:(NSUInteger)columnIndex;

- (BOOL)tableViewCanResizeColumns:(KVIEditableTableView *)tableView;

- (void)tableView:(KVIEditableTableView *)tableView resizedColumngAtIndex:(NSUInteger)collumnIndex toSize:(CGFloat)newSize;

- (BOOL)tableViewCanSwapColumns:(KVIEditableTableView *)tableView;

- (void)tableView:(KVIEditableTableView *)tableView swapedColumnAtIndex:(NSUInteger)firstColumnIndex withColumnAtIndex:(NSUInteger)secondColumnIndex;

- (BOOL)tableView:(KVIEditableTableView *)tableView canRemoveColumnAtIndex:(NSUInteger)columnIndex;

- (void)tableView:(KVIEditableTableView *)tableView removedColumnAtIndex:(NSUInteger)columnIndex;

- (BOOL)tableViewCanAddNewColumns:(KVIEditableTableView *)tableView;

- (void)tableView:(KVIEditableTableView *)tableView addedColumnWithWidht:(CGFloat)width;

- (BOOL)tableViewShouldShowHeaders:(KVIEditableTableView *)tableView;

@end


extern CGFloat KVIColumnsDynamicWidth;


@interface KVIEditableTableView : UITableView

@property (nonatomic, weak) IBOutlet id<KVIEditableTableViewDataSource> editableDataSource;

@property (nonatomic, weak) IBOutlet id<KVIEditableTableViewDelegate> editableDelegate;

@property (nonatomic, readonly) NSArray *columnWidths;

@property (nonatomic, readonly) BOOL columnsIsEditing;

- (void)startColumnsEditing;

- (void)endColumnsEditing;

- (void)addColumnWithWidth:(CGFloat)width;

@end
