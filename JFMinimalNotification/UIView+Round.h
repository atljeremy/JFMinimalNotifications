//
//  UIView+Round.h
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 11/17/14.
//  Copyright (c) 2014 Jeremy Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Round)

- (void)makeRound;
- (void)makeRoundWithBorderWidth:(CGFloat)width borderColor:(UIColor*)color;

@end
