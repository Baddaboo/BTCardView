# BTMaximizableView
A simple maximizable iOS view, with Interface Builder integration

![alt text](http://gifyu.com/images/2015-06-0317_00_08.gif)

## Installation
Simply add the BTMaximizableView Objective-C class into an existing project. Views can be generated programatically, or through Interface Builder and configured accordingly.

### Note
Make sure that `UIViewControllerBasedStatusBarAppearance` is set to `NO` in your plist file.

## Installation for beginners
1. Drag `BTMaximizableViewView.h` and `BTMaximizableView.m` into your project directory.
2. Go to `[project] -> [target] -> Build Phases -> Compile Sources` and ensure `BTMaximizableView.m` is listed.
3. Go back to Interface Builder and drag a *View* object from the Object Library into the desired view controller
4. Under the Identity Inspector, change the class type to `BTMaximizableView`
5. Add the following to the diesired view controller header: `#import "BTMaximizableView.h"`
6. Using the Assistant Editor, hold down control and add references to the maximizable view and the trigger (typically, a button IBAction)
7. Call the `toggleMaxMin` function wherever you would like to invoke maximizing or minimizing the view
8. To have the status bar automatically change depending on the background color of your maximizable view, open your info.plist file and create a new key `View controller-based status bar appearance` and set the value to ``NO``


## TODO
* Adding card layout support ;)
* Support for screen rotation
* Bug fixes

## License
Licensed under the MIT License.
