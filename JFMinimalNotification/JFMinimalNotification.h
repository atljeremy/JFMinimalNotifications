/*
 * JFMinimalNotification
 *
 * Created by Jeremy Fox on 5/4/13.
 * Copyright (c) 2013 Jeremy Fox. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>

@protocol JFMinimalNotificationDelegate;

typedef NS_ENUM(NSInteger, JFMinimalNotificationStytle) {
    JFMinimalNotificationStyleDefault,
    JFMinimalNotificationStyleError,
    JFMinimalNotificationStyleSuccess,
    JFMinimalNotificationStyleInfo,
    JFMinimalNotificationStyleWarning
};

typedef void (^JFMinimalNotificationTouchHandler)(void);

@interface JFMinimalNotification : UIView


#pragma mark ----------------------
#pragma mark Properties
#pragma mark ----------------------

/**
 * @return The titleLabel used to display the title text in the notification.
 */
@property (nonatomic, strong, readonly) UILabel* titleLabel;

/**
 * @return The subTitleLabel used to display the title text in the notification.
 */
@property (nonatomic, strong, readonly) UILabel* subTitleLabel;

/**
 * @return The UIView displayed in the left accessory view of the notification.
 */
@property (nonatomic, strong, readonly) UIView* leftAccessoryView;

/**
 * @return The UIView displayed in the right accessory view of the notification.
 */
@property (nonatomic, strong, readonly) UIView* rightAccessoryView;

/**
 * @return The current JFMinimalNotificationStytle of the notification
 */
@property (nonatomic, readonly) JFMinimalNotificationStytle currentStyle;

/**
 * @return Used to present the notification from the top of the screen
 */
@property (nonatomic, assign) BOOL presentFromTop;

/**
 * @return The JFMinimalNotificationDelegate
 */
@property (nonatomic, weak) id<JFMinimalNotificationDelegate> delegate;


#pragma mark ----------------------
#pragma mark Custom Initialization
#pragma mark ----------------------

/**
 * @return a helper class method to instantiate a notification and set the desired style, title and subtitle.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 */
+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style
                                title:(NSString*)title
                             subTitle:(NSString*)subTitle;

/**
 * @return a helper class method to instantiate a notification and set the desired style, title, subtitle and dismissalDelay.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @param dismissalDelay The amount of time the notification should be displayed before being dismissed.
 */
+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style
                                title:(NSString*)title
                             subTitle:(NSString*)subTitle
                       dismissalDelay:(NSTimeInterval)dismissalDelay;

/**
 * @return a helper class method to instantiate a notification and set the desired style, title, subtitle, dismissalDelay and touchHandler.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @param dismissalDelay The amount of time the notification should be displayed before being dismissed.
 * @param touchHandler The touch handler callback block that will be invoked when the notification is tapped.
 */
+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style
                                title:(NSString*)title
                             subTitle:(NSString*)subTitle
                       dismissalDelay:(NSTimeInterval)dismissalDelay
                         touchHandler:(JFMinimalNotificationTouchHandler)touchHandler;

#pragma mark ----------------------
#pragma mark Presentation
#pragma mark ----------------------

/**
 * @return presents the notification
 */
- (void)show;

/**
 * @return Dismisses the notification
 */
- (void)dismiss;


#pragma mark ----------------------
#pragma mark Appearance
#pragma mark ----------------------

/**
 * @return Updates the JFMinimalNotificationStytle of the notification
 * @param style The desired JFMinimalNotificationStytle
 */
- (void)setStyle:(JFMinimalNotificationStytle)style animated:(BOOL)animated;

/**
 * @return Sets the title label font
 * @param font The desired UIFont to be set as the title labels font
 */
- (void)setTitleFont:(UIFont*)font;

/**
 * @return Sets the sub-title label font
 * @param font The desired UIFont to be set as the sub-title label font
 */
- (void)setSubTitleFont:(UIFont*)font;

/**
 * @return Sets the left view
 * @param view The desired UIView to be set as the left view
 */
- (void)setLeftAccessoryView:(UIView*)view animated:(BOOL)animated;

/**
 * @return Sets the right view
 * @param view The desired UIView to be set as the right view
 */
- (void)setRightAccessoryView:(UIView*)view animated:(BOOL)animated;

@end

@protocol JFMinimalNotificationDelegate <NSObject>

@optional
- (void)willShowNotification:(JFMinimalNotification*)notification;
- (void)didShowNotification:(JFMinimalNotification*)notification;
- (void)willDisimissNotification:(JFMinimalNotification*)notification;
- (void)didDismissNotification:(JFMinimalNotification*)notification;

@end
