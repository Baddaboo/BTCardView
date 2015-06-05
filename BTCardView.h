//
//  BTCardView.h
//
//  Created by Blake Tsuzaki on 6/4/15.
//  Copyright (c) 2015 Modoki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BTMaximizableView.h"

IB_DESIGNABLE

@class BTCardView;

@protocol BTCardViewDelegate <NSObject>
@required
- (NSInteger)numberOfItemsInCardView:(BTCardView *)cardView;
- (NSInteger)spacingForCardView:(BTCardView *)cardView;
- (UIView *)cardView:(BTCardView *)cardView viewForItemAtIndex:(NSInteger)index;
@optional
- (UIButton *)cardView:(BTCardView *)cardView buttonForItemAtIndex:(NSInteger)index;
- (CGSize)sizeForItemsInCardView:(BTCardView *)cardView;
- (void)cardView:(BTCardView *)cardView selectedAtIndex:(NSInteger)index;
@end

@interface BTCardView : UIView
@property (weak, nonatomic) id<BTCardViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic) NSInteger cardSpacing;
@property (nonatomic) IBInspectable CGFloat animationDuration;
@property (nonatomic) IBInspectable CGFloat animationSpring;
- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
- (void)sendItemToFrontWithIndex:(NSInteger)index;
- (void)addItemToFront:(UIView *)card;
- (void)addItemToRear:(UIView *)card;
- (void)addItem:(UIView *)card toIndex:(NSInteger)index;
- (void)removeItemWithIndex:(NSInteger)index;
- (void)reloadData;
- (UIView *)viewForItemAtIndex:(NSInteger)index;
@end