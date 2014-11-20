//
//  UIColor+JFMinimalNotificationColors.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 11/18/14.
//  Copyright (c) 2014 Jeremy Fox. All rights reserved.
//

#import "UIColor+JFMinimalNotificationColors.h"

@implementation UIColor (JFMinimalNotificationColors)

+ (instancetype)notificationGreenColor
{
    return hsb(145, 77, 80);
}

+ (instancetype)notificationRedColor
{
    return hsb(6, 74, 91);
}

+ (instancetype)notificationYellowColor
{
    return hsb(48, 83, 100);
}

+ (instancetype)notificationBlueColor
{
    return hsb(224, 50, 63);
}

+ (instancetype)notificationBlackColor
{
    return hsb(0, 0, 17);
}

+ (instancetype)notificationWhiteColor
{
    return hsb(192, 2, 95);
}

+ (instancetype)notificationOrangeColor
{
    return hsb(28, 85, 90);
}

@end
