//
//  JFMinimalNotification.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFMinimalNotificationDelegate;

typedef NS_ENUM(NSInteger, JFMinimalNotificationStytle) {
    JFMinimalNotificationStyleDefault,
    JFMinimalNotificationStyleError,
    JFMinimalNotificationStyleSuccess,
    JFMinimalNotificationStyleInfo
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
 * @return The JFMinimalNotificationDelegate
 */
@property (nonatomic, weak) id<JFMinimalNotificationDelegate> delegate;


#pragma mark ----------------------
#pragma mark Custom Initialization
#pragma mark ----------------------

/**
 * @return a helper class method to instantiate a notification and set the desired style and super view.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @exception JFMinimalNotificationInvalidInitializationException This exception will be thrown if you try to create a new notification without passing in a super view.
 */
+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style
                                title:(NSString*)title
                             subTitle:(NSString*)subTitle;

/**
 * @return a helper class method to instantiate a notification and set the desired style and super view.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @param dismissalDelay The amount of time the notification should be displayed before being dismissed.
 * @exception JFMinimalNotificationInvalidInitializationException This exception will be thrown if you try to create a new notification without passing in a super view.
 */
+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style
                                title:(NSString*)title
                             subTitle:(NSString*)subTitle
                       dismissalDelay:(NSTimeInterval)dismissalDelay;

/**
 * @return a helper class method to instantiate a notification and set the desired style and super view.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @param dismissalDelay The amount of time the notification should be displayed before being dismissed.
 * @param touchHandler The touch handler callback block that will be invoked when the notification is tapped.
 * @exception JFMinimalNotificationInvalidInitializationException This exception will be thrown if you try to create a new notification without passing in a super view.
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
- (void)setStyle:(JFMinimalNotificationStytle)style;

/**
 * @return Sets/Updates a notifications title and subtitle text
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 */
- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle;

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
- (void)setLeftAccessoryView:(UIView*)view;

/**
 * @return Sets the right view
 * @param view The desired UIView to be set as the right view
 */
- (void)setRightAccessoryView:(UIView*)view;

@end

@protocol JFMinimalNotificationDelegate <NSObject>

@optional
- (void)willShowNotification:(JFMinimalNotification*)notification;
- (void)didShowNotification:(JFMinimalNotification*)notification;
- (void)willDisimissNotification:(JFMinimalNotification*)notification;
- (void)didDismissNotification:(JFMinimalNotification*)notification;

@end
