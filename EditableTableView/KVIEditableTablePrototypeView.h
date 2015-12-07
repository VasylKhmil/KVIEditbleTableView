//
//  KVIEditableGroupView.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVIEditableColumnPrototypeView;
@class KVIEditableTablePrototypeView;

@protocol KVIEditableTablePrototypeViewDelegate <NSObject>

- (BOOL)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype canResizeColumnAtIndex:(NSUInteger)columnIndex;

- (void)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype resizedColumnAtIndex:(NSUInteger)columnIndex toSize:(CGFloat)newSize;

@end

@interface KVIEditableTablePrototypeView : UIView

@property (nonatomic, weak) id<KVIEditableTablePrototypeViewDelegate> delegate;

- (nonnull instancetype)initWithInitialWidths:(nonnull NSArray<NSNumber*>*)widths;

@end
