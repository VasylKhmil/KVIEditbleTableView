//
//  ViewController.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "ViewController.h"
#import "KVIEditableTableView.h"

@interface ViewController () <KVIEditableTableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet KVIEditableTableView *editableTableView;

@end

@implementation ViewController

#pragma mark - Actions

- (IBAction)switchButtonPressed {
    [self.editableTableView startColumnsEditing];
}

#pragma mark - KVIEditableTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfColumnsInTableView:(KVIEditableTableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(KVIEditableTableView *)tableView widthForColumnAtIndex:(NSUInteger)columnIndex {
    if (columnIndex != 0) {
        return 150;
        
    } else {
        return KVIColumnsDynamicWidth;
    }
}

- (UIView *)tableView:(KVIEditableTableView *)tableView columnViewForRowAtIndexPath:(NSIndexPath *)indexPath atColumnIndex:(NSUInteger)columnIndex {
    UILabel *label = [UILabel new];
    
    label.text = @"test";
    
    return label;
}

@end
