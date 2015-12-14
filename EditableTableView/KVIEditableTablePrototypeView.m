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


typedef NS_ENUM(NSInteger, KVIPanMode) {
    KVIPanModeResize,
    KVIPanModeReplace,
    KVIPanModeNone
};


@interface KVIEditableTablePrototypeView ()

@property (nonatomic, strong) NSArray *widths;

@property (nonatomic, strong) NSMutableArray<KVIEditableColumnPrototypeView *> *prototypes;

@property (nonatomic, strong) NSLayoutConstraint *lastPrototypeTrailingConstraint;

@property (nonatomic, strong) KVIEditableColumnPrototypeView *resizingLeftView;
@property (nonatomic, strong) KVIEditableColumnPrototypeView *resizingRightView;

@property (nonatomic) KVIPanMode panMode;

@end




static const CGFloat KVIMinimumColumnWidth = 10;



@implementation KVIEditableTablePrototypeView

#pragma mark - Initialization

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
    
    [self.prototypes removeAllObjects];
    
    for (NSNumber *width in self.widths) {
        
        [self addNewPrototypeColumnWithWidth:width.floatValue];
        
    }
    
}

- (void)addNewPrototypeColumnWithWidth:(CGFloat)width {
    
    KVIEditableColumnPrototypeView *columnPrototype = [KVIEditableColumnPrototypeView new];
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:headerForColumnAtIndex:)]) {
        columnPrototype.titleLabel.text = [self.delegate tablePrototypeView:self headerForColumnAtIndex:self.prototypes.count];
        
    } else {
        columnPrototype.titleLabel.text = [NSString stringWithFormat:@"COLUMN %li", self.prototypes.count];
    }
    
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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureUsed:)];
    
    [columnPrototype addGestureRecognizer:panGesture];
    
}

#pragma mark - Actions

- (void)panGestureUsed:(UIPanGestureRecognizer *)gesture {
    KVIEditableColumnPrototypeView *columnPrototype = (KVIEditableColumnPrototypeView*)gesture.view;
    
    NSInteger columnPtototypeIndex = [self.prototypes indexOfObject:columnPrototype];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [gesture locationInView:columnPrototype];
        
        CGFloat resizeDelta = MIN(10, 0.2 * columnPrototype.frame.size.width);
        
        if (touchLocation.x < resizeDelta   &&
            columnPtototypeIndex > 0        &&
            [self canResizeColumns]) {
            
            self.resizingLeftView = self.prototypes[columnPtototypeIndex - 1];
            self.resizingRightView = self.prototypes[columnPtototypeIndex];
            
            self.panMode = KVIPanModeResize;
            
        } else if (touchLocation.x > columnPrototype.frame.size.width - resizeDelta &&
                   columnPtototypeIndex < self.prototypes.count - 1                 &&
                   [self canResizeColumns]) {
            
            self.resizingLeftView = self.prototypes[columnPtototypeIndex];
            self.resizingRightView = self.prototypes[columnPtototypeIndex + 1];
            
            self.panMode = KVIPanModeResize;
            
        } else if ([self canSwapColumns]) {
            
            columnPrototype.selected = TRUE;
            [self bringSubviewToFront:columnPrototype];
            
            self.panMode = KVIPanModeReplace;
            
        } else {
            self.panMode = KVIPanModeNone;
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:columnPrototype];
        
        CGPoint velocity = [gesture velocityInView:columnPrototype];
        
        if (self.panMode == KVIPanModeReplace) {
            
            if (fabs(velocity.x) > fabs(velocity.y)) {
                
                translation.x = MAX(-columnPrototype.frame.origin.x, translation.x);
                
                translation.x = MIN(translation.x, self.bounds.size.width - CGRectGetMaxX(columnPrototype.frame));
                
                columnPrototype.transform = CGAffineTransformTranslate(columnPrototype.transform, translation.x, 0);
                
            } else if ([self columnPrototypeCanBeDeleted:columnPrototype]) {
                
                translation.y = MIN(translation.y, self.bounds.size.height - CGRectGetMaxY(columnPrototype.frame));
                
                columnPrototype.transform = CGAffineTransformTranslate(columnPrototype.transform, 0, translation.y);
            }
            
            [self updatePrototypesAfterMovingWithMovingPrototype:columnPrototype velocity:velocity];
            
            
        } else if (self.panMode == KVIPanModeResize) {
            NSLog(@"%f", translation.x);
            if (fabs(velocity.x) < fabs(velocity.y)) {
                self.resizingLeftView.widthConstraint.constant = self.resizingLeftView.widthConstraint.constant - translation.x;
                self.resizingRightView.widthConstraint.constant = self.resizingRightView.widthConstraint.constant + translation.x;
                
            
            } else {
                self.resizingRightView.widthConstraint.constant = self.resizingRightView.widthConstraint.constant - translation.x;
                self.resizingLeftView.widthConstraint.constant = self.resizingLeftView.widthConstraint.constant + translation.x;
            }
            
            if ([self.delegate respondsToSelector:@selector(tablePrototypeView:resizedColumnAtIndex:toSize:)]) {
                
                NSUInteger leftColumnIndex = [self.prototypes indexOfObject:self.resizingLeftView];
                NSUInteger rightColumnIndex = [self.prototypes indexOfObject:self.resizingRightView];
                
                [self.delegate tablePrototypeView:self resizedColumnAtIndex:leftColumnIndex toSize:self.resizingLeftView.widthConstraint.constant];
                [self.delegate tablePrototypeView:self resizedColumnAtIndex:rightColumnIndex toSize:self.resizingRightView.widthConstraint.constant];
            }
            
            [self layoutIfNeeded];
        }
        
        [gesture setTranslation:CGPointZero inView:columnPrototype];
        
    } else {
        
        if ([self columnPrototypeShouldBeDeleted:columnPrototype]) {
            
            [self deleteColumnPrototypeAtIndex:[self.prototypes indexOfObject:columnPrototype]];
            
        } else {
        
            columnPrototype.transform = CGAffineTransformIdentity;
        }
        
        columnPrototype.selected = FALSE;
        self.panMode = KVIPanModeNone;
        
    }
}

#pragma mark - Private
#pragma mark - Private(Delegation)

- (BOOL)canResizeColumns {
    BOOL canResize = FALSE;
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeViewCanResizeColumns:)]) {
        
        canResize = [self.delegate tablePrototypeViewCanResizeColumns:self];
    }
    
    return canResize;
}

- (BOOL)canSwapColumns {
    BOOL canSwap = FALSE;
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeViewCanSwapColumns:)]) {
        
        canSwap = [self.delegate tablePrototypeViewCanSwapColumns:self];
    }
    
    return canSwap;
}

#pragma mark - Private(Event)

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
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:swapedColumnAtIndex:withColumnAtIndex:)]) {
        
        [self.delegate tablePrototypeView:self swapedColumnAtIndex:firstColumnIndex withColumnAtIndex:firstColumnIndex + 1];
    }
    
    [self layoutIfNeeded];
}

- (BOOL)canResizeColumn:(KVIEditableColumnPrototypeView *)columnPrototype withScale:(CGFloat)scale {
    BOOL canResizeColumn = TRUE;
    
    NSUInteger columnIndex = [self.prototypes indexOfObject:columnPrototype];
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:canResizeColumnAtIndex:)]) {
        canResizeColumn = [self.delegate tablePrototypeViewCanResizeColumns:self];
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
    BOOL shouldBeDeleted = FALSE;
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:canRemoveColumnAtIndex:)]) {
        
        NSUInteger columnIndex = [self.prototypes indexOfObject:columnPrototype];
        
        shouldBeDeleted = [self.delegate tablePrototypeView:self canRemoveColumnAtIndex:columnIndex];
    }
    
    shouldBeDeleted = shouldBeDeleted && (CGRectGetMidY(columnPrototype.frame) <= 0) && ([self columnPrototypeCanBeDeleted:columnPrototype]);
    
    return shouldBeDeleted;
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
    
    if ([self.delegate respondsToSelector:@selector(tablePrototypeView:removedColumnAtIndex:)]) {
        [self.delegate tablePrototypeView:self removedColumnAtIndex:columnPrototypeIndex];
    }
    
}

@end
