//
//  ColumnsCell.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KVIColumnsCell;

#pragma mark - KVIColumnsCellDataSource

@protocol KVIColumnsCellDataSource <NSObject>

- (NSUInteger)numberOfColumnsInCell:(KVIColumnsCell *)cell;

- (UIView *)columntsCell:(KVIColumnsCell *)cell viewForColumnAtIndex:(NSUInteger)index;

- (CGFloat)columnsCell:(KVIColumnsCell *)cell widthForColumnAtIndex:(NSUInteger)index;

@end

#pragma mark - KVIColumnsCell

@interface KVIColumnsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<KVIColumnsCellDataSource> dataSource;


@property (nonatomic, readonly) NSUInteger numberOfColumns;

- (void)reload;

@end
