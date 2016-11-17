JFMinimalNotification
===========

This is an iOS UIView for presenting a beautiful notification that is highly configurable and works for both iPhone and iPad. JFMinimalNotification is only available in ARC and targets iOS 7.0+.

[![CocoaPods](https://img.shields.io/cocoapods/v/JFMinimalNotifications.svg)](https://cocoapods.org/pods/JFMinimalNotifications)
[![CocoaPods](https://img.shields.io/cocoapods/dt/JFMinimalNotifications.svg)](https://cocoapods.org/pods/JFMinimalNotifications) 
[![CocoaPods](https://img.shields.io/cocoapods/at/JFMinimalNotifications.svg)](https://cocoapods.org/pods/JFMinimalNotifications)
[![CocoaPods](https://img.shields.io/cocoapods/l/JFMinimalNotifications.svg?maxAge=2592000)]() 
[![CocoaPods](https://img.shields.io/cocoapods/p/JFMinimalNotifications.svg?maxAge=2592000)]()

Looking for an Android version? Garrett Franks created one and it's awesome, check it out: [https://github.com/gfranks/GFMinimalNotifications](https://github.com/gfranks/GFMinimalNotifications)

What It Looks Like:
------------------

![Example](https://dl.dropboxusercontent.com/u/55388810/example.gif) ![Example](https://dl.dropboxusercontent.com/u/55388810/exampletop.gif)

See a short video of this control here: [https://www.youtube.com/watch?v=jDYC-NYKl9A](https://www.youtube.com/watch?v=jDYC-NYKl9A)

### Screen Shots

![Examples](https://dl.dropboxusercontent.com/u/55388810/JFMinimalNotificationExample.jpeg)
<!-- ![Success With Left View](https://imageshack.us/a/img713/7325/screenshot20130508at125.png)
![Success](https://imageshack.us/a/img560/7325/screenshot20130508at125.png)
![Error](https://imageshack.us/a/img43/7325/screenshot20130508at125.png)
![Default](https://imageshack.us/a/img856/7325/screenshot20130508at125.png)  -->

Installation:
------------

### CocoaPods

`pod 'JFMinimalNotifications', '~> 0.0.8'`

### Directly include source into your projects

- Simply copy the source files from the "JFMinimalNotification" folder into your project.
- In your application's project app target settings, find the "Build Phases" section and open the "Link Binary With Libraries" block and click the "+" button and select the "CoreGraphics.framework".


How To Use It:
-------------

### Basic Example

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     * Create the notification
     */
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleDefault title:@"This is my awesome title" subTitle:@"This is my awesome sub-title"];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont fontWithName:@"STHeitiK-Light" size:22];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"STHeitiK-Light" size:16];
    [self.minimalNotification setSubTitleFont:subTitleFont];

    /**
     * Set any necessary edge padding as needed
     */
    self.minimalNotification.edgePadding = UIEdgeInsetsMake(0, 0, 10, 0);

    /**
     * Add the notification to a view
     */
    [self.view addSubview:self.minimalNotification];
}

/**
 * Showing the notification from a button handler
 */
- (IBAction)show:(id)sender {
    [self.minimalNotification show];
}

/**
 * Hiding the notification from a button handler
 */
- (IBAction)dismiss:(id)sender {
    [self.minimalNotification dismiss];
}
```

### Constructors / Options

```objective-c
/**
 * Note: passing a dismissalDelay of 0 means the notification will NOT be automatically dismissed, you will need to 
 * dismiss the notification yourself by calling -dismiss on the notification object. If you pass a dismissalDelay 
 * value greater than 0, this will be the length of time the notification will remain visisble before being 
 * automatically dismissed.
 */
 
// With dismissalDelay
self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"This is my awesome title" subTitle:@"This is my awesome sub-title" dismissalDelay:3.0];
 
// Without dismissalDelay and with touchHandler
self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"This is my awesome title" subTitle:@"This is my awesome sub-title" dismissalDelay:0.0 touchHandler:^{
    [self.minimalNotification dismiss];
}];
```

```objective-c
// Available Styles
typedef NS_ENUM(NSInteger, JFMinimalNotificationStyle) {
    JFMinimalNotificationStyleDefault,
    JFMinimalNotificationStyleError,
    JFMinimalNotificationStyleSuccess,
    JFMinimalNotificationStyleInfo,
    JFMinimalNotificationStyleWarning,
    
    /**
     * @return Used to get a title and subtitle, no accessory views, and white bg with black label text. Use the .bakgroundColor property on the notification to set the desired background color and .textColor property on the titleLabel and subTitleLabel UILabel's to change text color.
     */
    JFMinimalNotificationStyleCustom,
    
    /**
     * @return A dark blur with vibrancy effect in the bakground with white label text.
     */
    JFMinimalNotificationStyleBlurDark,
    
    /**
     * @return A light blur with vibrancy effect in the bakground with black label text.
     */
    JFMinimalNotificationStyleBlurLight
};
```

Please see the example project include in this repo for an example of how to use this notification.
    
Delegate Methods:
----------------

    - (void)minimalNotificationWillShowNotification:(JFMinimalNotification*)notification;
    - (void)minimalNotificationDidShowNotification:(JFMinimalNotification*)notification;
    - (void)minimalNotificationWillDisimissNotification:(JFMinimalNotification*)notification;
    - (void)minimalNotificationDidDismissNotification:(JFMinimalNotification*)notification;
   
License
-------
Copyright (c) 2012 Jeremy Fox ([jeremyfox.me](http://www.jeremyfox.me)). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
