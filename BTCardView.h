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
/* These delegate functions are implemented similarly to the delegate functions of
 * typical table/collection views
 */
- (NSInteger)numberOfItemsInCardView:(BTCardView *)cardView;
- (UIView *)cardView:(BTCardView *)cardView viewForItemAtIndex:(NSInteger)index;
/* Card Spacing Delegate: his will change if you add or remove cards, so it's only used
 * upon the first view generation
 */
- (NSInteger)spacingForCardView:(BTCardView *)cardView;
@optional
/* Button target set: Not necessary, as the program can still manipulate the stack
 * without explicit UIButton triggers or with your own functions
 */
- (UIButton *)cardView:(BTCardView *)cardView buttonForItemAtIndex:(NSInteger)index;
/* Size for Card: Also not necessary, but highly recommended for getting the desired look
 * and format */
- (CGSize)sizeForItemsInCardView:(BTCardView *)cardView;
/* Simple trigger function if you'd like to know what gets selected */
- (void)cardView:(BTCardView *)cardView selectedAtIndex:(NSInteger)index;
@end

@interface BTCardView : UIView
@property (weak, nonatomic) id<BTCardViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic) NSInteger cardSpacing;

/* Animation Duration and Spring: These are set to default values of 0.4 and 0.8,
 * accordingly
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;
@property (nonatomic) IBInspectable CGFloat animationSpring;
/* Initialize functions */
- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
/* General manipulation functions: NOTE: Only one function can run at a time due to
 * the animation blocks, so I try to prevent more than one from happening, but bad things
 * happen if you don't keep this in mind!
 */
- (void)sendItemToFrontWithIndex:(NSInteger)index;
- (void)addItemToFront:(UIView *)card;
- (void)addItemToRear:(UIView *)card;
- (void)addItem:(UIView *)card toIndex:(NSInteger)index;
- (void)removeItemWithIndex:(NSInteger)index;
/* Reload Data: Use sparingly. This is a heavy command that will call all the delegate
 * functions */
- (void)reloadData;
/* Simple get function */
- (UIView *)viewForItemAtIndex:(NSInteger)index;
@end