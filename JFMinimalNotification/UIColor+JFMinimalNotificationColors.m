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
    static UIColor *green = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        green = hsb(145, 77, 80);
    });
    
    return green;
}

+ (instancetype)notificationRedColor
{
    static UIColor *red = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        red = hsb(6, 74, 91);
    });
    
    return red;
}

+ (instancetype)notificationYellowColor
{
    static UIColor *yellow = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        yellow = hsb(48, 83, 100);
    });
    
    return yellow;
}

+ (instancetype)notificationBlueColor
{
    static UIColor *blue = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        blue = hsb(224, 50, 63);
    });
    
    return blue;
}

+ (instancetype)notificationBlackColor
{
    static UIColor *black = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        black = hsb(0, 0, 17);
    });
    
    return black;
}

+ (instancetype)notificationWhiteColor
{
    static UIColor *white = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        white = hsb(192, 2, 95);
    });
    
    return white;
}

+ (instancetype)notificationOrangeColor
{
    static UIColor *orange = nil;
    static dispatch_once_t dispatchToken;
    
    dispatch_once(&dispatchToken, ^{
        orange = hsb(28, 85, 90);
    });
    
    return orange;
}

@end
