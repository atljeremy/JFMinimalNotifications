/*
 * UIView+Round
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

#import "UIView+Round.h"

@implementation UIView (Round)

- (void)makeRound
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    CGRect f = self.frame;
    CGFloat w = CGRectGetWidth(f);
    CGFloat h = CGRectGetHeight(f);
    CGFloat corner = w;
    if (h > w) { // Portrait Orientation
        f.size.height = w;
    } else if (w > h) { // Landscape Orientation
        f.size.width = h;
        corner = h;
    }
    self.frame = f;
    self.layer.cornerRadius = (corner / 2);
    [self layoutIfNeeded];
}

- (void)makeRoundWithBorderWidth:(CGFloat)width borderColor:(UIColor*)color
{
    [self makeRound];
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [color CGColor];
}


@end
