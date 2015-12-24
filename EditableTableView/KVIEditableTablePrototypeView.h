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

- (BOOL)tablePrototypeViewCanResizeColumns:(nonnull KVIEditableTablePrototypeView *)tablePrototype;

- (void)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype resizedColumnAtIndex:(NSUInteger)columnIndex toSize:(CGFloat)newSize;

- (BOOL)tablePrototypeViewCanSwapColumns:(nonnull KVIEditableTablePrototypeView *)tablePrototype;

- (void)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype swapedColumnAtIndex:(NSUInteger)firstColumnIndex withColumnAtIndex:(NSUInteger)secondColumnIndex;

- (BOOL)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype canRemoveColumnAtIndex:(NSUInteger)columnIndex;

- (void)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype removedColumnAtIndex:(NSUInteger)columnIndex;

- (BOOL)tablePrototypeViewCanAddNewColumns:(nonnull KVIEditableTablePrototypeView *)tablePrototype;

- (void)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype addedColumnWithWidht:(CGFloat)width;

- (nonnull NSString *)tablePrototypeView:(nonnull KVIEditableTablePrototypeView *)tablePrototype headerForColumnAtIndex:(NSUInteger)columnIndex;

@end

@interface KVIEditableTablePrototypeView : UIView

@property (nonatomic, weak) id<KVIEditableTablePrototypeViewDelegate> delegate;

- (nonnull instancetype)initWithInitialWidths:(nonnull NSArray<NSNumber*>*)widths;

- (void)reloadWithWidths:(NSArray<NSNumber*>*)widths;

@end
