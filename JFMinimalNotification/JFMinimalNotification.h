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

@interface JFMinimalNotification : UIView

/**
 *
 */
+ (JFMinimalNotification*)notificationWithStyle:(JFMinimalNotificationStytle)style superView:(UIView*)view;

/**
 * Custom Initialization
 *
 * @return JFMinimalNotification This is the required init method that must be used to initialize a JFMinimalNotification view.
 * @param view the view in which to present the JFMinimalNotification in
 */
- (id)initWithSuperView:(UIView*)view;

/**
 *
 */
- (void)show;

/**
 *
 */
- (void)dismiss;

- (void)setStyle:(JFMinimalNotificationStytle)style;

/**
 *
 */
- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle;

/**
 *
 */
- (void)setTitleFont:(UIFont*)font;

/**
 *
 */
- (void)setSubTitleFont:(UIFont*)font;

/**
 *
 */
- (void)setTitleColor:(UIColor*)color;

/**
 *
 */
- (void)setSubTitleColor:(UIColor*)color;

/**
 *
 */
- (void)setLeftImage:(UIImage*)image;

/**
 *
 */
- (void)setRightImage:(UIImage*)image;

@end
