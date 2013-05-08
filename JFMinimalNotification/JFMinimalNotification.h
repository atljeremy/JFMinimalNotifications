//
//  JFMinimalNotification.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JFMinimalNotificationStyleDefault,
    JFMinimalNotificationStyleError,
    JFMinimalNotificationStyleSuccess
} JFMinimalNotificationStytle;

typedef enum {
    JFMinimalNotificationCloseBtnPositionLeft,
    JFMinimalNotificationCloseBtnPositionRight
} JFMinimalNotificationCloseBtnPosition;

@interface JFMinimalNotification : UIView

/**
 * @return The current JFMinimalNotificationStytle of the notification
 */
@property (nonatomic, readonly) JFMinimalNotificationStytle currentStyle;


/*****************************************************************************
 * Custom Initialization
 ****************************************************************************/

/**
 * @return a helper class method to instantiate a notification and set the desired style and super view.
 * @param style The desired JFMinimalNotificationStytle for this notification
 * @param view the super UIView that this notification will be presented in
 * @param title The desired title string
 * @param subTitle The desired sub-title string
 * @exception JFMinimalNotificationInvalidInitializationException This exception will be thrown if you try to create a new notification without passing in a super view.
 */
+ (JFMinimalNotification*)notificationWithStyle:(JFMinimalNotificationStytle)style
                                          title:(NSString*)title
                                       subTitle:(NSString*)subTitle
                                      superView:(UIView*)view;

/**
 * @return JFMinimalNotification This is the required init method that must be used to initialize a JFMinimalNotification view.
 * @param view the view in which to present the JFMinimalNotification in
 * @exception JFMinimalNotificationInvalidInitializationException This exception will be thrown if you try to create a new notification without passing in a super view.
 */
- (id)initWithSuperView:(UIView*)view;


/*****************************************************************************
 * Presentation
 ****************************************************************************/

/**
 * @return presents the notification
 */
- (void)show;

/**
 * @return Dismisses the notification
 */
- (void)dismiss;


/*****************************************************************************
 * Appearance
 ****************************************************************************/

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
 * @return Sets the title label text color
 * @param color The desired UIColor to be set as the title label text color
 */
- (void)setTitleColor:(UIColor*)color;

/**
 * @return Sets the title label text color
 * @param color The desired UIColor to be set as the sub-title label text color
 */
- (void)setSubTitleColor:(UIColor*)color;

/**
 * @return Sets the left view
 * @param view The desired UIView to be set as the left view
 */
- (void)setLeftView:(UIView*)view;

/**
 * @return Sets the right view
 * @param view The desired UIView to be set as the right view
 */
- (void)setRightView:(UIView*)view;

/**
 * @return Sets the position of the close button
 * @param position The desired JFMinimalNotificationCloseBtnPosition to be used for the close button position
 */
- (void)setCloseButtonPosition:(JFMinimalNotificationCloseBtnPosition)positon;

@end
