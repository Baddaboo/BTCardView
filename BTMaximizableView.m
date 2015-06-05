//
//  BTMaximizableView.m
//
//  Created by Blake Tsuzaki on 5/31/15.
//  Copyright (c) 2015 Baddaboo. All rights reserved.
//

#import "BTMaximizableView.h"
#define STATUS_BAR_HEIGHT 19

@interface BTMaximizableView ()
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *statusBarView;
@property (nonatomic) BOOL statusBarIsDark;
@property (nonatomic) CGPoint pointInFill;
@end

@implementation BTMaximizableView

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
- (id)initWithAnimationDuration:(CGFloat)duration
                   cornerRadius:(CGFloat)cornerRadius
                  shadowOpacity:(CGFloat)shadowOpacity
                   shadowRadius:(CGFloat)shadowRadius
                     springCoef:(CGFloat)springCoef
                   shadowOffset:(CGSize)shadowOffset
                       fillView:(UIView *)fillView{
    self = [super init];
    if (self) {
        self.animationDuration = duration;
        self.cornerRadius = cornerRadius;
        self.shadowOpacity = shadowOpacity;
        self.shadowRadius = shadowRadius;
        self.shadowOffset = shadowOffset;
        self.springCoef = springCoef;
        self.fillView = fillView;
        [self sharedInit];
    }
    return self;
}
- (void)sharedInit{
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    [self.containerView setBackgroundColor:self.backgroundColor];
    
    [self setBackgroundColor:[UIColor clearColor]];
    while ([self.subviews count] > 1)
        [self.containerView addSubview:[self.subviews objectAtIndex:0]];
    
    self.animationDuration = self.animationDuration?self.animationDuration:0.4;
    self.cornerRadius = self.cornerRadius?self.cornerRadius:8.0f;
    self.shadowOpacity = self.shadowOpacity?self.shadowOpacity:0.5f;
    self.shadowRadius = self.shadowRadius?self.shadowRadius:2.0f;
    self.springCoef = self.springCoef?self.springCoef:0.8f;
    self.shadowOffset = CGSizeEqualToSize(CGSizeZero, self.shadowOffset)?CGSizeMake(0, 1):self.shadowOffset;
    self.isMaximized = NO;
    
    [self.containerView.layer setMasksToBounds:YES];
    [self.containerView.layer setBorderWidth:0.0f];
    [self.containerView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.containerView.layer setCornerRadius:self.cornerRadius];
    
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowOffset:self.shadowOffset];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowRadius:self.shadowRadius];
    [self.layer setShadowOpacity:self.shadowOpacity];
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.containerView.layer.bounds cornerRadius:self.cornerRadius] CGPath]];
}

- (void)prepareForInterfaceBuilder{
    [self sharedInit];
}

#pragma mark - Variable Set Functions
- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self.layer setCornerRadius:self.cornerRadius];
}
- (void)setShadowOpacity:(CGFloat)shadowOpacity{
    _shadowOpacity = shadowOpacity;
    [self.layer setShadowOpacity:self.shadowOpacity];
}
- (void)setShadowRadius:(CGFloat)shadowRadius{
    _shadowRadius = shadowRadius;
    [self.layer setShadowRadius:self.shadowRadius];
}
- (void)setShadowOffset:(CGSize)shadowOffset{
    _shadowOffset = shadowOffset;
    [self.layer setShadowOffset:shadowOffset];
}

#pragma mark - Transitions
- (void)maximize{
    self.fillView = self.fillView?self.fillView:[self getSuper];
    [self.layer setShadowOpacity:0.0f];
    self.pointInFill = [self calculatePointInView:self.fillView];
    [self.fillView addSubview:self.containerView];
    [self.containerView setFrame:CGRectMake(self.pointInFill.x, self.pointInFill.y, self.frame.size.width, self.frame.size.height)];
    if (!self.statusBarView){
        self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fillView.frame.size.width, STATUS_BAR_HEIGHT + 1)];
    }
    [self.statusBarView setBackgroundColor:self.containerView.backgroundColor];
    const CGFloat *componentColors = CGColorGetComponents([self.statusBarView backgroundColor].CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    self.statusBarIsDark = [[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleDefault;
    if (colorBrightness < 0.5)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.statusBarView setAlpha:0.0f];
    
    [self.fillView addSubview:self.statusBarView];
    
    [UIView animateWithDuration:self.animationDuration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.containerView.layer setCornerRadius:0.0f];
        [self.containerView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT, self.fillView.frame.size.width, self.fillView.frame.size.height-STATUS_BAR_HEIGHT)];
        [self.statusBarView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        self.isMaximized = YES;
    }];
}
- (void)minimize{
    [self.containerView.layer setCornerRadius:self.cornerRadius];
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarIsDark?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:YES];
    [UIView animateWithDuration:self.animationDuration delay:0.0f usingSpringWithDamping:self.springCoef initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.containerView setFrame:CGRectMake(self.pointInFill.x, self.pointInFill.y, self.frame.size.width, self.frame.size.height)];
        [self.statusBarView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.layer setShadowOpacity:self.shadowOpacity];
        [self addSubview:self.containerView];
        [self.containerView setFrame:self.bounds];
        [self.statusBarView removeFromSuperview];
        self.isMaximized = NO;
    }];
}
- (void)toggleMaxMin{
    if (self.isMaximized)
        [self minimize];
    else
        [self maximize];
}
- (UIView *)getSuper{
    UIView *tempView = self.superview;
    while (tempView.superview != nil)
        tempView = tempView.superview;
    return tempView;
}
- (CGPoint)calculatePointInView:(UIView *)fillView{
    UIView *tempView = self;
    CGPoint point = CGPointMake(0, 0);
    while (tempView != fillView && tempView != nil){
        point.x += tempView.frame.origin.x;
        point.y += tempView.frame.origin.y;
        tempView = tempView.superview;
    }
    return point;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.cornerRadius] CGPath]];
    [self.containerView setFrame:self.bounds];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self.containerView.layer setCornerRadius:self.cornerRadius];
    [self.layer setShadowRadius:self.shadowRadius];
    [self.layer setShadowOpacity:self.shadowOpacity];
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.containerView.layer.bounds cornerRadius:self.cornerRadius] CGPath]];
}

@end
