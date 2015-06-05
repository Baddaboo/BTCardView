//
//  ViewController.h
//  Example
//
//  Created by Blake Tsuzaki on 5/31/15.
//  Copyright (c) 2015 Modoki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMaximizableView.h"
#import "BTCardView.h"

@interface ViewController : UIViewController <BTCardViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet BTCardView *cardView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)addCard:(id)sender;
- (IBAction)removeCard:(id)sender;


@end

