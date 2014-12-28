/*
 * UIColor+JFMinimalNotificationColors
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
