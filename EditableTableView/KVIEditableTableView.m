//
//  KVIEditableTableView.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTableView.h"
#import "KVIColumnsCell.h"

@interface KVIEditableTableView () <UITableViewDataSource, UITableViewDelegate, KVIColumnsCellDataSource>

@property (nonatomic, weak) id<UITableViewDataSource> realDataSorce;
@property (nonatomic, weak) id<UITableViewDelegate> realDelegate;

@property (nonatomic, strong) NSArray *columnWidths;

@end


#pragma mark - Constants

CGFloat KVIColumnsDynamicWidth = -1;


@implementation KVIEditableTableView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self makeCustomInitialization];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        [self makeCustomInitialization];
    }
    
    return self;
}

- (void)makeCustomInitialization {
    super.delegate = self;
    super.dataSource = self;
}

#pragma mark - Override

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.realDelegate = delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.realDataSorce = dataSource;
}

- (id<UITableViewDelegate>)delegate {
    return self.realDelegate;
}

- (id<UITableViewDataSource>)dataSource {
    return self.realDataSorce;
}

- (void)reloadData {
    [self readData];
    
    [super reloadData];
}

#pragma mark - Private

- (void)readData {
    NSUInteger numberOfColumns = [self.dataSource numberOfColumnsInTableView:self];
    
    NSMutableArray *widths = [NSMutableArray new];
    
    for (int i = 0; i < numberOfColumns; ++i) {
        
        CGFloat width = [self.dataSource tableView:self widthForColumnAtIndex:i];
        
        [widths addObject:@(width)];
    }
    
    self.columnWidths = widths;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.realDataSorce tableView:self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* const ColumnsCellReuseIdentifier = @"ColumnsCellReuseIdentifier";
    
    KVIColumnsCell *cell = [tableView dequeueReusableCellWithIdentifier:ColumnsCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[KVIColumnsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:ColumnsCellReuseIdentifier];
        
        cell.dataSource = self;
    }
    
    [cell reload];
    
    return cell;
}

#pragma mark - UITableViewDelegte

- (void)tableView:(UITableView *)tableView willDisplayCell:(KVIColumnsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell reload];
}

#pragma mark - KVIColumnsCellDataSource

- (NSUInteger)numberOfColumnsInCell:(KVIColumnsCell *)cell {
    return self.columnWidths.count;
}

- (CGFloat)columnsCell:(KVIColumnsCell *)cell widthForColumnAtIndex:(NSUInteger)index {
    return ((NSNumber *)self.columnWidths[index]).floatValue;
}

- (UIView *)columntsCell:(KVIColumnsCell *)cell viewForColumnAtIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    return [self.dataSource tableView:self
          columnViewForRowAtIndexPath:indexPath
                        atColumnIndex:index];
}

@end
