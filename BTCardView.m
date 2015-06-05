//
//  BTCardView.m
//
//  Created by Blake Tsuzaki on 6/4/15.
//  Copyright (c) 2015 Modoki. All rights reserved.
//

#import "BTCardView.h"

@interface BTCardView ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) NSInteger baseCardSpacing;
@property (nonatomic) BOOL isAnimating;
- (void)itemTriggeredWith:(UIView *)sender;
- (void)reconfigureCards;
@end

@implementation BTCardView

#pragma mark - Initializers
- (id)init{
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (void)sharedInit{
    self.cards = [[NSMutableArray alloc] init];
    self.animationDuration = self.animationDuration?self.animationDuration:0.4f;
    self.animationSpring = self.animationSpring?self.animationSpring:0.8f;
    if (self.delegate)
        [self reloadData];
}
- (void)reloadData{
    _count = [self.delegate numberOfItemsInCardView:self];
    _cardSpacing = [self.delegate spacingForCardView:self];
    self.baseCardSpacing = self.cardSpacing;
    for (NSInteger i = self.count-1; i > -1; i--){
        UIView *newView = [self.delegate cardView:self viewForItemAtIndex:i];
        NSAssert(newView != nil, @"View at %ld cannot be nil", (long)i);
        CGSize newSize;
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemsInCardView:)])
            newSize = [self.delegate sizeForItemsInCardView:self];
        else
            newSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - (self.count - 1)*self.cardSpacing);
        [newView setFrame:CGRectMake(0, (self.count-1-i)*self.cardSpacing, newSize.width, newSize.height)];
        [self.cards insertObject:newView atIndex:0];
        [self addSubview:newView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:buttonForItemAtIndex:)]){
            UIButton *triggerView = [self.delegate cardView:self buttonForItemAtIndex:i];
            [triggerView addTarget:self action:@selector(itemTriggeredWith:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.isAnimating = NO;
}
- (void)prepareForInterfaceBuilder{
    [self sharedInit];
}
- (UIView *)viewForItemAtIndex:(NSInteger)index{
    NSAssert(index > -1 && index < [self.cards count], @"Index %ld is not within card array [0..%lu]", (long)index, [self.cards count]-1);
    return [self.cards objectAtIndex:index];
}

#pragma mark - Set Variable Functions
- (void)setDelegate:(id<BTCardViewDelegate>)delegate{
    if (self.delegate != delegate){
        _delegate = delegate;
        [self reloadData];
    }
}

#pragma mark - Add/Remove Transitions
- (void)sendItemToFrontWithIndex:(NSInteger)index{
    if (!self.isAnimating){
        self.isAnimating = YES;
        UIView *tempView = [self.cards objectAtIndex:index];
        [tempView setAlpha:0.0f];
        [self.cards removeObjectAtIndex:index];
        [self.cards insertObject:tempView atIndex:0];
        [self reconfigureCards];
    }
}
- (void)itemTriggeredWith:(UIView *)sender{
    UIView *tempView = sender;
    while (tempView.superview != nil && tempView.superview != self)
        tempView = tempView.superview;
    if (tempView != nil){
        NSInteger index = [self.cards indexOfObject:tempView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:selectedAtIndex:)])
            [self.delegate cardView:self selectedAtIndex:index];
        if (index != NSNotFound && index != 0){
            [self sendItemToFrontWithIndex:index];
            return;
        }
    }
}
- (void)addItemToFront:(UIView *)card{
    [self addItem:card toIndex:0];
}
- (void)addItemToRear:(UIView *)card{
    [self addItem:card toIndex:self.count];
}
- (void)addItem:(UIView *)card toIndex:(NSInteger)index{
    if (!self.isAnimating){
        self.isAnimating = YES;
        _cardSpacing = self.cardSpacing * (long)self.count/(self.count+1);
        [self.cards insertObject:card atIndex:index];
        CGSize newSize;
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemsInCardView:)])
            newSize = [self.delegate sizeForItemsInCardView:self];
        else
            newSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - (self.count-1)*self.cardSpacing);
        [card setFrame:CGRectMake(0, (self.count-1-index)*self.cardSpacing, newSize.width, newSize.height)];
        [card setAlpha:0.0];
        [self addSubview:card];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:buttonForItemAtIndex:)]){
            UIButton *triggerView = [self.delegate cardView:self buttonForItemAtIndex:index];
            [triggerView addTarget:self action:@selector(itemTriggeredWith:) forControlEvents:UIControlEventTouchUpInside];
        }
        _count++;
        [self reconfigureCards];
    }
}
- (void)removeItemWithIndex:(NSInteger)index{
    if (!self.isAnimating){
        self.isAnimating = YES;
        _cardSpacing = self.cardSpacing * (long)self.count/(self.count-1);
        if ([self.cards count] < 1){
            NSLog(@"Warning: attempted to call remove function on an empty card stack");
            return;
        }else if ([self.cards count] == 1)
            _cardSpacing = self.baseCardSpacing;
        [UIView animateWithDuration:self.animationDuration animations:^{
            [[self.cards objectAtIndex:index] setAlpha:0.0f];
        }];
        [self.cards removeObjectAtIndex:index];
        _count--;
        [self reconfigureCards];
    }
}
#pragma mark - Drawing Functions
- (void)reconfigureCards{
    [UIView animateWithDuration:self.animationDuration delay:0.0f usingSpringWithDamping:self.animationSpring initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (NSInteger i = 0; i < self.count; i++){
            UIView *tempView = [self.cards objectAtIndex:(self.count-1-i)];
            CGSize newSize;
            if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemsInCardView:)])
                newSize = [self.delegate sizeForItemsInCardView:self];
            else
                newSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - (self.count-1)*self.cardSpacing);
            [tempView setFrame:CGRectMake(0, i*self.cardSpacing, newSize.width, newSize.height)];
            [self bringSubviewToFront:tempView];
            [tempView setAlpha:1.0f];
        }
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}
- (void)setCardSpacing:(NSInteger)cardSpacing{
    _cardSpacing = cardSpacing;
    for (NSInteger i = 0; i < self.count; i++){
        UIView *tempView = [self.cards objectAtIndex:(self.count-1-i)];
        [tempView setFrame:CGRectMake(0, i*self.cardSpacing, tempView.frame.size.width, tempView.frame.size.height)];
    }
}
@end
