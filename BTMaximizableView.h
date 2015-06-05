//
//  BTMaximizableView.h
//
//  Created by Blake Tsuzaki on 5/31/15.
//  Copyright (c) 2015 Baddaboo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface BTMaximizableView : UIView
/* Variables added purely for the BTCardView example */
@property (strong, nonatomic) IBOutlet UIButton *button;


/* IB Inspectables: Can be set either in Interface Builder or programatically
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat springCoef;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) BOOL isMaximized;

/* Fill View Outlet: Can be set in Interface Builder or programatically, but
 * not needed as the default behavior will traverse down to the root view
 */
@property (nonatomic) IBOutlet UIView *fillView;

- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithAnimationDuration:(CGFloat)duration
                   cornerRadius:(CGFloat)cornerRadius
                  shadowOpacity:(CGFloat)shadowOpacity
                   shadowRadius:(CGFloat)shadowRadius
                     springCoef:(CGFloat)springCoef
                   shadowOffset:(CGSize)shadowOffset
                       fillView:(UIView *)fillView;

/* Set Methods: Added purely so that Interface Builder will render each
 * variable change
 */
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setShadowOpacity:(CGFloat)shadowOpacity;
- (void)setShadowOffset:(CGSize)shadowOffset;
- (void)setShadowRadius:(CGFloat)shadowRadius;

/* Toggle Function: If using Interface Builder, only function you'll really
 * need
 */
- (IBAction)toggleMaxMin;
@end