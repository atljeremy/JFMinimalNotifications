//
//  UIView+Round.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 11/17/14.
//  Copyright (c) 2014 Jeremy Fox. All rights reserved.
//

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
