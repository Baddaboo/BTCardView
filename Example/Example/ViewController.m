//
//  ViewController.m
//  Example
//
//  Created by Blake Tsuzaki on 5/31/15.
//  Copyright (c) 2015 Modoki. All rights reserved.
//

#import "ViewController.h"

#define NUM_CARDS 3

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) BTMaximizableView *tempView;
@property (nonatomic) NSInteger baseSpacing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < NUM_CARDS; i++){
        BTMaximizableView *tempView = (BTMaximizableView *)[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cardExample"] view];
        [self.array addObject:tempView];
    }
    [self.cardView setDelegate:self];
    [self.cardView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setDelegate:self];
    self.baseSpacing = [self.cardView cardSpacing];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 0){
        [self.cardView setCardSpacing:self.baseSpacing*((self.cardView.frame.origin.y-scrollView.contentOffset.y)/self.cardView.frame.origin.y)];
    }
    else if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height){
        [self.cardView setCardSpacing:self.baseSpacing*((self.cardView.frame.origin.y-scrollView.contentOffset.y)/self.cardView.frame.origin.y)];
    }
}

- (NSInteger)numberOfItemsInCardView:(BTCardView *)cardView{
    return NUM_CARDS;
}

- (NSInteger)spacingForCardView:(BTCardView *)cardView{
    return 60;
}

- (UIView *)cardView:(BTCardView *)cardView viewForItemAtIndex:(NSInteger)position{
    return [self.array objectAtIndex:position];
}

- (UIButton *)cardView:(BTCardView *)cardView buttonForItemAtIndex:(NSInteger)position{
    UIButton *tempButton = [[self.array objectAtIndex:position] button];
    return tempButton;
}

- (void)cardView:(BTCardView *)cardView selectedAtIndex:(NSInteger)index{
    if (index == 0){
        self.tempView = (BTMaximizableView *)[cardView viewForItemAtIndex:index];
        [[self.tempView button] addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempView toggleMaxMin];
    }
}
- (void)closeWindow:(UIButton *)sender{
    [sender removeTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    [self.tempView toggleMaxMin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCard:(id)sender {
    BTMaximizableView *tempView = (BTMaximizableView *)[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cardExample"] view];
    [self.array insertObject:tempView atIndex:0];
    [self.cardView addItemToFront:tempView];
    self.baseSpacing = [self.cardView cardSpacing];
}

- (IBAction)removeCard:(id)sender {
    [self.cardView removeItemWithIndex:0];
    [self.array removeObjectAtIndex:0];
    self.baseSpacing = [self.cardView cardSpacing];
}
@end
