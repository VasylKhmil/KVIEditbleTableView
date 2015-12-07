//
//  KVIEditableGroupView.m
//  EditableTableView
//
//  Created by Vasyl Khmil on 11/30/15.
//  Copyright © 2015 Vasyl Khmil. All rights reserved.
//

#import "KVIEditableTablePrototypeView.h"
#import "KVIEditableColumnPrototypeView.h"
#import "KVIEditableTableView.h"



@interface KVIEditableTablePrototypeView ()

@property (nonatomic, strong) NSArray *widths;

@property (nonatomic, strong) NSMutableArray<KVIEditableColumnPrototypeView *> *prototypes;

@property (nonatomic, strong) NSLayoutConstraint *lastPrototypeTrailingConstraint;

@end




static const CGFloat KVIMinimumColumnWidth = 10;



@implementation KVIEditableTablePrototypeView

#pragma mark - initialization

- (instancetype)initWithInitialWidths:(NSArray<NSNumber *> *)widths {
    
    self = [super init];
    
    if (self != nil) {
        
        _widths = widths;
        
        _prototypes = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Override

- (void)willMoveToWindow:(UIWindow *)newWindow {
    
    [super willMoveToWindow:newWindow];
    
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSNumber *width in self.widths) {
        
        [self addNewPrototypeColumnWithWidth:width.floatValue];
        
    }
    
}

- (void)addNewPrototypeColumnWithWidth:(CGFloat)width {
    
    KVIEditableColumnPrototypeView *columnPrototype = [KVIEditableColumnPrototypeView new];
    
    [self addSubview:columnPrototype];
    
    [self addColumnConstraintsToPrototype:columnPrototype
                                withWidth:width];
    
    [self addGesturesToColumnPrototype:columnPrototype];
    
    [self.prototypes addObject:columnPrototype];
    
}

- (void)addColumnConstraintsToPrototype:(KVIEditableColumnPrototypeView *)prototypeView
                                 withWidth:(CGFloat) width {
    
    prototypeView.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    [self addVerticalConstraintsToPrototype:prototypeView];
    
    KVIEditableColumnPrototypeView *previousPrototype = self.prototypes.count > 0 ? self.prototypes.lastObject : nil;
    
    [self addHorizontalConstraintsToPrototype:prototypeView
                        withPreviousPrototype:previousPrototype
                                        width:width];
    
    [self updateLastTrailingConstraintWithNewPrototype:prototypeView];
}

- (void)addVerticalConstraintsToPrototype:(KVIEditableColumnPrototypeView *)prototypeView {
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    [self addConstraints:@[heightConstraint, centerYConstraint]];
}

- (void)addHorizontalConstraintsToPrototype:(KVIEditableColumnPrototypeView *)prototypeView
                      withPreviousPrototype:(KVIEditableColumnPrototypeView *)previousPrototypeView
                                      width:(CGFloat)width {
    
    if (width != KVIColumnsDynamicWidth) {
    
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:width];
        
        prototypeView.widthConstraint = widthConstraint;

    }
    
    [self connectByConstraintPrototype:previousPrototypeView withPrototype:prototypeView];
    
}

- (void)connectByConstraintPrototype:(nullable KVIEditableColumnPrototypeView *)firstPrototype
                       withPrototype:(nullable KVIEditableColumnPrototypeView *)secondPrototype {
    
    
    NSLayoutConstraint *constraint;
    if (firstPrototype != nil && secondPrototype != nil) {
        constraint = [NSLayoutConstraint constraintWithItem:secondPrototype
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:firstPrototype
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0.0];
        
    } else if (firstPrototype == nil && secondPrototype != nil) {
        constraint = [NSLayoutConstraint constraintWithItem:secondPrototype
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0];
        
    } else if (secondPrototype == nil && firstPrototype != nil) {
        constraint = [NSLayoutConstraint constraintWithItem:firstPrototype
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeTrailing
                                                 multiplier:1.0
                                                   constant:0.0];
    }
    
    firstPrototype.trailingConstraint = constraint;
    secondPrototype.leadingConstraint = constraint;
    
    [self addConstraint:constraint];
}

- (void)updateLastTrailingConstraintWithNewPrototype:(KVIEditableColumnPrototypeView *)prototypeView {
    
    if (self.lastPrototypeTrailingConstraint != nil) {
        
        [self removeConstraint:self.lastPrototypeTrailingConstraint];
    }
    
    self.lastPrototypeTrailingConstraint = [NSLayoutConstraint constraintWithItem:prototypeView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    prototypeView.trailingConstraint = self.lastPrototypeTrailingConstraint;
    
    [self addConstraint:self.lastPrototypeTrailingConstraint];
}

#pragma mark - Events

- (void)addGesturesToColumnPrototype:(KVIEditableColumnPrototypeView *)columnPrototype {
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureUsed:)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureUsed:)];
    
    //    [columnPrototype addGestureRecognizer:pinchGesture];
    
    [columnPrototype addGestureRecognizer:panGesture];
    
}

#pragma mark - Actions

- (void)panGestureUsed:(UIPanGestureRecognizer *)gesture {
    KVIEditableColumnPrototypeView *columnPrototype = (KVIEditableColumnPrototypeView*)gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        columnPrototype.selected = TRUE;
        [self bringSubviewToFront:columnPrototype];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:columnPrototype];
        
        CGPoint velocity = [gesture velocityInView:columnPrototype];
        
        if (fabs(velocity.x) > fabs(velocity.y)) {
            
            translation.x = MAX(-columnPrototype.frame.origin.x, translation.x);
            
            translation.x = MIN(translation.x, self.bounds.size.width - CGRectGetMaxX(columnPrototype.frame));
        
            columnPrototype.transform = CGAffineTransformTranslate(columnPrototype.transform, translation.x, 0);
        
        } else if ([self columnPrototypeCanBeDeleted:columnPrototype]) {
            
            translation.y = MIN(translation.y, self.bounds.size.height - CGRectGetMaxY(columnPrototype.frame));
            
            columnPrototype.transform = CGAffineTransformTranslate(columnPrototype.transform, 0, translation.y);
        }
        
        [gesture setTranslation:CGPointZero inView:columnPrototype];
        
        [self updatePrototypesAfterMovingWithMovingPrototype:columnPrototype velocity:velocity];
        
    } else {
        
        if ([self columnPrototypeShouldBeDeleted:columnPrototype]) {
            
            [self deleteColumnPrototypeAtIndex:[self.prototypes indexOfObject:columnPrototype]];
            
        } else {
        
            columnPrototype.transform = CGAffineTransformIdentity;
            columnPrototype.selected = FALSE;
        }
        
        
    }
}

#pragma mark - Private

- (void)updatePrototypesAfterMovingWithMovingPrototype:(KVIEditableColumnPrototypeView *)prototypeView velocity:(CGPoint)velocity {
    NSInteger index = [self.prototypes indexOfObject:prototypeView];
    
    if (index != NSNotFound) {
        KVIEditableColumnPrototypeView *previousColumnPrototype = index < 1 ? nil : self.prototypes[index - 1];
        KVIEditableColumnPrototypeView *nextColumnPrototype = (index > self.prototypes.count - 2) ? nil : self.prototypes[index + 1];
        
        KVIEditableColumnPrototypeView *firstViewForSwaping;
        KVIEditableColumnPrototypeView *secondViewForSwaping;
        
        if (CGRectGetMidX(prototypeView.frame) < CGRectGetMaxX(previousColumnPrototype.frame) &&
            previousColumnPrototype != nil &&
            velocity.x <= 0) {
        
            firstViewForSwaping = previousColumnPrototype;
            secondViewForSwaping = prototypeView;
            
            
        } else if (CGRectGetMidX(prototypeView.frame) > CGRectGetMinX(nextColumnPrototype.frame) &&
                   nextColumnPrototype != nil &&
                   velocity.x >= 0) {
            
            firstViewForSwaping = prototypeView;
            secondViewForSwaping = nextColumnPrototype;
            
        }
        
        if (firstViewForSwaping != nil &&
            secondViewForSwaping != nil) {
            
            
            CGFloat x = prototypeView.frame.origin.x;
            CGFloat y = prototypeView.frame.origin.y;
            
            prototypeView.transform = CGAffineTransformIdentity;
            
            [self swapColumnPrototype:firstViewForSwaping
                  withColumnPrototype:secondViewForSwaping];
        
            prototypeView.transform = CGAffineTransformTranslate(prototypeView.transform, x - prototypeView.frame.origin.x, y - prototypeView.frame.origin.y);
            
        }
        
    }
    
}

- (void)swapColumnPrototype:(KVIEditableColumnPrototypeView *)firstColumnPrototype
        withColumnPrototype:(KVIEditableColumnPrototypeView *)secondColumnPrototype {
    
    NSArray *constraintsToRemove = @[firstColumnPrototype.leadingConstraint,
                                     firstColumnPrototype.trailingConstraint,
                                     secondColumnPrototype.trailingConstraint];
    
    [self removeConstraints:constraintsToRemove];
    
    NSMutableArray *mutablePrototypes = (NSMutableArray *)self.prototypes;
    
    NSInteger firstColumnIndex = [self.prototypes indexOfObject:firstColumnPrototype];
    
    mutablePrototypes[firstColumnIndex] = secondColumnPrototype;
    mutablePrototypes[firstColumnIndex + 1] = firstColumnPrototype;
    
    
    KVIEditableColumnPrototypeView *leftPrototypeView = firstColumnIndex < 1 ? nil : self.prototypes[firstColumnIndex - 1];
    
    KVIEditableColumnPrototypeView *rightPrototypeView = firstColumnIndex >= self.prototypes.count - 2    ? nil : self.prototypes[firstColumnIndex + 2];
    
    [self connectByConstraintPrototype:secondColumnPrototype
                         withPrototype:firstColumnPrototype];
    
    [self connectByConstraintPrototype:leftPrototypeView
                         withPrototype:secondColumnPrototype];
    
    if (rightPrototypeView != nil) {
        [self connectByConstraintPrototype:firstColumnPrototype
                             withPrototype:rightPrototypeView];
   
    } else {
        [self updateLastTrailingConstraintWithNewPrototype:firstColumnPrototype];
    }
    
    [self layoutIfNeeded];
}

- (BOOL)canResizeColumn:(KVIEditableColumnPrototypeView *)columnPrototype withScale:(CGFloat)scale {
    BOOL canResizeColumn = TRUE;
    
    NSUInteger columnIndex = [self.prototypes indexOfObject:columnPrototype];
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:canResizeColumnAtIndex:)]) {
        canResizeColumn = [self.delegate tablePrototypeView:self canResizeColumnAtIndex:columnIndex];
    }
    
    if (!canResizeColumn) {
        return FALSE;
    }
    
    if (scale < 1) {
        return columnPrototype.widthConstraint.constant > KVIMinimumColumnWidth;
        
    } else {
        CGFloat columnsFreeWidth = 0;
        
        for (KVIEditableColumnPrototypeView *columnPrototype in self.prototypes) {
            CGFloat width = columnPrototype.widthConstraint.constant;
            columnsFreeWidth += MAX(0, width - KVIMinimumColumnWidth);
        }
        
        CGFloat delta = (scale - 1) * columnPrototype.widthConstraint.constant;
        
        return columnsFreeWidth > delta;
        
    }
    
    return FALSE;
}

- (BOOL)columnPrototypeCanBeDeleted:(KVIEditableColumnPrototypeView *)columnPrototype {
    NSUInteger index = [self.prototypes indexOfObject:columnPrototype];
    
    return ((NSNumber *)self.widths[index]).floatValue != KVIColumnsDynamicWidth;
}

- (BOOL)columnPrototypeShouldBeDeleted:(KVIEditableColumnPrototypeView *)columnPrototype {
    return CGRectGetMidY(columnPrototype.frame) <= 0 && [self columnPrototypeCanBeDeleted:columnPrototype];
}

- (void)deleteColumnPrototypeAtIndex:(NSUInteger)columnPrototypeIndex {
    KVIEditableColumnPrototypeView *columnPrototype = self.prototypes[columnPrototypeIndex];
    
    [columnPrototype removeFromSuperview];
    
    NSMutableArray *mutablePrototypes = (NSMutableArray *)self.prototypes;
    
    [self removeConstraints:@[columnPrototype.leadingConstraint, columnPrototype.trailingConstraint]];
    
    KVIEditableColumnPrototypeView *previousPrototype = columnPrototypeIndex == 0 ? nil : self.prototypes[columnPrototypeIndex - 1];
    KVIEditableColumnPrototypeView *nextPrototype = columnPrototypeIndex == self.prototypes.count - 1 ? nil : self.prototypes[columnPrototypeIndex + 1];
    
    [self connectByConstraintPrototype:previousPrototype
                         withPrototype:nextPrototype];
    
    [mutablePrototypes removeObjectAtIndex:columnPrototypeIndex];
    
}

@end
