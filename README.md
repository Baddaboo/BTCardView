# BTCardView
A simple random-access, stacked-card iOS view.

![alt text](http://gifyu.com/images/2015-06-0421_22_01.gif)

In this project, I created a simple stacked-card view using the maximizable view (also in my repo). I also added a little scrolling bounce effect purely out of boredom during my school's finals week. There are still a few bugs and improvements I'm planning to implement, but for the most part, I hope you'll enjoy it as much as I had making it!

## Installation
Simply add the BTCardView Objective-C class into an existing project. Views can be generated programatically, or through Interface Builder and configured accordingly, but must be added using the delegate functions.

## Installation for beginners
1. Drag `BTCardView.h` and `BTCardView.m` into your project directory
2. Go to `[project] -> [target] -> Build Phases -> Compile Sources` and ensure `BTCardView.m` is listed
3. Go back to Interface Builder and drag a *View* object from the Object Library into the desired view controller
4. Under the Identity Inspector, change the class type to `BTCardView`
5. Add the following to the diesired view controller header: `#import "BTCardView.h"`
6. Follow the delegate functions as you would with a typical table/collection view

### Adding the maximizable functions:
Simply use the optional `cardView:selectedAtIndex:` delegate function to determine if the frontmost card is selected and toggle the maximizable view. Unfortunately, going into full-screen does mean that the view hierarchy will break, and you'll need to find another way to trigger it to minimize (in my example, I simply add an extra target). Hopefully after finals, I can come up with a better solution.

### Adding the rubberband scroll effect:
Add the `UIScrollViewDelegate` in the desired view, and add your `scrollViewDidScroll:` function. Then, you'll simply need to adjust the card view's spacing using the `setCardSpacing:` function whenever you scroll past the y-axis boundaries. In this case, I used:
```objectivec
if(scrollView.contentOffset.y < 0){
        [self.cardView setCardSpacing:self.baseSpacing*((self.cardView.frame.origin.y-scrollView.contentOffset.y)/self.cardView.frame.origin.y)];
    }
    else if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height){
        [self.cardView setCardSpacing:self.baseSpacing*((self.cardView.frame.origin.y-scrollView.contentOffset.y)/self.cardView.frame.origin.y)];
    }
}
```

## TODO
* Support for screen rotation
* Bug fixes

## License
Licensed under the MIT License.
