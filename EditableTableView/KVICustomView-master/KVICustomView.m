//
//  KVICustomView.m
//  Booya Fitness
//
//  Created by Vasyl Khmil on 9/3/15.
//  Copyright (c) 2015 MEV. All rights reserved.
//

#import "KVICustomView.h"

@interface KVICustomView ()

@property (nonatomic, readonly) NSString *nibName;

@end

@implementation KVICustomView

#pragma mark - Intializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self loadViewFromNib];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        [self loadViewFromNib];
    }
    
    return self;
}

#pragma mark - Properties

- (NSString *)nibName {
    return nibFileName == nil ? NSStringFromClass([self class]) : nibFileName;
}

#pragma mark - Private

- (void)loadViewFromNib {
    UIView *view = (UIView *)[[NSBundle mainBundle] loadNibNamed:self.nibName owner:self options:nil].firstObject;
    
    [self addSubview:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *bindings = @{@"view" : view};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:bindings]];
    
    view.backgroundColor = [UIColor clearColor];
}

@end
