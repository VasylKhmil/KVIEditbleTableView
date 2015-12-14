//
//  KVIEditableColumnView.h
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVICustomView-master/KVICustomView.h"


@class KVIEditableColumnPrototypeView;

@interface KVIEditableColumnPrototypeView : KVICustomView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong, nullable) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong, nonnull) NSLayoutConstraint *leadingConstraint;

@property (nonatomic, strong, nonnull) NSLayoutConstraint *trailingConstraint;

@property (nonatomic) BOOL selected;

@end
