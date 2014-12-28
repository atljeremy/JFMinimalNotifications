/*
 * JFMinimalNotificationArt
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

@interface JFMinimalNotificationArt : NSObject

+ (UIImage*)imageOfCheckmarkWithColor:(UIColor*)color;

+ (UIImage*)imageOfCrossWithColor:(UIColor*)color;

+ (UIImage*)imageOfNoticeWithColor:(UIColor*)color;

+ (UIImage*)imageOfWarningWithBGColor:(UIColor*)backgroundColor forgroundColor:(UIColor*)forgroundColor;

+ (UIImage*)imageOfInfoWithColor:(UIColor*)color;

+ (UIImage*)imageOfEditWithColor:(UIColor*)color;

+ (void)drawCheckmarkWithColor:(UIColor*)color;

+ (void)drawCrossWithColor:(UIColor*)color;

+ (void)drawNoticeWithColor:(UIColor*)color;

+ (void)drawWarningWithBGColor:(UIColor*)backgroundColor forgroundColor:(UIColor*)forgroundColor;

+ (void)drawInfoWithColor:(UIColor*)color;

+ (void)drawEditWithColor:(UIColor*)color;

@end
