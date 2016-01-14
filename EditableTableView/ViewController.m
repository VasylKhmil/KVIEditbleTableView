//
//  ViewController.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "ViewController.h"
#import "KVIEditableTableView.h"

@interface ViewController () <KVIEditableTableViewDataSource, KVIEditableTableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet KVIEditableTableView *editableTableView;

@property (nonatomic, strong) NSMutableArray *widths;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widths = [NSMutableArray arrayWithArray:@[@(KVIColumnsDynamicWidth), @(80), @(70), @(90)]];
}

#pragma mark - Actions

- (IBAction)switchButtonPressed {
    
    if (self.editableTableView.columnsIsEditing) {
        [self.editableTableView endColumnsEditing];
    } else {
        [self.editableTableView startColumnsEditing];
    }
}

#pragma mark - KVIEditableTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfColumnsInTableView:(KVIEditableTableView *)tableView {
    return self.widths.count;
}

- (CGFloat)tableView:(KVIEditableTableView *)tableView widthForColumnAtIndex:(NSUInteger)columnIndex {
    return ((NSNumber *)self.widths[columnIndex]).floatValue;
}

- (UIView *)tableView:(KVIEditableTableView *)tableView columnViewForRowAtIndexPath:(NSIndexPath *)indexPath atColumnIndex:(NSUInteger)columnIndex {
    UILabel *label = [UILabel new];
    
    label.text = [NSString stringWithFormat:@"c:%li r:%li", columnIndex, indexPath.row];
    
    return label;
}

- (NSString *)tableView:(KVIEditableTableView *)tableView headerForColumnAtIndex:(NSUInteger)columnIndex {
    return @"Header";
}

#pragma mark - KVIEditableTableViewDelegate

- (void)tableView:(KVIEditableTableView *)tableView swapedColumnAtIndex:(NSUInteger)firstColumnIndex withColumnAtIndex:(NSUInteger)secondColumnIndex {
    
    
    NSNumber *temp = self.widths[firstColumnIndex];
    self.widths[firstColumnIndex] = self.widths[secondColumnIndex];
    self.widths[secondColumnIndex] = temp;

}

- (void)tableView:(KVIEditableTableView *)tableView resizedColumngAtIndex:(NSUInteger)collumnIndex toSize:(CGFloat)newSize {
    NSNumber *width = self.widths[collumnIndex];
    
    if (width.floatValue != KVIColumnsDynamicWidth) {
        self.widths[collumnIndex] = @(newSize);
    }
}

- (void)tableView:(KVIEditableTableView *)tableView removedColumnAtIndex:(NSUInteger)columnIndex {
    [self.widths removeObjectAtIndex:columnIndex];
}

- (void)tableView:(KVIEditableTableView *)tableView addedColumnWithWidht:(CGFloat)width {
    [self.widths addObject:@(width)];
}

- (BOOL)tableViewShouldShowHeaders:(KVIEditableTableView *)tableView {
    return TRUE;
}

- (UITableViewCell *)tableView:(KVIEditableTableView *)tableView containerCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
}

@end
