//
//  KVIEditableTableView.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/25/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTableView.h"
#import "KVIColumnsCell.h"
#import <objc/runtime.h>
#import "UIView+KVIColumns.h"

@interface KVIEditableTableView () <UITableViewDataSource, UITableViewDelegate, KVIColumnsCellDataSource>

@property (nonatomic, strong) NSArray *columnWidths;

@property (nonatomic) BOOL showHeaders;

@property (nonatomic) CGFloat headerHeight;

@property (nonatomic, strong) NSArray *headers;

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
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - Override

- (void)reloadData {
    [self readData];
    
    [self updateHeader];
    
    [super reloadData];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL selfRespond = [super respondsToSelector:aSelector];
    if (!selfRespond) {
        
        id<NSObject> responder = [self responderForSelector:aSelector];
        
        return [responder respondsToSelector:aSelector];
        
    } else {
        return TRUE;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id<NSObject> responder = [self responderForSelector:anInvocation.selector];
    
    if (responder != nil) {
        [anInvocation invokeWithTarget:responder];
        
    } else {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark - Private

- (UIView *)headerViewWithHeader:(NSString *)header {
    UILabel *label = [UILabel new];
    
    label.font = [UIFont boldSystemFontOfSize:17];
    
    label.text = header;
    
    return label;
}

- (void)updateHeader {
    if (self.showHeaders) {
        UIView *headerView = [UIView new];
        
        [headerView kvi_startColumnsAdding];
        
        [self.headers enumerateObjectsUsingBlock:^(UIView*  _Nonnull header, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isLast = (header == self.headers.lastObject);
            
            NSNumber *width = self.columnWidths[idx];
            if (width.floatValue == KVIColumnsDynamicWidth) {
                width = nil;
            }
            
            [headerView kvi_addNewColumn:header withWidth:width isLast:isLast];
        }];
        
        headerView.frame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(CGRectGetWidth(self.bounds), self.headerHeight)};
        
        self.tableHeaderView = headerView;
    }
}

- (id<NSObject>)responderForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(tableView:numberOfRowsInSection:)) {
        
    }
    
    struct objc_method_description optionalMethodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, FALSE, TRUE);
    struct objc_method_description requiredMethodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, TRUE, TRUE);
    
    if (optionalMethodDescription.name != NULL ||
        requiredMethodDescription.name != NULL) {
        
        return self.editableDataSource;
        
    } else {
        
        struct objc_method_description optionalMethodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, FALSE, TRUE);
        struct objc_method_description requiredMethodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, TRUE, TRUE);
        
        if (optionalMethodDescription.name != NULL ||
            requiredMethodDescription.name != NULL) {
            
            return self.editableDelegate;
            
        }
    }
    
    return nil;
}

- (void)readData {
    NSUInteger numberOfColumns = [self.editableDataSource numberOfColumnsInTableView:self];
    
    if ([self.editableDelegate respondsToSelector:@selector(tableViewShouldShowHeaders:)]) {
        self.showHeaders = [self.editableDelegate tableViewShouldShowHeaders:self];
        
    } else {
        self.showHeaders = FALSE;
    }
    
    if (self.showHeaders) {
        if ([self.editableDataSource respondsToSelector:@selector(headerHeightForTableView:)]) {
        
            self.headerHeight = [self.editableDataSource headerHeightForTableView:self];
        } else {
            self.headerHeight  = 40;
        }
    }
    
    NSMutableArray *headers = [NSMutableArray new];
    
    NSMutableArray *widths = [NSMutableArray new];
    
    for (int i = 0; i < numberOfColumns; ++i) {
        
        CGFloat width = [self.editableDataSource tableView:self widthForColumnAtIndex:i];
        
        [widths addObject:@(width)];
        
        if (self.showHeaders &&
            [self.editableDataSource respondsToSelector:@selector(tableView:headerForColumnAtIndex:)]) {
            NSString *header = [self.editableDataSource tableView:self headerForColumnAtIndex:i];
            
            UIView *headerView = [self headerViewWithHeader:header];
            
            [headers addObject:headerView];
        }
    }
    
    self.columnWidths = widths;
    self.headers = headers;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* const ColumnsCellReuseIdentifier = @"ColumnsCellReuseIdentifier";
    
    KVIColumnsCell *cell = [tableView dequeueReusableCellWithIdentifier:ColumnsCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[KVIColumnsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:ColumnsCellReuseIdentifier];
        
        cell.dataSource = self;
    }
    
    cell.indexPath = indexPath;
    
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
    
    
    return [self.editableDataSource tableView:self
                  columnViewForRowAtIndexPath:cell.indexPath
                                atColumnIndex:index];
    return nil;
}

@end
