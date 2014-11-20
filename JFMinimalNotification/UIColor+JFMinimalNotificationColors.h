//
//  UIColor+JFMinimalNotificationColors.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 11/18/14.
//  Copyright (c) 2014 Jeremy Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define hsb(_H, _S, _B) [UIColor colorWithHue:_H/360.0f saturation:_S/100.0f brightness:_B/100.0f alpha:1.0]

@interface UIColor (JFMinimalNotificationColors)

+ (instancetype)notificationGreenColor;
+ (instancetype)notificationRedColor;
+ (instancetype)notificationYellowColor;
+ (instancetype)notificationBlueColor;
+ (instancetype)notificationBlackColor;
+ (instancetype)notificationWhiteColor;
+ (instancetype)notificationOrangeColor;

@end
